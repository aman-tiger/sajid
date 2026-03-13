const admin = require("firebase-admin");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");

admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();
const remoteConfig = admin.remoteConfig();

const DAYS = [2, 4, 7, 10, 15, 20, 30];

async function getPushTemplates() {
  const template = await remoteConfig.getTemplate();
  const params = template.parameters || {};

  const read = (key) => params[key]?.defaultValue?.value || "";
  const dayTexts = {};
  for (const day of DAYS) {
    dayTexts[day] = read(`push_inactive_day_${day}`);
  }

  return {
    noSubHour1: read("push_no_sub_h1"),
    noSubDay2: read("push_no_sub_d2"),
    noSubDay5: read("push_no_sub_d5"),
    noSubDay7: read("push_no_sub_d7"),
    fridayGameNight: read("push_weekend_gamenight"),
    activeWelcome: read("push_active_welcome"),
    churnedDay1: read("push_churned_d1"),
    inactivityByDay: dayTexts,
  };
}

function shouldFireByDays(fromDate, toDate, thresholdDays) {
  if (!fromDate) return false;
  const diffMs = toDate.getTime() - fromDate.getTime();
  const days = Math.floor(diffMs / (1000 * 60 * 60 * 24));
  return days === thresholdDays;
}

function shouldFireByHours(fromDate, toDate, thresholdHours) {
  if (!fromDate) return false;
  const diffMs = toDate.getTime() - fromDate.getTime();
  const hours = Math.floor(diffMs / (1000 * 60 * 60));
  return hours === thresholdHours;
}

async function sendToToken(token, title, body) {
  if (!token || !body) return;
  await messaging.send({
    token,
    notification: {
      title: title || "Never Have I Ever",
      body,
    },
  });
}

async function processUserPushes(userDoc, now, templates) {
  const data = userDoc.data();
  const token = data.fcmToken;
  const segment = data.subscriptionSegment;

  const onboardingAt = data.onboardingCompletedAt?.toDate?.();
  const lastActiveAt = data.lastActiveAt?.toDate?.();
  const subscriptionExpiredAt = data.subscriptionExpiredAt?.toDate?.();
  const purchasedAt = data.subscriptionPurchasedAt?.toDate?.();
  const localHour = typeof data.localHour === "number" ? data.localHour : 0;
  const localWeekday = typeof data.localWeekday === "number" ? data.localWeekday : 0;

  if (segment === "active_subscription" && purchasedAt) {
    if (shouldFireByHours(purchasedAt, now, 0)) {
      await sendToToken(token, "Premium", templates.activeWelcome);
    }
  }

  if (segment === "churned" && subscriptionExpiredAt) {
    if (shouldFireByDays(subscriptionExpiredAt, now, 1)) {
      await sendToToken(token, "Subscription", templates.churnedDay1);
    }
  }

  if (segment === "no_subscription" && onboardingAt) {
    if (shouldFireByHours(onboardingAt, now, 1)) {
      await sendToToken(token, "Trial", templates.noSubHour1);
    }
    if (shouldFireByDays(onboardingAt, now, 2)) {
      await sendToToken(token, "Trial", templates.noSubDay2);
    }
    if (shouldFireByDays(onboardingAt, now, 5)) {
      await sendToToken(token, "Trial", templates.noSubDay5);
    }
    if (shouldFireByDays(onboardingAt, now, 7)) {
      await sendToToken(token, "Trial", templates.noSubDay7);
    }
  }

  if (lastActiveAt) {
    for (const day of DAYS) {
      if (shouldFireByDays(lastActiveAt, now, day)) {
        await sendToToken(token, "Come Back", templates.inactivityByDay[day]);
      }
    }
  }

  const isFridayOrSaturday = localWeekday === 5 || localWeekday === 6;
  if (isFridayOrSaturday && localHour === 19) {
    await sendToToken(token, "Game Night", templates.fridayGameNight);
  }
}

exports.sendScheduledPushes = onSchedule(
  {
    schedule: "every 1 hours",
    timeZone: "Etc/UTC",
  },
  async () => {
    const templates = await getPushTemplates();
    const now = new Date();
    const snapshot = await db.collection("user_push_state").get();

    for (const userDoc of snapshot.docs) {
      try {
        await processUserPushes(userDoc, now, templates);
      } catch (error) {
        logger.error("push_schedule_failed", {
          userId: userDoc.id,
          error: error?.message || String(error),
        });
      }
    }
  },
);

# Never Have I Ever (Flutter)

Production mobile app for iOS and Android with:
- Multi-language question packs
- Qonversion subscriptions
- Firebase Analytics / Crashlytics / FCM
- AppsFlyer and Amplitude instrumentation
- Sentry error reporting

## Requirements
- Flutter SDK (project currently uses `l10n.yaml` for localization generation)
- Firebase project connected (`google-services.json`, `GoogleService-Info.plist`)
- Qonversion project key configured in app secrets
- AppsFlyer keys configured in app secrets

## Run
```bash
flutter pub get
flutter gen-l10n
flutter run
```

## Localization
Localization source files are under `lib/l10n/*.arb`.

After any localization change:
```bash
flutter gen-l10n
```

## Question Assets
Question JSON files are in:
- `assets/questions/Classic/`
- `assets/questions/party-vibe-check/`
- `assets/questions/girls only/`
- `assets/questions/Couple/`
- `assets/questions/hot-spicy/`
- `assets/questions/bros only/`

## Subscription Flow
- Qonversion offerings are loaded in `PaywallPage`.
- Purchase emits one final success state to prevent double-transition UI bugs.
- Subscription segment is synced to Firebase user properties:
  - `no_subscription`
  - `active_subscription`
  - `churned`

## Push Notifications (FCM + Cloud Functions)
Server code is in `functions/`.

### Implemented Contract
- Scheduled dispatcher: `functions/index.js` (`sendScheduledPushes`)
- Target collection: `user_push_state`
- Segment field: `subscriptionSegment`
- Notification texts come from Firebase Remote Config parameters:
  - `push_no_sub_h1`
  - `push_no_sub_d2`
  - `push_no_sub_d5`
  - `push_no_sub_d7`
  - `push_inactive_day_2`
  - `push_inactive_day_4`
  - `push_inactive_day_7`
  - `push_inactive_day_10`
  - `push_inactive_day_15`
  - `push_inactive_day_20`
  - `push_inactive_day_30`
  - `push_weekend_gamenight`
  - `push_active_welcome`
  - `push_churned_d1`

### Client-side state written for scheduling
- `fcmToken`
- `subscriptionSegment`
- `onboardingCompletedAt`
- `subscriptionPurchasedAt`
- `subscriptionExpiredAt`
- `lastActiveAt`
- `localHour`
- `localWeekday`

## Release Checklist
- iOS TestFlight build tested end-to-end purchase flow
- Android Internal Testing build tested end-to-end purchase flow
- Privacy policy and terms links verified on device
- Firebase Analytics, Crashlytics, AppsFlyer, Amplitude, and Qonversion events verified with screenshots
- App Store Connect metadata complete
- Google Play Console metadata complete


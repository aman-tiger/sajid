# Never Have I Ever - Mobile Party Game

A fun, interactive mobile party game application built with Flutter for iOS and Android.

## 📱 Project Overview

**Never Have I Ever** is a cross-platform mobile application that brings the classic party game to your smartphone. Users can choose from various question categories, swipe through cards, and enjoy a seamless gaming experience with friends.

### Platforms
- **iOS:** 15.0+
- **Android:** 9.0+ (API 24+)

### Tech Stack
- **Framework:** Flutter 3.38.7
- **Language:** Dart 3.10.7
- **State Management:** Flutter Bloc / Provider
- **Analytics:** Firebase, Amplitude
- **Monetization:** In-App Purchases, Superwall SDK
- **Crash Reporting:** Sentry

## 🎯 Features

### Phase 1 (Current)
- ✅ 4 Onboarding screens with push notifications & review request
- ✅ Main menu with category selection carousel
- 🔒 6 game categories (Classic free, 5 premium)

### Upcoming Phases
- Question card swipe interface
- Settings & language selection
- Paywall integration
- In-app purchases
- Multi-language support (EN, ES, DE, FR, KO)
- Offline-first functionality

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.38.7 or higher
- Dart SDK 3.10.7 or higher
- iOS development: Xcode 14+, macOS
- Android development: Android Studio, Android SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sajid
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # iOS
   flutter run -d ios

   # Android
   flutter run -d android
   ```

### Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── routes/
│   ├── theme/
│   └── utils/
├── features/
│   ├── onboarding/
│   ├── main_menu/
│   ├── game/
│   └── settings/
└── l10n/
```

## 🎨 Design Guidelines

This project follows a unique design system that is **70%+ different** from competitors:
- Custom color palette
- Unique typography
- Original illustrations (no copyright)
- Cohesive spacing system
- Consistent UI components

**Note:** All designs are original and do not copy competitor apps.

## 📦 Dependencies

See `pubspec.yaml` for the complete list of dependencies.

### Core Packages
- `flutter_bloc` - State management
- `go_router` - Navigation
- `carousel_slider` - Category carousel
- `permission_handler` - Permissions handling
- `in_app_review` - Review requests
- `flutter_screenutil` - Responsive design

### Integrations (to be added)
- Firebase (Analytics, Crashlytics, FCM)
- Amplitude (Analytics)
- Superwall (Paywall management)
- Sentry (Error tracking)

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run on specific device
flutter run -d <device-id>
```

## 📋 Development Workflow

1. Check project plan: `info/PROJECT_PLAN.md`
2. Track progress: `info/PROGRESS_LOG.md`
3. Create feature branch
4. Implement & test
5. Commit with clear messages
6. Push to repository

## 🔐 Environment Setup

### 1. Environment Variables Setup

This project uses environment variables to securely store API keys and sensitive data.

#### Step 1: Create .env file
```bash
cp .env.example .env
```

#### Step 2: Update .env with your API keys
Edit the `.env` file and replace placeholder values with your actual credentials:

```env
# Firebase Configuration
FIREBASE_ANDROID_API_KEY=your-actual-android-api-key
FIREBASE_IOS_API_KEY=your-actual-ios-api-key

# Amplitude Analytics
AMPLITUDE_API_KEY=your-actual-amplitude-api-key

# Sentry Error Tracking
SENTRY_DSN=your-actual-sentry-dsn

# Qonversion Subscriptions
QONVERSION_PROJECT_KEY=your-actual-qonversion-project-key
```

**⚠️ Important:** Never commit the `.env` file to version control. It's already in `.gitignore`.

### 2. Firebase Configuration Files

#### Android Setup
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/google-services.json`
3. The file is gitignored for security

Template available at: `android/app/google-services.json.template`

#### iOS Setup
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/GoogleService-Info.plist`
3. Add to Xcode project (Runner target)
4. The file is gitignored for security

Template available at: `ios/Runner/GoogleService-Info.plist.template`

### 3. Verify Setup

Run the app to verify all configurations are loaded correctly:
```bash
flutter run
```

Check console for initialization messages:
- ✅ Environment config loaded
- ✅ Firebase initialized successfully
- ✅ Amplitude initialized successfully
- ✅ Sentry initialized successfully

### Security Notes

- All API keys are loaded from environment variables
- Never hardcode sensitive data in source code
- Firebase config files are excluded from git
- Use separate configurations for dev/staging/production

## 📱 App Store Release

### Pre-Release Checklist
- [ ] All features implemented per specification
- [ ] E2E tests passing
- [ ] TestFlight internal testing complete
- [ ] Firebase Test Lab / BrowserStack testing complete
- [ ] App Store Connect metadata complete
- [ ] Google Play Console metadata complete
- [ ] Screenshots prepared
- [ ] Privacy Policy URL configured

## 📄 Documentation

- **Technical Specification:** See `info/technical_specification_ever.pdf`
- **Project Plan:** See `info/PROJECT_PLAN.md`
- **Progress Tracking:** See `info/PROGRESS_LOG.md`
- **Figma Reference (functionality only):** [Link in specification]

## 🐛 Issue Reporting

Report issues via GitHub Issues with:
- Device & OS version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/logs if applicable

## 📞 Support & Communication

- Text-based communication (no audio messages)
- Video calls with pre-planned agenda
- All tasks tracked in GitHub Issues
- Response time for critical bugs: 24 hours

## 📝 License

This project is proprietary. All rights reserved.

## 🤝 Contributing

This is a client project. External contributions are not accepted.

---

**Project Status:** Phase 1 - In Development
**Last Updated:** 2026-01-25
**Version:** 1.0.0-dev

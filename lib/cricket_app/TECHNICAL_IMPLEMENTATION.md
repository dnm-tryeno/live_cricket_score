# Cricket App - Technical Implementation Guide

## ✅ Implemented Features

### 1. Firebase Analytics ✅
- **Service**: `lib/cricket_app/shared/services/firebase_analytics_service.dart`
- **Features**:
  - App open event tracking
  - Screen view tracking (automatic via NavigatorObserver)
  - Custom event logging
- **Usage**: Automatically tracks app opens and screen views

### 2. Firebase Remote Config ✅
- **Service**: `lib/cricket_app/shared/services/firebase_remote_config_service.dart`
- **Features**:
  - Ad control (enable/disable ads remotely)
  - Platform-specific ad control (iOS AdEx / Android AdMob)
  - Ad frequency control
  - Feature flags
- **Default Values**:
  - `ads_enabled`: true
  - `banner_ads_enabled`: true
  - `interstitial_ads_enabled`: true
  - `rewarded_ads_enabled`: true
  - `ad_frequency`: 3 (show ad after every 3 screens)
  - `ios_adex_enabled`: false
  - `android_admob_enabled`: true

### 3. API Integration ✅
- **Service**: `lib/cricket_app/shared/services/api_service.dart`
- **Endpoints**:
  - `/api/matches/live` - Live matches
  - `/api/matches/upcoming` - Upcoming matches
  - `/api/matches/finished` - Finished matches
  - `/api/matches/{id}` - Match details
  - `/api/stats` - Statistics
  - `/api/news` - News
- **Note**: Update `baseUrl` in `api_service.dart` with your backend URL

### 4. Ad Integration ✅
- **Android**: AdMob integration with Remote Config control
- **iOS**: AdMob integration (AdEx can be configured via Remote Config)
- **Service**: `lib/cricket_app/shared/services/cricket_ad_service.dart`
- **Features**:
  - Banner ads with Remote Config control
  - Ad frequency management
  - Platform-specific ad unit IDs
  - Test ad IDs for development

### 5. Screen Analytics Tracking ✅
- Splash screen tracking
- Home screen tracking
- Automatic screen view tracking via NavigatorObserver

## 📋 Setup Instructions

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Firebase Setup

#### Install Firebase CLI (if not already installed)
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

#### Configure Firebase
```bash
# For dev environment
flutterfire configure \
  --project=dev-cricketgo \
  --platforms=android,ios \
  --android-package-name=com.cricket.captain.expense.mgmt.dev \
  --ios-bundle-id=com.cricket.captain.expense.mgmt.dev \
  --out=lib/firebase_options_dev.dart

# For prod environment
flutterfire configure \
  --project=prod-cricketgo \
  --platforms=android,ios \
  --android-package-name=com.cricket.captain.expense.mgmt \
  --ios-bundle-id=com.cricket.captain.expense.mgmt \
  --out=lib/firebase_options_prod.dart
```

#### Update Firebase Initialization
After generating `firebase_options.dart`, update `lib/main/cricket_main.dart`:
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Step 3: Configure Remote Config in Firebase Console

1. Go to Firebase Console → Remote Config
2. Add the following parameters:
   - `ads_enabled` (Boolean): true
   - `banner_ads_enabled` (Boolean): true
   - `interstitial_ads_enabled` (Boolean): true
   - `rewarded_ads_enabled` (Boolean): true
   - `ad_frequency` (Number): 3
   - `ios_adex_enabled` (Boolean): false
   - `android_admob_enabled` (Boolean): true

### Step 4: Update Ad Unit IDs

#### Android AdMob
Update in `lib/cricket_app/shared/services/cricket_ad_service.dart`:
```dart
return 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX'; // Your AdMob Banner Ad Unit ID
```

#### iOS AdEx/AdMob
Update in `lib/cricket_app/shared/services/cricket_ad_service.dart`:
```dart
return 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX'; // Your iOS Ad Unit ID
```

### Step 5: Update API Base URL

Update in `lib/cricket_app/shared/services/api_service.dart`:
```dart
static const String baseUrl = 'https://your-backend-api.com';
```

## 📱 Ad Integration Details

### Banner Ads
- Automatically shown on Home screen
- Controlled via Remote Config
- Platform-specific ad unit IDs

### Ad Frequency
- Controlled via Remote Config `ad_frequency` parameter
- Default: Show ad after every 3 screen views
- Can be adjusted remotely without app update

### Platform Support
- **Android**: AdMob (controlled via Remote Config)
- **iOS**: AdMob (AdEx can be enabled via Remote Config flag)

## 🔍 Testing

### Test Ad Unit IDs (Already Configured)
- iOS: `ca-app-pub-3940256099942544/2934735716`
- Android: `ca-app-pub-3940256099942544/6300978111`

### Test API Connectivity
```dart
final isConnected = await ApiService.testConnection();
print('API Connected: $isConnected');
```

### Test Remote Config
```dart
await FirebaseRemoteConfigService.fetchAndActivate();
print('Ads Enabled: ${FirebaseRemoteConfigService.adsEnabled}');
```

## 📊 Analytics Events

### Automatic Events
- `app_open` - Logged on app launch
- `screen_view` - Logged automatically for each screen

### Custom Events
```dart
FirebaseAnalyticsService.logEvent(
  name: 'match_viewed',
  parameters: {'match_id': '123'},
);
```

## 🚀 Deployment Checklist

- [ ] Firebase project configured
- [ ] `firebase_options.dart` generated
- [ ] Remote Config parameters set in Firebase Console
- [ ] Ad Unit IDs updated (production)
- [ ] API base URL updated
- [ ] Test ads working
- [ ] Analytics tracking verified
- [ ] Remote Config fetching working

## 📝 Notes

1. **Firebase Options**: The `firebase_options.dart` file is generated by `flutterfire configure` and should be added to `.gitignore` if it contains sensitive information.

2. **Remote Config**: Default values are used if Remote Config fails to fetch. This ensures the app works even without internet connection.

3. **Ad Control**: Ads can be completely disabled via Remote Config without requiring an app update.

4. **API Service**: The API service includes error handling and timeout management. Update the base URL before production deployment.

5. **iOS AdEx**: Currently using AdMob for iOS. To use AdEx, update the ad unit IDs and enable via Remote Config flag `ios_adex_enabled`.

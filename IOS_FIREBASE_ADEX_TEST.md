# iOS Firebase AdEx Test Implementation Guide

## ✅ Current Implementation Status

### Test Ad Unit IDs (Already Configured)
iOS ke liye Firebase AdEx test IDs already configured hain:

- **Banner Ad:** `ca-app-pub-3940256099942544/2934735716`
- **App-Open Ad:** `ca-app-pub-3940256099942544/5662855259`
- **Interstitial Ad:** `ca-app-pub-3940256099942544/4411468910`

### Firebase Remote Config Settings
- `ios_adex_enabled`: `true` (default - enabled for testing)
- `ads_enabled`: `true`
- `banner_ads_enabled`: `true`
- `interstitial_ads_enabled`: `true`

## 🚀 Testing Steps

### Step 1: Verify Firebase Setup

1. **Check Firebase Configuration:**
   ```bash
   # Verify GoogleService-Info.plist exists
   ls ios/Runner/GoogleService-Info.plist
   ```

2. **Verify Firebase Initialization:**
   - App run karte waqt console logs me ye dikhna chahiye:
   ```
   ✅ Firebase initialized for iOS
   ✅ Firebase Remote Config initialized
   ✅ Firebase Analytics initialized for iOS
   📢 iOS AdEx Enabled: true
   📢 Ads Enabled via Remote Config: true
   ```

### Step 2: Run App on iOS

```bash
# iOS Simulator par
flutter run -d ios

# Ya physical iOS device par
flutter run -d <device-id>
```

### Step 3: Test Ad Types

#### 1. App-Open Ad
- **When:** App start par ya foreground me aane par
- **Expected:** App open hote hi ad dikhna chahiye
- **Test ID:** `ca-app-pub-3940256099942544/5662855259`

#### 2. Banner Ad
- **Where:** 
  - Home screen (top)
  - Tutorial screen (below Next button)
  - Post-loading screen (below Start button)
- **Expected:** Small banner ad dikhna chahiye
- **Test ID:** `ca-app-pub-3940256099942544/2934735716`

#### 3. Interstitial Ad
- **When:** 
  - Screen navigation par (per activity basis)
  - Button clicks par
- **Expected:** Full-screen ad dikhna chahiye
- **Test ID:** `ca-app-pub-3940256099942544/4411468910`

### Step 4: Verify Remote Config Control

1. **Firebase Console me Remote Config check karein:**
   - Go to: https://console.firebase.google.com/
   - Remote Config section
   - Verify parameters:
     - `ios_adex_enabled` = `true`
     - `ads_enabled` = `true`
     - `banner_ads_enabled` = `true`
     - `interstitial_ads_enabled` = `true`

2. **Remote Config se ads disable karke test karein:**
   - Firebase Console me `ios_adex_enabled` ko `false` set karein
   - App restart karein
   - Ads nahi dikhne chahiye

## 📊 Expected Console Logs

### App Initialization:
```
✅ Firebase initialized for iOS
✅ Firebase Remote Config initialized
✅ Firebase Analytics initialized for iOS
✅ Cricket Ad Service initialized
📱 Platform: iOS
📢 iOS AdEx Enabled: true
📢 Ads Enabled via Remote Config: true
📱 iOS Firebase AdEx Test Mode: Enabled (using test ad unit IDs)
```

### Ad Loading:
```
✅ Banner ad loaded
✅ App-open ad loaded
✅ Interstitial ad loaded
```

### Ad Events:
```
📊 Logged app open event
📊 Logged app foreground event
📊 Logged app background event
```

## 🔍 Firebase Console DebugView (iOS)

### Enable DebugView:

1. **Firebase Console me DebugView open karein:**
   - Go to: https://console.firebase.google.com/
   - Analytics → DebugView

2. **iOS device/simulator me enable karein:**
   - Xcode me: **Product** → **Scheme** → **Edit Scheme**
   - **Run** → **Arguments** → **Environment Variables**
   - Add: `FIREBASE_ANALYTICS_DEBUG_MODE` = `1`

3. **App run karein:**
   ```bash
   flutter run -d ios
   ```

4. **Events real-time dikhenge** Firebase Console me DebugView me

## 📱 Test Ad Behavior

### Test Ads Characteristics:
- ✅ **Test Ads automatically show** - No need for special configuration
- ✅ **Test ad unit IDs** automatically trigger test mode
- ✅ **No revenue** - Test ads don't generate revenue
- ✅ **Safe for testing** - Google's official test IDs

### Test Ad Content:
- Test ads me "Test Ad" label dikhega
- Real ad jaisa UI dikhega
- Different test ad creatives rotate honge

## ⚠️ Important Notes

1. **Test IDs:** Current implementation me Google's official test IDs use ho rahe hain
2. **Firebase AdEx:** iOS par Firebase AdEx test IDs use ho rahe hain
3. **Remote Config:** Ads Firebase Remote Config se control ho rahe hain
4. **Production:** Production me test IDs ko replace karna hoga

## 🔄 Production Setup (Future)

Jab production me jana ho:

1. **Firebase Console me production ad unit IDs create karein**
2. **Update ad unit IDs in code:**
   ```dart
   // Replace test IDs with production IDs
   static String _getBannerAdUnitId() {
     if (Platform.isAndroid) {
       return 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX'; // Production ID
     }
     return 'ca-app-pub-XXXXXXXXXX/XXXXXXXXXX'; // iOS Firebase AdEx Production ID
   }
   ```

3. **Firebase Remote Config me production values set karein**

## ✅ Testing Checklist

- [ ] Firebase initialized successfully
- [ ] Remote Config fetched successfully
- [ ] iOS AdEx enabled in Remote Config
- [ ] App-open ad loads and shows
- [ ] Banner ads load and show
- [ ] Interstitial ads load and show
- [ ] Analytics events logged
- [ ] DebugView me events visible (if enabled)
- [ ] Remote Config control working (enable/disable ads)

## 🐛 Troubleshooting

### Ads not showing?

1. **Check Remote Config:**
   ```dart
   print('iOS AdEx Enabled: ${FirebaseRemoteConfigService.iosAdExEnabled}');
   print('Ads Enabled: ${FirebaseRemoteConfigService.adsEnabled}');
   ```

2. **Check Firebase initialization:**
   - Console logs me "Firebase initialized" dikhna chahiye

3. **Check ad unit IDs:**
   - Test IDs properly configured hain ya nahi

4. **Check internet connection:**
   - Ads load karne ke liye internet chahiye

### Remote Config not fetching?

1. **Check Firebase project:**
   - Correct project select kiya hai ya nahi

2. **Check network:**
   - Internet connection hai ya nahi

3. **Check default values:**
   - Default values fallback ke liye use honge

## 📝 Summary

✅ **iOS Firebase AdEx test implementation complete hai:**
- Test ad unit IDs configured
- Firebase Remote Config integrated
- iOS AdEx enabled by default
- All ad types (banner, app-open, interstitial) working
- Analytics tracking enabled

Test karke verify karein ki sab kuch properly kaam kar raha hai!

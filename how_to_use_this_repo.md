
## How to use this repo
📌 Notes
1. Make sure to copy and paste the .gitignore files from each folder: mobile/, android/, and ios/.
These will ensure all generated and build-related files are properly ignored.

2. Before creating a PR for a new project, run android and ios both apps, double-check that no generated files are committed — review all .gitignore configurations to confirm they're in place.

3. 🔁 **\[Optional]** This step can be skipped if needed, but all other steps **must** be completed.

Steps.

### 🔁 [Optional] Rename Project Name (in `pubspec.yaml`)

1. Open the `pubspec.yaml` file.
   Change the first line:

   ```yaml
   name: flutter_project
   ```

   to something like:

   ```yaml
   name: xyz_nice_app
   ```

2. Open your code editor's **search window** (e.g., VSCode or IntelliJ) and search for:

   ```
   package:flutter_project
   ```

   Replace **all occurrences** with:

   ```
   package:xyz_nice_app
   ```

   This updates all import statements to use the new package name.

3. After renaming, run the build generate command to fix compile issues.

---


### Android

Step. Rename android package name as below

dinakarmaurya@Dinakars-MacBook-Pro flutter-app % dart run change_app_package_name:main com.aryatech.cricketlivescore --android

Renaming package for Android only.
Running for android
Old Package Name: ccom.fluter.template.delqui
Updating build.gradle File
...

Step. Rename android display name on play store
android/app/src/dev/res/values/strings.xml -> DevFlutterTemplate
android/app/src/dev/res/values/strings.xml -> StgFlutterTemplate
android/app/src/prod/res/values/strings.xml -> FlutterTemplate

d
---

### iOS
Step. Rename iOS package name as below

dinakarmaurya@Dinakars-MacBook-Pro flutter-app % dart run change_app_package_name:main com.aryatech.cricketlivescore --ios
Building package executable... 
...

Step. Rename iOS App Display Name (Shown on iPhone Home Screen)
Update the app’s display name by setting the Product Name in Xcode:
Target > Build Settings > Product Name
📌 Tip: Use the same name as defined in App Store Connect for consistency.
Dev - DevFlutterTemplate
Prod - FlutterTemplate

Step. Change iOS 

#### 📦 `CFBundleName` – What It Is & How to Rename
* Used as the .app folder name when exporting .ipa. Example fluttertemplate.app
* Internal app name used by iOS (not shown to users)
* Appears in logs, crash reports, and as the `.app` bundle name
* Must be short, lowercase, no spaces or special characters

- 🔧 Recommended Names

* `fluttertemplate`, `gatherly` , `eventmanagement`

- ✏️ How to Change

1. Open `ios/Runner/Info.plist`
2. Find:

   ```xml
   <key>CFBundleName</key>
   <string>fluttertemplatebundle</string>
   ```
3. Replace with:

   ```xml
   <string>xyzbundle</string>
   ```

#### 🔁 [Optional]  📲 iOS Provisioning & Bundle ID Setup

Use the following bundle IDs per environment:

* `com.flutter.template.delqui.dev` → for local development and testing
* `com.flutter.template.delqui` → for production builds

Create these provisioning profiles in the Apple Developer Portal:

* `com.flutter.template.delqui-local` → for running on physical devices
* `com.flutter.template.delqui-app-connect` → for App Store Connect distribution

Set the correct bundle ID and provisioning profile in Xcode under **Signing & Capabilities** based on your target environment.

* Note - similar for stg
---

### 🎨 Change App Icon

* Place a PNG image at: `flutter-app/assets/icon.png`
  *(Recommended size: 512x512 with transparent background)*

* Run the following command to generate Android, iOS app icons:

```bash
dart pub run flutter_launcher_icons:main
```

* Note after generate drag dopo icon using xcode to correc the reference

> This will automatically generate the necessary icon files for Android, iOS based on the provided image.

---

### 🚧 Firebase Setup Reminder
* https://firebase.google.com/docs/flutter/setup?platform=ios

### 🔧 Firebase Setup (Android & iOS)
* Note: When running the command, deselect Web and select only Android and iOS apps.
* Create firebase apps for dev, prod etc.
A. 🔧 Setup Instructions

**Prerequisites:** 
- Node.js and npm must be installed. If not installed, install from: https://nodejs.org/

**Step 1: Install Firebase CLI (Required)**

FlutterFire CLI requires Firebase CLI to be installed first. Install it using npm:

```bash
npm install -g firebase-tools
```

**Verify Firebase CLI installation:**
```bash
firebase --version
```

**Step 2: Install FlutterFire CLI**

Run this command in your terminal:
```bash
dart pub global activate flutterfire_cli
```

**Important:** After installation, make sure the `dart pub global bin` directory is in your PATH. If the `flutterfire` command is not found, add this to your shell profile (`.zshrc` or `.bash_profile`):

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Then reload your terminal or run:
```bash
source ~/.zshrc
```

**Verify FlutterFire CLI installation:**
```bash
flutterfire --version
```

**Note:** If you get "command not found" in a new terminal session, make sure to run `source ~/.zshrc` in that session.

**Step 3: Run the configuration command**
Replace the following values in the example command below:

dev-flutter-template-4fe65 → Replace with your Firebase project ID from the Firebase Console.

com.flutter.template.delqui.dev → Replace with your package name.

firebase_options_dev.dart, firebase_options_stg.dart, or firebase_options_prod.dart → Use the appropriate file based on the environment you are setting up (dev, stg, or prod).

**Before running the commands below, make sure:**
1. PATH is set: `export PATH="$PATH:$HOME/.pub-cache/bin"` (or run `source ~/.zshrc`)
2. Firebase login is done: `firebase login`

#### For dev android
```bash
flutterfire configure \
  --project=dev-cricketgo \
  --platforms=android \
  --android-package-name=com.cricket.captain.expense.mgmt.dev \
  --out=lib/firebase_options_dev.dart
```

#### For dev ios
```bash
flutterfire configure \
  --project=dev-cricketgo \
  --platforms=ios \
  --ios-bundle-id=com.cricket.captain.expense.mgmt.dev \
  --out=lib/firebase_options_dev.dart
```

#### For dev android and ios boht
```bash
flutterfire configure \
  --project=dev-cricketgo \
  --platforms=android,ios \
  --android-package-name=com.cricket.captain.expense.mgmt.dev \
  --ios-bundle-id=com.cricket.captain.expense.mgmt.dev \
  --out=lib/firebase_options_dev.dart
```

#### For prod android
```bash
flutterfire configure \
  --project=prod-cricketgo \
  --platforms=android \
  --android-package-name=com.cricket.captain.expense.mgmt \
  --out=lib/firebase_options_prod.dart
```

#### For prod ios
```bash
flutterfire configure \
  --project=prod-cricketgo \
  --platforms=ios \
  --ios-bundle-id=com.cricket.captain.expense.mgmt \
  --out=lib/firebase_options_prod.dart
```

#### For prod android and ios boht
```bash
flutterfire configure \
  --project=prod-cricketgo \
  --platforms=android,ios \
  --android-package-name=com.cricket.captain.expense.mgmt \
  --ios-bundle-id=com.cricket.captain.expense.mgmt \
  --out=lib/firebase_options_prod.dart
```

B. Note
Currently, please ignore the upload Crashlytics code in the project.pbxproj file.
It is causing issues by trying to upload large crash log files (several MBs), which leads to failures when uploading the iOS build to Firebase using gituhub actions.
Do not commit any changes related to this for now.

firebase use prod-flutter-template
✅ Creates `firebase_options_dev.dart` and downloads config files for Android/iOS. Already added to gitignore so this file will not be committed.

* ✅ **Only the `dev` environment is currently configured**
* Example: 🛠 To enable `prod`, create a new Firebase project (or app within the same project) and complete the setup.
* 📂 Replace the following files with the correct production versions:
  * `android/app/src/prod/google-services.json`
  * `ios/firebase/GoogleService-Info-prod.plist`
* search initiFirebase() and fix TODO
* Follow and setup https://firebase.google.com/docs/flutter/setup?platform=ios, https://firebase.google.com/docs/crashlytics
* ✅ Crashlytics is working for the Android app
* 🔧 To enable Crashlytics for the iOS app, you must **upload dSYM files**

---
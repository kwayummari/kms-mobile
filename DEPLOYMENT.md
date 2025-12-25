# Mobile App Deployment Guide

This guide covers the steps to prepare and deploy the KMS mobile app for production.

## Prerequisites

- Flutter SDK installed and configured
- Android Studio (for Android builds)
- Xcode (for iOS builds, macOS only)
- Google Play Console account (for Android)
- Apple Developer account (for iOS)

## Version Management

The app version is defined in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
Format: `version_name+build_number`
- Version name: Displayed to users (e.g., 1.0.0)
- Build number: Incremented for each release (e.g., +1, +2, +3)

**Before each release:**
1. Update the version in `pubspec.yaml`
2. For Android: The build number becomes `versionCode`
3. For iOS: The build number becomes `CFBundleVersion`

## Android Deployment

### 1. Generate Release Keystore

If you don't have a release keystore yet, generate one:

```bash
cd android
keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000
```

**Important:** 
- Store the keystore file securely (it cannot be recovered if lost)
- Keep the passwords safe
- The keystore is required for all future updates

### 2. Configure Signing

1. Copy `key.properties.example` to `key.properties`:
   ```bash
   cp android/key.properties.example android/key.properties
   ```

2. Edit `android/key.properties` and fill in your keystore details:
   ```
   storeFile=release.keystore
   storePassword=your_keystore_password
   keyAlias=release
   keyPassword=your_key_password
   ```

3. Ensure `release.keystore` is in the `android/` directory

4. **Add to .gitignore:**
   ```
   android/key.properties
   android/release.keystore
   ```

### 3. Build Release APK

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

### 4. Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

The AAB will be generated at: `build/app/outputs/bundle/release/app-release.aab`

### 5. Upload to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Go to Production → Create new release
4. Upload the `.aab` file
5. Fill in release notes
6. Review and publish

## iOS Deployment

### 1. Configure Bundle Identifier

The bundle identifier is set in:
- `ios/Runner.xcodeproj/project.pbxproj` → `PRODUCT_BUNDLE_IDENTIFIER`
- Currently: `com.example.kms`

**Important:** 
- Update this to your actual bundle identifier before deployment
- Note: Android uses `com.kikoba.management.system` as applicationId, which can differ from iOS bundle ID
- Ensure the iOS bundle ID matches your App Store Connect app configuration

### 2. Configure Signing in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner project in the navigator
3. Select the Runner target
4. Go to "Signing & Capabilities" tab
5. Select your development team
6. Ensure "Automatically manage signing" is checked
7. Verify the bundle identifier matches your App Store Connect app

### 3. Update Version and Build Number

The version is pulled from `pubspec.yaml`. Ensure it's updated before building.

### 4. Build for Release

```bash
flutter build ios --release
```

### 5. Archive and Upload to App Store Connect

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Any iOS Device" or a connected device
3. Go to Product → Archive
4. Once archived, click "Distribute App"
5. Follow the prompts to upload to App Store Connect

### 6. Submit for Review

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Go to the version you uploaded
4. Fill in all required information (screenshots, description, etc.)
5. Submit for review

## Pre-Deployment Checklist

### General
- [ ] Update version number in `pubspec.yaml`
- [ ] Test the app thoroughly on both platforms
- [ ] Verify all API endpoints are production-ready
- [ ] Check that `.env` file has production values (if applicable)
- [ ] Review and update app permissions in AndroidManifest.xml and Info.plist
- [ ] Ensure app icons and splash screens are properly configured

### Android Specific
- [ ] Release keystore generated and configured
- [ ] `key.properties` file created with correct values
- [ ] `key.properties` and `release.keystore` added to `.gitignore`
- [ ] Test release build locally
- [ ] Verify ProGuard rules don't break functionality
- [ ] Check app size and optimize if needed

### iOS Specific
- [ ] Bundle identifier updated to production value
- [ ] Signing configured in Xcode
- [ ] Test on physical iOS device
- [ ] Verify all required app icons are present
- [ ] Check Info.plist for required permissions and descriptions
- [ ] Ensure App Store Connect app is created with matching bundle ID

## Step-by-Step Manual Deployment Process

### Step 1: Clean the Project
```bash
cd kms-mobile
flutter clean
```

### Step 2: Get Dependencies
```bash
flutter pub get
```

### Step 3: Generate Release Keystore (Android - First Time Only)
```bash
cd android
keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000
cd ..
```

**Important:** Save the passwords securely - you'll need them for all future updates!

### Step 4: Configure Release Signing
Update `android/key.properties` with your release keystore details:
```
storeFile=release.keystore
storePassword=your_keystore_password
keyAlias=release
keyPassword=your_key_password
```

### Step 5: Build Android Release APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Step 6: Build Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### Step 7: Build iOS Release (macOS only)
```bash
flutter build ios --release
```
Then open `ios/Runner.xcworkspace` in Xcode to archive and upload.

## Build Commands Reference

### Android
```bash
# Debug build
flutter build apk --debug

# Release APK
flutter build apk --release

# Release App Bundle (for Play Store)
flutter build appbundle --release

# Build with specific build number
flutter build apk --release --build-number=2
```

### iOS
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release

# Build with specific build number
flutter build ios --release --build-number=2
```

## Troubleshooting

### Android Build Issues

**Issue:** "Keystore file not found"
- Solution: Ensure `release.keystore` exists in `android/` directory
- Verify the path in `key.properties` is correct

**Issue:** "Signing config not found"
- Solution: Check that `key.properties` exists and has correct values
- Verify keystore file path is relative to `android/` directory

**Issue:** App crashes after ProGuard optimization
- Solution: Add keep rules to `proguard-rules.pro` for affected classes
- Test release builds thoroughly before deployment

### iOS Build Issues

**Issue:** "No signing certificate found"
- Solution: Configure signing in Xcode with your Apple Developer account
- Ensure your developer certificate is installed

**Issue:** "Bundle identifier mismatch"
- Solution: Update bundle identifier in Xcode project settings
- Ensure it matches your App Store Connect app

## Security Notes

- **Never commit** `key.properties` or `release.keystore` to version control
- Store keystore files securely (use password managers or secure vaults)
- Use different keystores for different apps
- Keep backup copies of keystore files in secure locations
- Document keystore passwords securely (not in code or plain text files)

## Additional Resources

- [Flutter Deployment Documentation](https://docs.flutter.dev/deployment)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [iOS App Distribution](https://developer.apple.com/distribute/)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)


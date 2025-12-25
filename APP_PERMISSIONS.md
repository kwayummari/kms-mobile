# App Permissions - SmartCoba

## Android Permissions (AndroidManifest.xml)

### Network & Connectivity
1. **INTERNET** - Required for API calls and network communication
2. **ACCESS_NETWORK_STATE** - Check network connectivity status

### Phone & SMS (for USSD payments)
3. **CALL_PHONE** - Make phone calls for USSD transactions
4. **READ_PHONE_STATE** - Read phone state for USSD operations
5. **READ_SMS** - Read SMS messages (for payment confirmations)
6. **RECEIVE_SMS** - Receive SMS messages (for payment notifications)
7. **SEND_SMS** - Send SMS messages (for payment confirmations)

### Storage
8. **READ_EXTERNAL_STORAGE** - Read files from external storage (reports, documents)
9. **WRITE_EXTERNAL_STORAGE** - Write files to external storage (export reports, save documents)

### Camera
10. **CAMERA** - Take photos for profile pictures and document scanning

### Location
11. **ACCESS_FINE_LOCATION** - Precise location for branch services
12. **ACCESS_COARSE_LOCATION** - Approximate location for branch services

### System
13. **VIBRATE** - Vibration for notifications
14. **WAKE_LOCK** - Keep device awake for background processing
15. **FOREGROUND_SERVICE** - Run foreground service for payment processing
16. **POST_NOTIFICATIONS** - Show notifications (Android 13+)

---

## iOS Permissions (Info.plist)

**Note:** iOS permissions are declared at runtime when requested. The following permissions should be added to Info.plist with usage descriptions:

### Required iOS Permission Descriptions (to be added):

1. **NSCameraUsageDescription** - "We need access to your camera to take profile pictures and scan documents."

2. **NSPhotoLibraryUsageDescription** - "We need access to your photo library to select profile pictures and documents."

3. **NSLocationWhenInUseUsageDescription** - "We need your location to help you find nearby Vikoba branches and services."

4. **NSLocationAlwaysAndWhenInUseUsageDescription** - "We need your location to provide branch services and location-based features."

5. **NSContactsUsageDescription** - (If needed) "We need access to contacts to invite members to your Vikoba."

6. **NSMicrophoneUsageDescription** - (If needed) "We need microphone access for voice features."

---

## Permission Categories Summary

### Critical Permissions (Required for Core Functionality)
- ✅ **INTERNET** - Essential for all API calls
- ✅ **ACCESS_NETWORK_STATE** - Check connectivity

### Sensitive Permissions (Require User Approval)
- ⚠️ **CALL_PHONE** - Dangerous permission (Android)
- ⚠️ **READ_SMS / SEND_SMS** - Dangerous permissions (Android)
- ⚠️ **CAMERA** - Dangerous permission (Android)
- ⚠️ **LOCATION** - Dangerous permission (Android)
- ⚠️ **STORAGE** - Dangerous permission (Android 10+)

### Standard Permissions (Auto-granted)
- ✅ **VIBRATE** - Auto-granted
- ✅ **WAKE_LOCK** - Auto-granted
- ✅ **FOREGROUND_SERVICE** - Auto-granted
- ✅ **POST_NOTIFICATIONS** - Runtime permission (Android 13+)

---

## Google Play Store Permission Declaration

When submitting to Google Play, you'll need to declare:

1. **Phone** - For USSD payments and phone state
2. **SMS** - For payment confirmations
3. **Storage** - For file downloads and exports
4. **Camera** - For profile pictures and document scanning
5. **Location** - For branch services
6. **Notifications** - For app notifications

---

## Recommendations

### Consider Removing (if not actively used):
- **READ_SMS / SEND_SMS** - Only if USSD doesn't require SMS
- **LOCATION** - Only if branch services don't need location
- **CAMERA** - Only if profile pictures/document scanning isn't implemented

### Privacy Policy Requirements:
All these permissions must be explained in your Privacy Policy, which you already have in `privacy_policy.html`.

---

## Next Steps

1. **Add iOS permission descriptions** to Info.plist
2. **Review which permissions are actually used** in the codebase
3. **Update Privacy Policy** if any permissions are removed
4. **Declare permissions** in Google Play Console and App Store Connect




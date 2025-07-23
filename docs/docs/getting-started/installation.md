---
sidebar_position: 1
---

# Installation

This guide will walk you through installing Flutter In-App Purchase in your Flutter project.

## Requirements

- Flutter 2.5.0 or higher
- Dart 2.14.0 or higher
- iOS 11.0+ / macOS 10.15+
- Android 5.0 (API level 21) or higher

## Installation Steps

### 1. Add the dependency

Add `flutter_inapp_purchase` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_inapp_purchase: ^5.6.2
```

### 2. Install the package

Run the following command to install the package:

```bash
flutter pub get
```

### 3. Platform-specific setup

#### iOS Setup

No additional setup is required for iOS. The plugin will automatically link with StoreKit.

However, you'll need to:
1. Enable In-App Purchase capability in Xcode
2. Configure your products in App Store Connect
3. Set up your agreements and tax information

#### Android Setup

Add the billing permission to your `AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="com.android.vending.BILLING" />
    
    <application>
        <!-- Your application configuration -->
    </application>
</manifest>
```

### 4. Import the package

In your Dart code, import the package:

```dart
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
```

## Verify Installation

To verify the installation is working correctly:

```dart
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

void checkInstallation() async {
  try {
    // Initialize the connection
    var result = await FlutterInappPurchase.instance.initialize();
    print('IAP initialized: $result');
    
    // Check if billing is available
    if (result == 'Billing is unavailable') {
      print('Billing is not available on this device');
    } else {
      print('Billing is available!');
    }
  } catch (e) {
    print('Error initializing IAP: $e');
  }
}
```

## Troubleshooting

### iOS Issues

1. **"StoreKit not available"**: Make sure you're testing on a real device or simulator with a signed-in Apple ID
2. **Products not loading**: Verify your products are configured correctly in App Store Connect and approved

### Android Issues

1. **"Billing unavailable"**: Ensure Google Play Store is installed and updated
2. **Permission denied**: Check that the BILLING permission is added to AndroidManifest.xml
3. **Products not loading**: Verify your products are active in Google Play Console

## Next Steps

- [iOS Setup Guide](./setup-ios) - Configure App Store Connect and Xcode
- [Android Setup Guide](./setup-android) - Configure Google Play Console
- [Quick Start Guide](./quickstart) - Implement your first purchase
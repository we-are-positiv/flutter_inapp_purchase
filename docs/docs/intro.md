---
sidebar_position: 1
---

# Flutter In-App Purchase

A Flutter plugin for in-app purchases on iOS and Android, providing a unified API for handling purchases across both platforms.

## Features

- 🔄 **Cross-platform Support**: Works seamlessly on both iOS and Android
- 🎯 **Simple API**: Easy-to-use methods for product management and purchases
- 🛡️ **Error Handling**: Comprehensive error handling with platform-specific error codes
- 🎣 **Stream-based**: Real-time purchase updates via streams
- 📱 **Flutter Compatible**: Built specifically for Flutter with null safety support
- 🔍 **Receipt Validation**: Built-in receipt validation helpers
- 💎 **Products & Subscriptions**: Support for both one-time purchases and subscriptions

## Quick Start

### Installation

```bash
flutter pub add flutter_inapp_purchase
```

### Basic Usage

```dart
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// Initialize connection
await FlutterInappPurchase.instance.initialize();

// Get products (consumables and non-consumables)
List<IAPItem> products = await FlutterInappPurchase.instance.requestProducts(
  skus: ['com.example.product1', 'com.example.product2'],
  type: 'inapp',
);

// Get subscriptions
List<IAPItem> subscriptions = await FlutterInappPurchase.instance.requestProducts(
  skus: ['com.example.premium_monthly'],
  type: 'subs',
);

// Request purchase
await FlutterInappPurchase.instance.requestPurchase('com.example.product1');

// Listen to purchase updates
FlutterInappPurchase.purchaseUpdatedStream.listen((item) {
  // Handle purchase update
});
```

## Platform Setup

### iOS Setup

1. Configure your products in App Store Connect
2. Add In-App Purchase capability to your Xcode project
3. Update your `Info.plist` if needed

### Android Setup

1. Configure your products in Google Play Console
2. Add billing permission to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="com.android.vending.BILLING" />
```

## What's Next?

- [Installation Guide](./getting-started/installation) - Detailed installation instructions
- [iOS Setup](./getting-started/setup-ios) - Complete iOS configuration guide
- [Android Setup](./getting-started/setup-android) - Complete Android configuration guide
- [Quick Start](./getting-started/quickstart) - Get up and running quickly

## Support

- [GitHub Issues](https://github.com/hyochan/flutter_inapp_purchase/issues)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter-inapp-purchase)
- [Discord Community](https://discord.gg/hyo)
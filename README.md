# flutter_inapp_purchase

<p align="center">
  <img src="https://flutter-inapp-purchase.hyo.dev/img/logo.png" width="200" alt="flutter_inapp_purchase logo" />
</p>

<p align="center">
  <a href="https://pub.dartlang.org/packages/flutter_inapp_purchase"><img src="https://img.shields.io/pub/v/flutter_inapp_purchase.svg?style=flat-square" alt="Pub Version" /></a>
  <a href="https://github.com/hyochan/flutter_inapp_purchase/actions/workflows/ci.yml"><img src="https://github.com/hyochan/flutter_inapp_purchase/actions/workflows/ci.yml/badge.svg" alt="Flutter CI" /></a>
  <a href="https://codecov.io/gh/hyochan/flutter_inapp_purchase"><img src="https://codecov.io/gh/hyochan/flutter_inapp_purchase/branch/main/graph/badge.svg?token=WXBlKvRB2G" alt="Coverage Status" /></a>
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" />
</p>

<p align="center">
  A comprehensive Flutter plugin for implementing in-app purchases on iOS and Android platforms.
</p>

## 📚 Documentation

For comprehensive documentation, installation guides, API reference, and examples, visit:

**🌐 [flutter-inapp-purchase.hyo.dev](https://flutter-inapp-purchase.hyo.dev)**

## 📦 Installation

```yaml
dependencies:
  flutter_inapp_purchase: ^6.0.0-rc.1
```

## 🔧 Quick Start

```dart
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// Initialize connection
await FlutterInappPurchase.instance.initConnection();

// Get products
final products = await FlutterInappPurchase.instance.getProducts(['product_id']);

// Request purchase
await FlutterInappPurchase.instance.requestPurchase(
  RequestPurchase(
    ios: RequestPurchaseIosProps(sku: 'product_id'),
    android: RequestPurchaseAndroidProps(skus: ['product_id']),
  ),
  PurchaseType.inapp,
);
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

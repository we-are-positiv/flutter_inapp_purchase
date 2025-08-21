---
sidebar_position: 1
title: initConnection
---

# initConnection()

Initializes the connection to the platform's billing service.

## Overview

The `initConnection()` method establishes a connection to the App Store (iOS) or Google Play Billing (Android). This method must be called before any other purchase-related operations.

## Signature

```dart
Future<void> initConnection()
```

## Returns

A `Future` that completes when the connection is established.

## Throws

- `PurchaseError` with code `E_ALREADY_INITIALIZED` if the connection is already initialized
- `PurchaseError` with code `E_NOT_INITIALIZED` if the initialization fails

## Platform Behavior

### iOS
- Initializes StoreKit connection
- Sets up transaction observers
- Checks if the device can make payments

### Android
- Initializes Google Play Billing client
- Establishes connection to Google Play services
- Sets up purchase update listeners

```dart
void _setupListeners() {
  // Listen to purchase updates
  _iap.purchaseUpdatedListener.listen((purchase) {
    if (purchase != null) {
      _handlePurchase(purchase);
    }
  });
  
  // Listen to purchase errors
  _iap.purchaseErrorListener.listen((error) {
    if (error != null) {
      _handleError(error);
    }
  });
}
```

## Best Practices

1. **Initialize Early**: Call `initConnection()` as early as possible in your app lifecycle, ideally when the app starts or when entering a store-related screen.

2. **Handle Errors**: Always wrap the initialization in a try-catch block to handle potential errors gracefully.

3. **Check Connection State**: Before making any purchase-related calls, ensure the connection is initialized.

4. **Setup Listeners**: Set up purchase update and error listeners immediately after successful initialization.

5. **End Connection**: Remember to call `endConnection()` when IAP functionality is no longer needed.

## State Management Example

```dart
class IAPProvider extends ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  
  String? _error;
  String? get error => _error;
  
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      await FlutterInappPurchase.instance.initConnection();
      _isInitialized = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isInitialized = false;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    if (_isInitialized) {
      FlutterInappPurchase.instance.endConnection();
    }
    super.dispose();
  }
}
```

## Related Methods

- `endConnection()` - Closes the connection to the billing service
- [`getProducts()`](./get-products.md) - Fetches available products (requires an initialized connection)
- [`requestPurchase()`](./request-purchase.md) - Initiates a purchase (requires an initialized connection)
## Migration Notes

### From flutter_inapp_purchase v5.x
The method signature remains the same, but now includes expo-iap compatible error handling.

### From expo-iap
This method replaces expo-iap's initialization pattern and provides the same functionality with enhanced error reporting.
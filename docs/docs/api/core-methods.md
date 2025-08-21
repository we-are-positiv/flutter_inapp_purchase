---
title: Core Methods
sidebar_position: 3
---

# Core Methods

Essential methods for implementing in-app purchases with flutter_inapp_purchase v6.0.0. All methods support both iOS and Android platforms with unified APIs.

⚠️ **Platform Differences**: While the API is unified, there are important differences between iOS and Android implementations. Each method documents platform-specific behavior.

## Connection Management

### initConnection()

Initializes the connection to the platform store.

```dart
Future<void> initConnection() async
```

**Description**: Establishes connection with the App Store (iOS) or Google Play Store (Android). Must be called before any other IAP operations.

**Platform Differences**:

- **iOS**: Connects to StoreKit 2 (iOS 15+) or StoreKit 1 (fallback)
- **Android**: Connects to Google Play Billing Client v8

**Example**:

```dart
try {
  await FlutterInappPurchase.instance.initConnection();
  print('IAP connection initialized successfully');
} catch (e) {
  print('Failed to initialize IAP: $e');
}
```

**Throws**: `PurchaseError` if connection fails or already initialized

**See Also**: [endConnection()](#endconnection), [Connection Lifecycle](../guides/lifecycle.md)

---

### endConnection()

Ends the connection to the platform store.

```dart
Future<void> endConnection() async
```

**Description**: Cleanly closes the store connection and frees resources. Should be called when IAP functionality is no longer needed.

**Example**:

```dart
try {
  await FlutterInappPurchase.instance.endConnection();
  print('IAP connection closed');
} catch (e) {
  print('Failed to close IAP connection: $e');
}
```

**Note**: Connection can be re-established by calling `initConnection()` again.

---

### finalize()

Alternative name for `endConnection()` for backward compatibility.

```dart
Future<void> finalize() async
```

## Product Loading

### requestProducts()

Loads product information from the store.

```dart
Future<List<BaseProduct>> requestProducts({
  required List<String> productIds,
  PurchaseType type = PurchaseType.inapp,
}) async
```

**Parameters**:

- `productIds` - List of product identifiers
- `type` - Product type (optional, defaults to `PurchaseType.inapp`)

**Returns**: List of products with pricing and metadata

**Example**:

```dart
try {
  final products = await FlutterInappPurchase.instance.requestProducts(
    productIds: ['product_1', 'product_2', 'premium_upgrade'],
    type: PurchaseType.inapp,
  );

  for (final product in products) {
    print('Product: ${product.id}');
    print('Price: ${product.displayPrice}');
    print('Title: ${product.title}');
  }
} catch (e) {
  print('Failed to load products: $e');
}
```

**Platform Differences**:

- **iOS**: Uses `SKProductsRequest` (StoreKit)
- **Android**: Uses `querySkuDetails()` (Billing Client)

---

### getProducts()

Legacy method for loading in-app products.

```dart
Future<List<IapItem>> getProducts(List<String> skus) async
```

**Parameters**:

- `skus` - List of product identifiers

**Returns**: List of `IapItem` objects

**Example**:

```dart
final products = await FlutterInappPurchase.instance.getProducts([
  'coins_100',
  'coins_500',
  'remove_ads'
]);

for (final product in products) {
  print('${product.title}: ${product.localizedPrice}');
}
```

---

### getSubscriptions()

Legacy method for loading subscription products.

```dart
Future<List<IapItem>> getSubscriptions(List<String> skus) async
```

**Parameters**:

- `skus` - List of subscription identifiers

**Returns**: List of subscription `IapItem` objects with subscription-specific metadata

**Example**:

```dart
final subscriptions = await FlutterInappPurchase.instance.getSubscriptions([
  'premium_monthly',
  'premium_yearly'
]);

for (final sub in subscriptions) {
  print('${sub.title}: ${sub.localizedPrice}');
  print('Period: ${sub.subscriptionPeriodAndroid}'); // Android
  print('Period: ${sub.subscriptionPeriodUnitIOS}'); // iOS
}
```

## Purchase Processing

### requestPurchase()

Initiates a purchase using platform-specific request objects.

```dart
Future<void> requestPurchase({
  required RequestPurchase request,
  required PurchaseType type,
}) async
```

**Parameters**:

- `request` - Platform-specific purchase request
- `type` - Purchase type (`PurchaseType.inapp` or `PurchaseType.subs`)

**Example**:

```dart
// Create platform-specific request
final request = RequestPurchase(
  ios: RequestPurchaseIOS(
    sku: 'premium_upgrade',
    quantity: 1,
  ),
  android: RequestPurchaseAndroid(
    skus: ['premium_upgrade'],
  ),
);

try {
  await FlutterInappPurchase.instance.requestPurchase(
    request: request,
    type: PurchaseType.inapp,
  );
  // Listen to purchaseUpdated stream for result
} catch (e) {
  print('Purchase request failed: $e');
}
```

**Platform Differences**:

- **iOS**: Single `sku`, supports `quantity` and promotional offers
- **Android**: Array of `skus`, supports obfuscated user IDs

---

### requestPurchaseAuto()

Simplified purchase method with automatic platform detection.

```dart
Future<void> requestPurchaseAuto({
  required String sku,
  required PurchaseType type,
  // iOS-specific optional parameters
  bool? andDangerouslyFinishTransactionAutomaticallyIOS,
  String? appAccountToken,
  int? quantity,
  PaymentDiscount? withOffer,
  // Android-specific optional parameters
  String? obfuscatedAccountIdAndroid,
  String? obfuscatedProfileIdAndroid,
  bool? isOfferPersonalized,
  String? purchaseToken,
  int? offerTokenIndex,
  int? prorationMode,
  // Android subscription-specific
  int? replacementModeAndroid,
  List<SubscriptionOfferAndroid>? subscriptionOffers,
}) async
```

**Parameters**:

- `sku` - Product identifier
- `type` - Purchase type
- Platform-specific optional parameters

**Example**:

```dart
try {
  await FlutterInappPurchase.instance.requestPurchaseAuto(
    sku: 'premium_upgrade',
    type: PurchaseType.inapp,
    quantity: 1,  // iOS only
    obfuscatedAccountIdAndroid: 'user_123',  // Android only
  );
} catch (e) {
  print('Auto purchase failed: $e');
}
```

## Transaction Management

### finishTransaction()

Completes a transaction after successful purchase processing.

```dart
Future<void> finishTransaction(
  PurchasedItem purchase, {
  bool isConsumable = false,
}) async
```

**Parameters**:

- `purchase` - The purchased item to finish
- `isConsumable` - Whether the product is consumable (Android only)

**Example**:

```dart
// In your purchase success handler
FlutterInappPurchase.purchaseUpdated.listen((purchase) async {
  if (purchase != null) {
    try {
      // Deliver the product to user
      await deliverProduct(purchase.productId);

      // Finish the transaction
      await FlutterInappPurchase.instance.finishTransaction(
        purchase,
        isConsumable: true, // For consumable products
      );

      print('Transaction completed successfully');
    } catch (e) {
      print('Failed to finish transaction: $e');
    }
  }
});
```

**Platform Behavior**:

- **iOS**: Calls `finishTransaction` on the transaction
- **Android**: Calls `consumePurchase` (consumable) or `acknowledgePurchase` (non-consumable)

---

### consumePurchaseAndroid()

Android-specific method to consume a purchase.

```dart
Future<void> consumePurchaseAndroid({
  required String purchaseToken,
}) async
```

**Parameters**:

- `purchaseToken` - The purchase token to consume

**Example**:

```dart
// Android-specific consumption
if (Platform.isAndroid) {
  try {
    await FlutterInappPurchase.instance.consumePurchaseAndroid(
      purchaseToken: purchase.purchaseToken!,
    );
    print('Purchase consumed successfully');
  } catch (e) {
    print('Failed to consume purchase: $e');
  }
}
```

**Note**: Only available on Android. Use `finishTransaction()` for cross-platform compatibility.

## Purchase History

### getAvailablePurchases()

Gets all available (unconsumed) purchases.

```dart
Future<List<Purchase>> getAvailablePurchases() async
```

**Returns**: List of available purchases

**Example**:

```dart
try {
  final purchases = await FlutterInappPurchase.instance.getAvailablePurchases();

  print('Found ${purchases.length} available purchases');
  for (final purchase in purchases) {
    print('Product: ${purchase.productId}');
    print('Date: ${purchase.transactionDate}');
  }
} catch (e) {
  print('Failed to get available purchases: $e');
}
```

---

### getPurchaseHistories()

Gets purchase history including consumed items.

```dart
Future<List<Purchase>> getPurchaseHistories() async
```

**Returns**: List of historical purchases

**Example**:

```dart
try {
  final history = await FlutterInappPurchase.instance.getPurchaseHistories();

  print('Purchase history: ${history.length} items');
  for (final purchase in history) {
    print('${purchase.productId} - ${purchase.transactionDate}');
  }
} catch (e) {
  print('Failed to get purchase history: $e');
}
```

---

### restorePurchases()

Restores previous purchases (primarily for iOS).

```dart
Future<void> restorePurchases() async
```

**Example**:

```dart
try {
  await FlutterInappPurchase.instance.restorePurchases();

  // Check available purchases after restoration
  final restored = await FlutterInappPurchase.instance.getAvailablePurchases();
  print('Restored ${restored.length} purchases');
} catch (e) {
  print('Failed to restore purchases: $e');
}
```

**Platform Behavior**:

- **iOS**: Triggers App Store purchase restoration
- **Android**: Returns cached purchase data

## Platform-Specific Methods

### iOS-Specific Methods

#### presentCodeRedemptionSheetIOS()

Presents the App Store code redemption sheet.

```dart
Future<void> presentCodeRedemptionSheetIOS() async
```

**Example**:

```dart
if (Platform.isIOS) {
  try {
    await FlutterInappPurchase.instance.presentCodeRedemptionSheetIOS();
  } catch (e) {
    print('Failed to present redemption sheet: $e');
  }
}
```

**Requirements**: iOS 14.0+

---

#### showManageSubscriptionsIOS()

Shows the subscription management interface.

```dart
Future<void> showManageSubscriptionsIOS() async
```

**Example**:

```dart
if (Platform.isIOS) {
  try {
    await FlutterInappPurchase.instance.showManageSubscriptionsIOS();
  } catch (e) {
    print('Failed to show subscription management: $e');
  }
}
```

---

#### getAppStoreCountryIOS()

Gets the App Store country code.

```dart
Future<String?> getAppStoreCountryIOS() async
```

**Returns**: Country code or null

**Example**:

```dart
if (Platform.isIOS) {
  final country = await FlutterInappPurchase.instance.getAppStoreCountryIOS();
  print('App Store country: $country');
}
```

### Android-Specific Methods

#### deepLinkToSubscriptionsAndroid()

Opens the Google Play subscription management page.

```dart
Future<void> deepLinkToSubscriptionsAndroid() async
```

**Example**:

```dart
if (Platform.isAndroid) {
  try {
    await FlutterInappPurchase.instance.deepLinkToSubscriptionsAndroid();
  } catch (e) {
    print('Failed to open subscription management: $e');
  }
}
```

---

#### getConnectionStateAndroid()

Gets the current billing client connection state.

```dart
Future<int> getConnectionStateAndroid() async
```

**Returns**: Connection state code

**Example**:

```dart
if (Platform.isAndroid) {
  final state = await FlutterInappPurchase.instance.getConnectionStateAndroid();
  print('Billing client state: $state');
}
```

## Error Handling

All core methods may throw `PurchaseError` exceptions. Always wrap calls in try-catch blocks:

```dart
try {
  await FlutterInappPurchase.instance.initConnection();
} on PurchaseError catch (e) {
  switch (e.code) {
    case ErrorCode.eAlreadyInitialized:
      print('Already initialized');
      break;
    case ErrorCode.eNetworkError:
      print('Network error - check connection');
      break;
    default:
      print('Purchase error: ${e.message}');
  }
} catch (e) {
  print('Unexpected error: $e');
}
```

## Best Practices

### 1. Connection Management

```dart
class IAPManager {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await FlutterInappPurchase.instance.initConnection();
      _isInitialized = true;
    }
  }

  static Future<void> dispose() async {
    if (_isInitialized) {
      await FlutterInappPurchase.instance.endConnection();
      _isInitialized = false;
    }
  }
}
```

### 2. Product Loading with Caching

```dart
class ProductManager {
  static List<BaseProduct>? _cachedProducts;
  static DateTime? _lastFetch;
  static const _cacheTimeout = Duration(hours: 1);

  static Future<List<BaseProduct>> getProducts(List<String> skus) async {
    if (_cachedProducts != null &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < _cacheTimeout) {
      return _cachedProducts!;
    }

    _cachedProducts = await FlutterInappPurchase.instance.requestProducts(
      productIds: skus,
      type: PurchaseType.inapp,
    );
    _lastFetch = DateTime.now();

    return _cachedProducts!;
  }
}
```

### 3. Purchase Flow with Error Handling

```dart
Future<void> makePurchase(String sku) async {
  try {
    final request = RequestPurchase(
      ios: RequestPurchaseIOS(sku: sku, quantity: 1),
      android: RequestPurchaseAndroid(skus: [sku]),
    );

    await FlutterInappPurchase.instance.requestPurchase(
      request: request,
      type: PurchaseType.inapp,
    );

    // Success handling happens in purchaseUpdated listener
  } on PurchaseError catch (e) {
    if (e.code == ErrorCode.eUserCancelled) {
      // User cancelled - don't show error
      return;
    }

    // Show error to user
    showErrorDialog(e.message);
  }
}
```

## Migration Notes

⚠️ **Breaking Changes from v5.x:**

1. **Method Names**: `requestPurchase()` now requires `RequestPurchase` object
2. **Parameters**: Platform-specific parameters moved to request objects
3. **Error Handling**: `PurchaseError` replaces simple string errors
4. **Initialization**: Must call `initConnection()` before other operations

## See Also

- [Types](./types.md) - Request and response object definitions
- [Listeners](./listeners.md) - Event streams for purchase updates
- [Error Codes](./error-codes.md) - Comprehensive error handling
- [Purchase Guide](../guides/purchases.md) - Complete purchase implementation

---
title: FlutterInappPurchase
sidebar_label: FlutterInappPurchase
sidebar_position: 1
---

# 🔧 FlutterInappPurchase API

The main class for handling in-app purchases across iOS and Android platforms.

## 📦 Import

```dart
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
```

## 🏗️ Instance Access

```dart
// Access the singleton instance
final iap = FlutterInappPurchase.instance;
```

## 🔗 Connection Management

### initConnection()

Initialize the connection to the platform billing service.

```dart
Future<void> initConnection()
```

**Example:**

```dart
try {
  await FlutterInappPurchase.instance.initConnection();
  print('Connection initialized successfully');
} catch (e) {
  print('Failed to initialize connection: $e');
}
```

**Platform Notes:**

- **iOS**: Calls `canMakePayments` and registers transaction observers
- **Android**: Connects to Google Play Billing service

---

### endConnection()

End the connection to the platform billing service.

```dart
Future<void> endConnection()
```

**Example:**

```dart
@override
void dispose() {
  FlutterInappPurchase.instance.endConnection();
  super.dispose();
}
```

**Important:** Always call this in your app's dispose method to prevent memory leaks.

## 🛍️ Product Management

### getProducts()

Retrieve a list of consumable and non-consumable products.

```dart
Future<List<IapItem>> getProducts(List<String> productIds)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `productIds` | `List<String>` | List of product IDs to fetch |

**Returns:** `Future<List<IapItem>>` - List of available products

**Example:**

```dart
final products = await FlutterInappPurchase.instance.getProducts([
  'premium_upgrade',
  'remove_ads',
  'extra_lives'
]);

for (var product in products) {
  print('Product: ${product.title} - ${product.localizedPrice}');
}
```

---

### getSubscriptions()

Retrieve a list of subscription products.

```dart
Future<List<IapItem>> getSubscriptions(List<String> subscriptionIds)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `subscriptionIds` | `List<String>` | List of subscription IDs to fetch |

**Returns:** `Future<List<IapItem>>` - List of available subscriptions

**Example:**

```dart
final subscriptions = await FlutterInappPurchase.instance.getSubscriptions([
  'monthly_premium',
  'yearly_premium'
]);
```

## 💳 Purchase Management

### requestPurchase()

Request a purchase using the new unified API.

```dart
Future<void> requestPurchase({
  required RequestPurchase request,
  required PurchaseType type,
})
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `request` | `RequestPurchase` | Platform-specific purchase request |
| `type` | `PurchaseType` | Type of purchase (`inapp` or `subs`) |

**Example:**

```dart
await FlutterInappPurchase.instance.requestPurchase(
  request: RequestPurchase(
    ios: RequestPurchaseIosProps(sku: 'premium_upgrade'),
    android: RequestPurchaseAndroidProps(skus: ['premium_upgrade']),
  ),
  type: PurchaseType.inapp,
);
```

---

### requestPurchaseSimple()

Simplified purchase request for cross-platform products.

```dart
Future<void> requestPurchaseSimple({
  required String productId,
  required PurchaseType type,
  String? applicationUsername,
  String? obfuscatedAccountId,
  String? obfuscatedProfileId,
})
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `productId` | `String` | ✅ | Product ID to purchase |
| `type` | `PurchaseType` | ✅ | Purchase type |
| `applicationUsername` | `String?` | ❌ | iOS: Application username |
| `obfuscatedAccountId` | `String?` | ❌ | Android: Obfuscated account ID |
| `obfuscatedProfileId` | `String?` | ❌ | Android: Obfuscated profile ID |

**Example:**

```dart
await FlutterInappPurchase.instance.requestPurchaseSimple(
  productId: 'premium_upgrade',
  type: PurchaseType.inapp,
);
```

## 📋 Purchase History

### getAvailablePurchases()

Get all non-consumed purchases (restore purchases).

```dart
Future<List<PurchasedItem>?> getAvailablePurchases()
```

**Returns:** `Future<List<PurchasedItem>?>` - List of available purchases

**Example:**

```dart
final purchases = await FlutterInappPurchase.instance.getAvailablePurchases();
if (purchases != null) {
  for (var purchase in purchases) {
    print('Purchase: ${purchase.productId}');
  }
}
```

---

### getPurchaseHistory()

Get purchase history (including consumed purchases on Android).

```dart
Future<List<PurchasedItem>?> getPurchaseHistory()
```

**Returns:** `Future<List<PurchasedItem>?>` - List of purchase history

## ✅ Transaction Completion

### finishTransaction()

Complete a transaction (cross-platform).

```dart
Future<String?> finishTransaction(PurchasedItem purchase, {bool? isConsumable})
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `purchase` | `PurchasedItem` | ✅ | Purchase to finish |
| `isConsumable` | `bool?` | ❌ | Whether the purchase is consumable (Android) |

**Example:**

```dart
// Listen for purchase updates
FlutterInappPurchase.purchaseUpdated.listen((purchase) async {
  if (purchase != null) {
    // Verify the purchase on your server first
    await verifyPurchaseOnServer(purchase);

    // Complete the transaction
    await FlutterInappPurchase.instance.finishTransaction(
      purchase,
      isConsumable: true, // for consumable products
    );
  }
});
```

## 📱 Platform-Specific Methods

### iOS Methods

#### syncIOS()

Sync pending iOS transactions.

```dart
Future<bool> syncIOS()
```

#### presentCodeRedemptionSheetIOS()

Present the code redemption sheet (iOS 14+).

```dart
Future<void> presentCodeRedemptionSheetIOS()
```

#### showManageSubscriptionsIOS()

Show the subscription management interface.

```dart
Future<void> showManageSubscriptionsIOS()
```

### Android Methods

#### deepLinkToSubscriptionsAndroid()

Deep link to subscription management.

```dart
Future<void> deepLinkToSubscriptionsAndroid({String? sku})
```

#### getConnectionStateAndroid()

Get the billing client connection state.

```dart
Future<BillingClientState> getConnectionStateAndroid()
```

## 🎧 Event Streams

### purchaseUpdated

Stream of purchase updates.

```dart
Stream<PurchasedItem?> get purchaseUpdated
```

**Example:**

```dart
late StreamSubscription _purchaseSubscription;

@override
void initState() {
  super.initState();
  _purchaseSubscription = FlutterInappPurchase.purchaseUpdated.listen(
    (purchase) async {
      if (purchase != null) {
        // Handle successful purchase
        await handlePurchase(purchase);
      }
    },
  );
}

@override
void dispose() {
  _purchaseSubscription.cancel();
  super.dispose();
}
```

---

### purchaseError

Stream of purchase errors.

```dart
Stream<PurchaseResult?> get purchaseError
```

**Example:**

```dart
FlutterInappPurchase.purchaseError.listen((error) {
  if (error != null) {
    print('Purchase error: ${error.message}');

    // Handle specific error codes
    if (error.code == ErrorCode.eUserCancelled) {
      // User cancelled - no action needed
    } else if (error.code == ErrorCode.eNetworkError) {
      // Show retry option
      showRetryDialog();
    }
  }
});
```

## 🔍 Error Handling

Common error codes you should handle:

| Error Code                   | Description               | Action                 |
| ---------------------------- | ------------------------- | ---------------------- |
| `ErrorCode.eUserCancelled`   | User cancelled purchase   | No action needed       |
| `ErrorCode.eNetworkError`    | Network error             | Offer retry            |
| `ErrorCode.eItemUnavailable` | Product not available     | Check product setup    |
| `ErrorCode.eAlreadyOwned`    | User already owns product | Restore or acknowledge |
| `ErrorCode.eDeveloperError`  | Configuration error       | Check setup            |

**Example Error Handling:**

```dart
FlutterInappPurchase.purchaseError.listen((error) {
  if (error == null) return;

  switch (error.code) {
    case ErrorCode.eUserCancelled:
      // User cancelled - no UI needed
      break;
    case ErrorCode.eNetworkError:
      showSnackBar('Network error. Please check your connection and try again.');
      break;
    case ErrorCode.eItemUnavailable:
      showSnackBar('This item is currently unavailable.');
      break;
    case ErrorCode.eAlreadyOwned:
      showSnackBar('You already own this item.');
      break;
    default:
      showSnackBar('Purchase failed: ${error.message}');
  }
});
```

## 🎯 Best Practices

1. **Always initialize connection** before making purchases
2. **Handle all error cases** appropriately
3. **Verify purchases server-side** before granting content
4. **Complete transactions** after verification
5. **Clean up streams** in dispose methods
6. **Test thoroughly** on both platforms

---

## 📚 Related Documentation

- [🏁 **Getting Started**](/getting-started/installation) - Setup and configuration
- [📖 **Purchase Guide**](/guides/first-purchase) - Step-by-step purchase implementation
- [🔍 **Error Handling**](/guides/error-handling) - Comprehensive error handling
- [🧪 **Testing**](/guides/testing) - Testing strategies

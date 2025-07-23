---
sidebar_position: 2
title: getProducts
---

# getProducts()

Retrieves a list of products from the store.

## Overview

The `getProducts()` method fetches product information for the specified product IDs from the App Store (iOS) or Google Play Store (Android). This includes pricing, descriptions, and platform-specific details.

## Signature

```dart
Future<List<IAPItem>> getProducts(List<String> productIds)
```

## Parameters

- `productIds` - List of product identifiers to fetch

## Returns

A `Future` that resolves to a list of `IAPItem` objects containing product information.

## Platform Behavior

### iOS
- Queries the App Store using StoreKit
- Returns products with localized pricing and descriptions
- Includes introductory prices and promotional offers if available

### Android
- Queries Google Play using the Billing Library
- Returns products with localized pricing
- Includes subscription offers and pricing phases

## Usage Example

```dart
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class StoreService {
  final _iap = FlutterInappPurchase.instance;
  List<IAPItem> _products = [];
  
  Future<void> loadProducts() async {
    try {
      // Define your product IDs
      const productIds = [
        'com.example.premium',
        'com.example.remove_ads',
        'com.example.coins_100',
      ];
      
      // Fetch products from the store
      _products = await _iap.getProducts(productIds);
      
      // Display products
      for (var product in _products) {
        print('Product: ${product.title}');
        print('Price: ${product.localizedPrice}');
        print('Description: ${product.description}');
      }
      
    } catch (e) {
      print('Error loading products: $e');
    }
  }
}
```

## Displaying Products

```dart
class ProductListWidget extends StatelessWidget {
  final List<IAPItem> products;
  
  const ProductListWidget({required this.products});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.title ?? 'Unknown Product'),
          subtitle: Text(product.description ?? ''),
          trailing: TextButton(
            onPressed: () => _purchaseProduct(product.productId!),
            child: Text(product.localizedPrice ?? ''),
          ),
        );
      },
    );
  }
  
  void _purchaseProduct(String productId) {
    // Initiate purchase
  }
}
```

## Product Information

The returned `IAPItem` objects contain:

- `productId` - The product identifier
- `price` - Raw price value
- `currency` - Currency code (e.g., "USD")
- `localizedPrice` - Formatted price with currency symbol
- `title` - Product title
- `description` - Product description
- `originalJson` - Raw response from the platform

## Error Handling

```dart
Future<List<IAPItem>> fetchProducts() async {
  try {
    final products = await _iap.getProducts(['invalid_id', 'valid_id']);
    
    // The method returns only valid products
    // Invalid IDs are silently ignored
    if (products.isEmpty) {
      print('No valid products found');
    }
    
    return products;
  } on PlatformException catch (e) {
    print('Platform error: ${e.message}');
    return [];
  } catch (e) {
    print('Unexpected error: $e');
    return [];
  }
}
```

## Best Practices

1. **Cache Products**: Store fetched products locally to avoid repeated network calls
2. **Handle Empty Results**: Always check if the returned list is empty
3. **Validate IDs**: Ensure product IDs match those configured in App Store Connect or Google Play Console
4. **Refresh Periodically**: Refresh product information periodically to get updated prices

## Performance Considerations

```dart
class ProductCache {
  final _cache = <String, IAPItem>{};
  DateTime? _lastFetch;
  
  Future<List<IAPItem>> getProducts(List<String> productIds) async {
    // Check cache validity (refresh every hour)
    if (_lastFetch != null && 
        DateTime.now().difference(_lastFetch!).inHours < 1) {
      // Return cached products if available
      final cached = productIds
          .where((id) => _cache.containsKey(id))
          .map((id) => _cache[id]!)
          .toList();
      
      if (cached.length == productIds.length) {
        return cached;
      }
    }
    
    // Fetch from store
    final products = await FlutterInappPurchase.instance.getProducts(productIds);
    
    // Update cache
    for (var product in products) {
      if (product.productId != null) {
        _cache[product.productId!] = product;
      }
    }
    _lastFetch = DateTime.now();
    
    return products;
  }
}
```

## Related Methods

- [`getSubscriptions()`](./get-subscriptions.md) - Fetches subscription products
- [`requestProducts()`](./request-purchase.md) - expo-iap compatible method for fetching products
- [`requestPurchase()`](./request-purchase.md) - Initiates a purchase for a product

## Platform-Specific Notes

### iOS
- Products must be in "Ready to Submit" or "Approved" state in App Store Connect
- Sandbox testing requires a sandbox test account
- May return promotional offers for eligible users

### Android
- Products must be active in Google Play Console
- Requires the app to be uploaded to Google Play (at least in internal testing)
- Returns base64-encoded signatures for verification
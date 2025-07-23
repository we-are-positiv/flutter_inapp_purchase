---
sidebar_position: 3
title: getSubscriptions
---

# getSubscriptions()

Retrieves a list of subscription products from the store.

## Overview

The `getSubscriptions()` method fetches subscription product information for the specified product IDs from the App Store (iOS) or Google Play Store (Android). This includes subscription-specific details like billing periods, introductory prices, and free trials.

## Signature

```dart
Future<List<IAPItem>> getSubscriptions(List<String> productIds)
```

## Parameters

- `productIds` - List of subscription product identifiers to fetch

## Returns

A `Future` that resolves to a list of `IAPItem` objects containing subscription information.

## Platform Behavior

### iOS
- Returns subscription products with period information
- Includes introductory price details
- Shows promotional offers if available
- Provides subscription group information

### Android
- Returns subscriptions with billing period
- Includes multiple pricing phases (free trials, introductory prices)
- Provides offer details and tokens

## Usage Example

```dart
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class SubscriptionService {
  final _iap = FlutterInappPurchase.instance;
  List<IAPItem> _subscriptions = [];
  
  Future<void> loadSubscriptions() async {
    try {
      // Define your subscription IDs
      const subscriptionIds = [
        'com.example.monthly',
        'com.example.yearly',
        'com.example.premium_monthly',
      ];
      
      // Fetch subscriptions from the store
      _subscriptions = await _iap.getSubscriptions(subscriptionIds);
      
      // Display subscription details
      for (var subscription in _subscriptions) {
        print('Subscription: ${subscription.title}');
        print('Price: ${subscription.localizedPrice}');
        
        // iOS specific
        if (Platform.isIOS) {
          print('Period: ${subscription.subscriptionPeriodNumberIOS} ${subscription.subscriptionPeriodUnitIOS}');
          if (subscription.introductoryPrice != null) {
            print('Intro price: ${subscription.introductoryPrice}');
          }
        }
        
        // Android specific
        if (Platform.isAndroid) {
          print('Period: ${subscription.subscriptionPeriodAndroid}');
          if (subscription.subscriptionOffersAndroid != null) {
            for (var offer in subscription.subscriptionOffersAndroid!) {
              print('Offer: ${offer.offerId}');
            }
          }
        }
      }
      
    } catch (e) {
      print('Error loading subscriptions: $e');
    }
  }
}
```

## Subscription Information

The returned `IAPItem` objects for subscriptions include:

### Common Properties
- `productId` - Subscription identifier
- `price` - Regular subscription price
- `localizedPrice` - Formatted price with currency
- `title` - Subscription title
- `description` - Subscription description

### iOS-Specific Properties
- `subscriptionPeriodNumberIOS` - Number of units (e.g., "1")
- `subscriptionPeriodUnitIOS` - Unit type (e.g., "MONTH", "YEAR")
- `introductoryPrice` - Introductory price if available
- `introductoryPriceNumberOfPeriodsIOS` - Duration of intro price
- `introductoryPricePaymentModeIOS` - Payment mode for intro price
- `discountsIOS` - Available promotional offers

### Android-Specific Properties
- `subscriptionPeriodAndroid` - ISO 8601 duration (e.g., "P1M")
- `subscriptionOffersAndroid` - List of available offers
- `signatureAndroid` - Signature for verification

## Displaying Subscriptions

```dart
class SubscriptionCard extends StatelessWidget {
  final IAPItem subscription;
  
  const SubscriptionCard({required this.subscription});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subscription.title ?? 'Subscription',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(subscription.description ?? ''),
            const SizedBox(height: 16),
            _buildPriceInfo(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _subscribe(),
              child: Text('Subscribe for ${subscription.localizedPrice}'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPriceInfo() {
    final items = <Widget>[];
    
    // Regular price
    items.add(Text('Price: ${subscription.localizedPrice}'));
    
    // Period information
    if (Platform.isIOS && subscription.subscriptionPeriodUnitIOS != null) {
      items.add(Text('Billed: ${_formatPeriodIOS()}'));
    } else if (Platform.isAndroid && subscription.subscriptionPeriodAndroid != null) {
      items.add(Text('Billed: ${_formatPeriodAndroid()}'));
    }
    
    // Introductory price
    if (subscription.introductoryPrice != null) {
      items.add(Text('Introductory: ${subscription.introductoryPrice}'));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }
  
  String _formatPeriodIOS() {
    final number = subscription.subscriptionPeriodNumberIOS ?? '1';
    final unit = subscription.subscriptionPeriodUnitIOS?.toLowerCase() ?? '';
    return '$number $unit${number != '1' ? 's' : ''}';
  }
  
  String _formatPeriodAndroid() {
    // Parse ISO 8601 duration
    final period = subscription.subscriptionPeriodAndroid!;
    if (period == 'P1M') return 'monthly';
    if (period == 'P1Y') return 'yearly';
    if (period == 'P1W') return 'weekly';
    return period;
  }
  
  void _subscribe() {
    // Initiate subscription purchase
  }
}
```

## Handling Free Trials

```dart
bool hasFreeTrial(IAPItem subscription) {
  if (Platform.isIOS) {
    // Check if introductory price is free
    return subscription.introductoryPrice == '0' ||
           subscription.introductoryPrice == '0.00';
  } else if (Platform.isAndroid) {
    // Check subscription offers for free trials
    if (subscription.subscriptionOffersAndroid != null) {
      for (var offer in subscription.subscriptionOffersAndroid!) {
        if (offer.pricingPhases != null) {
          for (var phase in offer.pricingPhases!) {
            if (phase.price == '0') {
              return true;
            }
          }
        }
      }
    }
  }
  return false;
}
```

## Best Practices

1. **Group Subscriptions**: Organize subscriptions by duration or feature set
2. **Show Savings**: Calculate and display savings for longer subscription periods
3. **Highlight Trials**: Prominently display free trial information
4. **Handle Upgrades**: Implement upgrade/downgrade logic for existing subscribers

## Error Handling

```dart
Future<void> loadSubscriptionsWithRetry() async {
  const maxRetries = 3;
  var retryCount = 0;
  
  while (retryCount < maxRetries) {
    try {
      final subscriptions = await _iap.getSubscriptions(subscriptionIds);
      
      if (subscriptions.isEmpty) {
        throw Exception('No subscriptions found');
      }
      
      // Success
      _updateSubscriptions(subscriptions);
      break;
      
    } catch (e) {
      retryCount++;
      if (retryCount >= maxRetries) {
        _handleError('Failed to load subscriptions after $maxRetries attempts');
        break;
      }
      
      // Wait before retry
      await Future.delayed(Duration(seconds: retryCount));
    }
  }
}
```

## Related Methods

- [`getProducts()`](./get-products.md) - Fetches non-subscription products
- [`requestSubscription()`](./request-subscription.md) - Initiates a subscription purchase
- [`getAvailablePurchases()`](./get-available-purchases.md) - Gets active subscriptions

## Platform-Specific Notes

### iOS
- Subscription groups allow users to have only one active subscription per group
- Introductory prices are automatically applied for eligible users
- Promotional offers require server-side signature generation

### Android
- Supports multiple base plans per subscription
- Offers can have multiple pricing phases
- Requires Play Console configuration for each offer
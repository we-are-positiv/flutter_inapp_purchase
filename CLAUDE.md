# Implementation Guidelines

## Flutter-Specific Guidelines

### Pre-Commit Checks

Before committing any changes:

1. Run `dart format .` to ensure consistent code formatting
2. Run `flutter test` to verify all tests pass
3. Only commit if both checks succeed

### Platform-Specific Naming Conventions

- **iOS-related code**: Use `IOS` suffix (e.g., `PurchaseIOS`, `SubscriptionOfferIOS`)
  - When iOS is not the final suffix, use `Ios` (e.g., `IosManager`, `IosHelper`)
- **Android-related code**: Use `Android` suffix (e.g., `PurchaseAndroid`, `SubscriptionOfferAndroid`)
- **IAP-related code**: When IAP is not the final suffix, use `Iap` (e.g., `IapPurchase`, not `IAPPurchase`)
- This applies to both functions and types

### API Method Naming

- Functions that depend on event results should use `request` prefix (e.g., `requestPurchase`, `requestSubscription`)
- Follow OpenIAP terminology: <https://www.openiap.dev/docs/apis#terminology>
- Do not use generic prefixes like `get`, `find` - refer to the official terminology

## IAP-Specific Guidelines

### OpenIAP Specification

All implementations must follow the OpenIAP specification:

- **APIs**: <https://www.openiap.dev/docs/apis>
- **Types**: <https://www.openiap.dev/docs/types>
- **Events**: <https://www.openiap.dev/docs/events>
- **Errors**: <https://www.openiap.dev/docs/errors>

### Feature Development Process

For new feature proposals:

1. Before implementing, discuss at: <https://github.com/hyochan/openiap.dev/discussions>
2. Get community feedback and consensus
3. Ensure alignment with OpenIAP standards
4. Implement following the agreed specification

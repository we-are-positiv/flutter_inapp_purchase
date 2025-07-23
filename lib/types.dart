import 'dart:io';

/// Platform detection enum
enum IAPPlatform { ios, android }

/// Purchase type enum
enum PurchaseType { inapp, subs }

/// Error codes matching expo-iap
enum ErrorCode {
  E_USER_CANCELLED,
  E_ITEM_UNAVAILABLE,
  E_NETWORK_ERROR,
  E_SERVICE_ERROR,
  E_DEVELOPER_ERROR,
  E_BILLING_UNAVAILABLE,
  E_PRODUCT_ALREADY_OWNED,
  E_PURCHASE_NOT_ALLOWED,
  E_QUOTA_EXCEEDED,
  E_UNKNOWN,
  E_PENDING,
  E_FEATURE_NOT_SUPPORTED,
  E_NOT_INITIALIZED,
  E_ALREADY_INITIALIZED,
  E_REMOTE_ERROR,
  E_USER_ERROR,
  E_CLIENT_INVALID,
  E_PAYMENT_INVALID,
  E_PAYMENT_NOT_ALLOWED,
  E_STOREKIT_ORIGINAL_TRANSACTION_ID_NOT_FOUND,
  E_NOT_SUPPORTED,
  E_DEFERRED_PAYMENT,
  E_TRANSACTION_FAILED,
  E_TRANSACTION_INVALID,
  E_RECEIPT_FAILED,
  E_RECEIPT_FINISHED_FAILED,
  E_PRODUCT_NOT_FOUND,
  E_PURCHASE_FAILED,
  E_TRANSACTION_NOT_FOUND,
  E_RESTORE_FAILED,
  E_REDEEM_FAILED,
  E_NO_WINDOW_SCENE,
  E_SHOW_SUBSCRIPTIONS_FAILED,
  E_PRODUCT_LOAD_FAILED,
}

/// Base product interface
abstract class BaseProduct {
  final String productId;
  final String price;
  final String? currency;
  final String? localizedPrice;
  final String? title;
  final String? description;
  final IAPPlatform platform;

  BaseProduct({
    required this.productId,
    required this.price,
    this.currency,
    this.localizedPrice,
    this.title,
    this.description,
    required this.platform,
  });
}

/// Product class for non-subscription items
class Product extends BaseProduct {
  final String type;
  final bool? isFamilyShareable;

  Product({
    required String productId,
    required String price,
    String? currency,
    String? localizedPrice,
    String? title,
    String? description,
    required IAPPlatform platform,
    String? type,
    this.isFamilyShareable,
  }) : type = type ?? 'inapp',
        super(
          productId: productId,
          price: price,
          currency: currency,
          localizedPrice: localizedPrice,
          title: title,
          description: description,
          platform: platform,
        );
}

/// Subscription class for subscription items
class Subscription extends BaseProduct {
  final String type;
  final List<SubscriptionOffer>? subscriptionOfferDetails;
  final String? subscriptionPeriodAndroid;
  final String? subscriptionPeriodUnitIOS;
  final int? subscriptionPeriodNumberIOS;
  final bool? isFamilyShareable;
  final String? subscriptionGroupId;
  final String? introductoryPrice;
  final int? introductoryPriceNumberOfPeriodsIOS;
  final String? introductoryPriceSubscriptionPeriod;

  Subscription({
    required String productId,
    required String price,
    String? currency,
    String? localizedPrice,
    String? title,
    String? description,
    required IAPPlatform platform,
    this.subscriptionOfferDetails,
    this.subscriptionPeriodAndroid,
    this.subscriptionPeriodUnitIOS,
    this.subscriptionPeriodNumberIOS,
    String? type,
    this.isFamilyShareable,
    this.subscriptionGroupId,
    this.introductoryPrice,
    this.introductoryPriceNumberOfPeriodsIOS,
    this.introductoryPriceSubscriptionPeriod,
  }) : type = type ?? 'subs',
        super(
          productId: productId,
          price: price,
          currency: currency,
          localizedPrice: localizedPrice,
          title: title,
          description: description,
          platform: platform,
        );
}

/// Subscription offer details
class SubscriptionOffer {
  final String? offerId;
  final String? basePlanId;
  final String? offerToken;
  final List<PricingPhase>? pricingPhases;

  SubscriptionOffer({
    this.offerId,
    this.basePlanId,
    this.offerToken,
    this.pricingPhases,
  });
}

/// Pricing phase for subscriptions
class PricingPhase {
  final String? price;
  final String? formattedPrice;
  final String? currencyCode;
  final int? billingCycleCount;
  final String? billingPeriod;

  PricingPhase({
    this.price,
    this.formattedPrice,
    this.currencyCode,
    this.billingCycleCount,
    this.billingPeriod,
  });
}

/// Purchase class
class Purchase {
  final String productId;
  final String? transactionId;
  final String? transactionReceipt;
  final String? purchaseToken;
  final DateTime? transactionDate;
  final IAPPlatform platform;
  final bool? isAcknowledgedAndroid;
  final String? purchaseStateAndroid;
  final String? originalTransactionIdentifierIOS;
  final Map<String, dynamic>? originalJson;
  // StoreKit 2 specific fields
  final String? transactionState;
  final bool? isUpgraded;
  final DateTime? expirationDate;
  final DateTime? revocationDate;
  final int? revocationReason;

  Purchase({
    required this.productId,
    this.transactionId,
    this.transactionReceipt,
    this.purchaseToken,
    this.transactionDate,
    required this.platform,
    this.isAcknowledgedAndroid,
    this.purchaseStateAndroid,
    this.originalTransactionIdentifierIOS,
    this.originalJson,
    this.transactionState,
    this.isUpgraded,
    this.expirationDate,
    this.revocationDate,
    this.revocationReason,
  });
}

/// Purchase error class
class PurchaseError {
  final ErrorCode code;
  final String message;
  final String? debugMessage;
  final IAPPlatform platform;

  PurchaseError({
    required this.code,
    required this.message,
    this.debugMessage,
    required this.platform,
  });
}

/// Request purchase parameters
class RequestPurchase {
  final RequestPurchaseIOS? ios;
  final RequestPurchaseAndroid? android;

  RequestPurchase({
    this.ios,
    this.android,
  });
}

/// iOS specific purchase request
class RequestPurchaseIOS {
  final String sku;
  final int? quantity;
  final String? appAccountToken;
  final Map<String, dynamic>? withOffer;

  RequestPurchaseIOS({
    required this.sku,
    this.quantity,
    this.appAccountToken,
    this.withOffer,
  });
}

/// Android specific purchase request
class RequestPurchaseAndroid {
  final List<String> skus;
  final String? obfuscatedAccountIdAndroid;
  final String? obfuscatedProfileIdAndroid;
  final String? purchaseToken;
  final int? offerTokenIndex;
  final int? prorationMode;

  RequestPurchaseAndroid({
    required this.skus,
    this.obfuscatedAccountIdAndroid,
    this.obfuscatedProfileIdAndroid,
    this.purchaseToken,
    this.offerTokenIndex,
    this.prorationMode,
  });
}

/// Request products parameters
class RequestProductsParams {
  final List<String> skus;
  final PurchaseType type;

  RequestProductsParams({
    required this.skus,
    required this.type,
  });
}

/// Connection result
class ConnectionResult {
  final bool connected;
  final String? message;

  ConnectionResult({
    required this.connected,
    this.message,
  });
}

/// iOS App Store info
class AppStoreInfo {
  final String? storefrontCountryCode;
  final String? identifier;

  AppStoreInfo({
    this.storefrontCountryCode,
    this.identifier,
  });
}

/// App Transaction data (iOS 16.0+)
class AppTransaction {
  final String bundleID;
  final String appVersion;
  final String originalAppVersion;
  final DateTime originalPurchaseDate;
  final String deviceVerification;
  final String deviceVerificationNonce;
  final String environment;
  final DateTime signedDate;
  final int appID;
  final int appVersionID;
  final DateTime? preorderDate;
  
  // iOS 18.4+ specific properties
  final String? appTransactionID;
  final String? originalPlatform;

  AppTransaction({
    required this.bundleID,
    required this.appVersion,
    required this.originalAppVersion,
    required this.originalPurchaseDate,
    required this.deviceVerification,
    required this.deviceVerificationNonce,
    required this.environment,
    required this.signedDate,
    required this.appID,
    required this.appVersionID,
    this.preorderDate,
    this.appTransactionID,
    this.originalPlatform,
  });

  factory AppTransaction.fromJson(Map<String, dynamic> json) {
    return AppTransaction(
      bundleID: json['bundleID'] as String,
      appVersion: json['appVersion'] as String,
      originalAppVersion: json['originalAppVersion'] as String,
      originalPurchaseDate: DateTime.fromMillisecondsSinceEpoch(
        (json['originalPurchaseDate'] as num).toInt(),
      ),
      deviceVerification: json['deviceVerification'] as String,
      deviceVerificationNonce: json['deviceVerificationNonce'] as String,
      environment: json['environment'] as String,
      signedDate: DateTime.fromMillisecondsSinceEpoch(
        (json['signedDate'] as num).toInt(),
      ),
      appID: json['appID'] as int,
      appVersionID: json['appVersionID'] as int,
      preorderDate: json['preorderDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['preorderDate'] as num).toInt(),
            )
          : null,
      appTransactionID: json['appTransactionID'] as String?,
      originalPlatform: json['originalPlatform'] as String?,
    );
  }
}

/// Get current platform
IAPPlatform getCurrentPlatform() {
  return Platform.isIOS ? IAPPlatform.ios : IAPPlatform.android;
}
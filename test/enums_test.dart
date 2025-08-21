import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_inapp_purchase/types.dart';

void main() {
  group('Enums', () {
    test('ErrorCode should contain all expected values', () {
      expect(ErrorCode.values.length, greaterThan(5));
      expect(ErrorCode.eUnknown, isA<ErrorCode>());
      expect(ErrorCode.eUserCancelled, isA<ErrorCode>());
      expect(ErrorCode.eUserError, isA<ErrorCode>());
      expect(ErrorCode.eItemUnavailable, isA<ErrorCode>());
      expect(ErrorCode.eProductNotAvailable, isA<ErrorCode>());
      expect(ErrorCode.eProductAlreadyOwned, isA<ErrorCode>());
      expect(ErrorCode.eNetworkError, isA<ErrorCode>());
    });

    test('IapPlatform should work correctly', () {
      expect(IapPlatform.android.toString(), contains('android'));
      expect(IapPlatform.ios.toString(), contains('ios'));
    });

    test('PurchaseState should work correctly', () {
      expect(PurchaseState.purchased.toString(), contains('purchased'));
      expect(PurchaseState.pending.toString(), contains('pending'));
      expect(PurchaseState.unspecified.toString(), contains('unspecified'));
    });

    test('TransactionState should work correctly', () {
      expect(TransactionState.purchasing.toString(), contains('purchasing'));
      expect(TransactionState.purchased.toString(), contains('purchased'));
      expect(TransactionState.failed.toString(), contains('failed'));
      expect(TransactionState.restored.toString(), contains('restored'));
      expect(TransactionState.deferred.toString(), contains('deferred'));
    });

    test('RecurrenceMode should work correctly', () {
      expect(RecurrenceMode.infiniteRecurring, isA<RecurrenceMode>());
      expect(RecurrenceMode.finiteRecurring, isA<RecurrenceMode>());
      expect(RecurrenceMode.nonRecurring, isA<RecurrenceMode>());
    });

    test('ProductType constants should work correctly', () {
      expect(ProductType.inapp, 'inapp');
      expect(ProductType.subs, 'subs');
    });
  });
}

enum EnumTripPaymentReceiver { driver, self, other }

enum EnumTripPaymentMode { cash, cheque, neft, upi }

enum EnumTripPaymentType { discount, dieselAdvance, finalSettlement, other }

enum EnumTripPaymentStatus { cleared, partial, pending, unpaid }

extension EnumTripPaymentReceiverExt on EnumTripPaymentReceiver {
  String get displayName => switch (this) {
        EnumTripPaymentReceiver.driver => 'Driver',
        EnumTripPaymentReceiver.self => 'Self',
        EnumTripPaymentReceiver.other => 'Other',
      };

  static EnumTripPaymentReceiver? fromIndex(int? index) =>
      index != null && index < EnumTripPaymentReceiver.values.length
          ? EnumTripPaymentReceiver.values[index]
          : null;
}

extension EnumTripPaymentModeExt on EnumTripPaymentMode {
  String get displayName => switch (this) {
        EnumTripPaymentMode.neft => 'NEFT',
        EnumTripPaymentMode.cash => 'Cash',
        EnumTripPaymentMode.cheque => 'Cheque',
        EnumTripPaymentMode.upi => 'UPI',
      };

  static EnumTripPaymentMode? fromIndex(int? index) =>
      index != null && index < EnumTripPaymentMode.values.length
          ? EnumTripPaymentMode.values[index]
          : null;
}

extension EnumTripPaymentTypeExt on EnumTripPaymentType {
  String get displayName => switch (this) {
        EnumTripPaymentType.discount => 'Discount',
        EnumTripPaymentType.dieselAdvance => 'Diesel Advance',
        EnumTripPaymentType.finalSettlement => 'Final Settlement',
        EnumTripPaymentType.other => 'Other',
      };

  static EnumTripPaymentType? fromIndex(int? index) =>
      index != null && index < EnumTripPaymentType.values.length
          ? EnumTripPaymentType.values[index]
          : null;
}

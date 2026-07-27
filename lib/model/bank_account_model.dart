class BankAccountModel {
  final int? id;
  final String? accountNumber;
  final String? bankName;
  final String? ifscCode;
  final String? holderName;
  final bool isPrimary;
  // Server-side timestamp of last edit; used to enforce the 30-day lock.
  // Never trust the device clock for this — derive from the server response.
  final DateTime? lastEditedAt;

  BankAccountModel({
    this.id,
    this.accountNumber,
    this.bankName,
    this.ifscCode,
    this.holderName,
    this.isPrimary = false,
    this.lastEditedAt,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['id'],
      accountNumber: json['ac_number'],
      bankName: json['bank_name'],
      ifscCode: json['ifsc_code'],
      holderName: json['holder_name'],
      isPrimary: json['is_primary'] ?? false,
      lastEditedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  // true = user can edit/create right now; false = still within the 30-day lock.
  bool get canEdit {
    if (lastEditedAt == null) return true;
    return DateTime.now().difference(lastEditedAt!).inDays >= 30;
  }

  // Days remaining until next allowed edit (0 if already unlocked).
  int get daysUntilEditable {
    if (lastEditedAt == null) return 0;
    final diff = 30 - DateTime.now().difference(lastEditedAt!).inDays;
    return diff < 0 ? 0 : diff;
  }
}

class OwnerExpense {
  int? id;
  String? ownerUuid;
  String? truckRegd;
  String? expenseType;
  double? amount;
  String? expenseDate;
  String? description;
  String? severity;
  String? createdAt;
  String? updatedAt;

  OwnerExpense({
    this.id,
    this.ownerUuid,
    this.truckRegd,
    this.expenseType,
    this.amount,
    this.expenseDate,
    this.description,
    this.severity,
    this.createdAt,
    this.updatedAt,
  });

  factory OwnerExpense.fromJson(Map<String, dynamic> json) => OwnerExpense(
        id: json["id"],
        ownerUuid: json["owner_uuid"],
        truckRegd: json["truck_regd"],
        expenseType: json["expense_type"],
        amount: json["amount"]?.toDouble(),
        expenseDate: json["expense_date"],
        description: json["description"],
        severity: json["severity"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner_uuid": ownerUuid,
        "truck_regd": truckRegd,
        "expense_type": expenseType,
        "amount": amount,
        "expense_date": expenseDate,
        "description": description,
        "severity": severity,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  static Map<String, dynamic> toDB(Map<String, dynamic> json) {
    final id = json['id'] ?? {};
    final owner = json['owner_uuid'] ?? {};
    final reg = json['truck_regd'] ?? {};
    final specs = json['expense_type'] ?? {};
    final valid = json['amount'] ?? {};
    final date = json['expense_date'] ?? {};
    final desc = json['description'] ?? {};
    final severity = json['severity'] ?? {};
    final created = json['created_at'] ?? {};
    final updated = json['updated_at'] ?? {};
    return {
      'id': id,
      'owner_uuid': owner,
      'truck_regd': reg,
      'expense_type': specs,
      'amount': valid,
      'expense_date': date,
      'description': desc,
      'severity': severity,
      'created_at': created,
      'updated_at': updated,
    };
  }

  factory OwnerExpense.fromDB(Map<String, dynamic> map) => OwnerExpense(
        id: map['id'],
        ownerUuid: map['owner_uuid'],
        truckRegd: map['truck_regd'],
        expenseType: map['expense_type'],
        amount: (map['amount'])?.toDouble() ?? 0.0,
        expenseDate: map['expense_date'],
        description: map['description'],
        severity: map['severity'],
        createdAt: map['created_at'],
        updatedAt: map['updated_at'],
      )
        ..ownerUuid = map['owner_uuid']
        ..truckRegd = map['truck_regd']
        ..expenseType = map['expense_type']
        ..amount = (map['amount'])?.toDouble() ?? 0.0
        ..expenseDate = map['expense_date']
        ..description = map['description']
        ..severity = map['severity']
        ..createdAt = map['created_at']
        ..updatedAt = map['updated_at'];
}

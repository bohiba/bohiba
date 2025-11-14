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

  factory OwnerExpense.fromJson(Map json) => OwnerExpense(
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

  static Map<String, dynamic> toDB(Map json) {
    return {
      'id': json['id'],
      'ownerUuid': json['owner_uuid'],
      'vhNumber': json['truck_regd'],
      'expenseType': json['expense_type'],
      'amount': json['amount'],
      'date': json['expense_date'],
      'description': json['description'],
      'severity': json['severity'],
      'updatedAt': json['updated_at'],
      'createdAt': json['created_at'],
    };
  }

  factory OwnerExpense.fromDB(Map map) => OwnerExpense(
        id: map['id'],
        ownerUuid: map['ownerUuid'],
        truckRegd: map['vhNumber'],
        expenseType: map['expenseType'],
        amount: (map['amount'])?.toDouble() ?? 0.0,
        expenseDate: map['date'],
        description: map['description'],
        severity: map['severity'],
        updatedAt: map['updatedAt'],
        createdAt: map['createdAt'],
      );
}

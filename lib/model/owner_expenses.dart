class OwnerExpense {
  final int? id;
  final String? ownerUuid;
  final String? truckRegd;
  final String? expenseType;
  final double? amount;
  final String? expenseDate;
  final String? description;
  final String? severity;
  final String? createdAt;
  final String? updatedAt;

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

  static List<Map<String, dynamic>> mapOwnerExpenseJsonDbList(
      List<dynamic> jsonOwnExpense) {
    return jsonOwnExpense.map((json) {
      Map<String, dynamic> ownerExpense = json as Map<String, dynamic>;
      return {
        'id': ownerExpense['id'],
        'ownerUuid': ownerExpense['owner_uuid'],
        'vhNumber': ownerExpense['truck_regd'],
        'expenseType': ownerExpense['expense_type'],
        'amount': ownerExpense['amount'],
        'date': ownerExpense['expense_date'],
        'description': ownerExpense['description'],
        'severity': ownerExpense['severity']
      };
    }).toList();
  }
}

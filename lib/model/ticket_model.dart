class TicketModel {
  final int? id;
  final String? uid;
  final String? userUuid;
  final String? title;
  final String? description;
  final String? category;
  final String? priority;
  final String? status;
  final String? remark;
  final String? resolvedAt;
  final String? updatedAt;
  final String? createdAt;

  const TicketModel({
    this.id,
    this.uid,
    this.userUuid,
    this.title,
    this.description,
    this.category,
    this.priority,
    this.status,
    this.remark,
    this.resolvedAt,
    this.updatedAt,
    this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> map) {
    Map json = map;
    return TicketModel(
      id: json['id'] as int?,
      uid: json['uid'] as String? ?? '',
      userUuid: json['user_uuid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      remark: json['remark'] as String?,
      resolvedAt: json['resolved_at'] as String?,
      updatedAt: json['updated_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  bool get isResolved => resolvedAt != null;
}

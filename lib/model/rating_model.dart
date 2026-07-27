class RatingModel {
  int? id;
  String? driverUuid;
  int? reviewerId;
  String? reviewerUuid;
  String? reviewerImage;
  String? reviewerName;
  int? role;
  double? rating;
  String? feedback;
  String? createdAt;

  RatingModel({
    this.id,
    this.driverUuid,
    this.reviewerId,
    this.reviewerUuid,
    this.reviewerImage,
    this.reviewerName,
    this.role,
    this.rating,
    this.feedback,
    this.createdAt,
  });

  factory RatingModel.fromJson(Map<dynamic, dynamic> json) {
    final Map<String, dynamic> reviewer =
        (json['reviewer'] as Map?)?.cast<String, dynamic>() ?? {};
    return RatingModel(
      id: json['id'],
      driverUuid: json['driverUuid'],
      reviewerId: reviewer['id'],
      reviewerUuid: reviewer['uuid'],
      reviewerImage: reviewer['profile_image'],
      reviewerName: reviewer['name'],
      role: json['role'],
      rating: (json['rating'] as num?)?.toDouble(),
      feedback: json['feedback'],
      createdAt: json['created_at'],
    );
  }

  static Map<String, dynamic> toDB(dynamic json) {
    final Map<String, dynamic> reviewer =
        (json['reviewer'] as Map?)?.cast<String, dynamic>() ?? {};
    return {
      'id': json['id'],
      'driverUuid': json['driverUuid'],
      'reviewerId': reviewer['id'],
      'reviewerUuid': reviewer['uuid'],
      'reviewerImage': reviewer['profile_image'],
      'reviewerName': reviewer['name'],
      'role': json['role'],
      'rating': (json['rating'] as num?)?.toDouble(),
      'feedback': json['feedback'],
      'createdAt': json['created_at'],
    };
  }

  factory RatingModel.fromDB(Map dbMap) {
    return RatingModel(
      id: dbMap['id'],
      driverUuid: dbMap['driverUuid'],
      reviewerId: dbMap['id'],
      reviewerUuid: dbMap['reviewerUuid'],
      reviewerImage: dbMap['reviewerImage'],
      reviewerName: dbMap['reviewerName'],
      role: dbMap['role'],
      rating: (dbMap['rating'] as num?)?.toDouble(),
      feedback: dbMap['feedback'],
      createdAt: dbMap['createdAt'],
    );
  }
}

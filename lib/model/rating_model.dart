import '/services/db_service.dart';
import 'package:hive/hive.dart';

part 'rating_model.g.dart';

@HiveType(typeId: ratingTypeID)
class RatingModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  ReviewerModel? reviewer;

  @HiveField(2)
  int? role;

  @HiveField(3)
  double? rating;

  @HiveField(4)
  String? feedback;

  @HiveField(5)
  String? createdAt;

  RatingModel({
    this.id,
    this.reviewer,
    this.role,
    this.rating,
    this.feedback,
    this.createdAt,
  });

  factory RatingModel.fromJson(Map<dynamic, dynamic> json) {
    return RatingModel(
      id: json['id'],
      reviewer: json['reviewer'] == null
          ? null
          : ReviewerModel.fromJson(json['reviewer']),
      role: json['role'],
      rating: (json['rating'] as num?)?.toDouble(),
      feedback: json['feedback'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reviewer': reviewer?.toJson(),
        'role': role,
        'rating': rating,
        'feedback': feedback,
        'created_at': createdAt,
      };
}

@HiveType(typeId: reviewerTypeID)
class ReviewerModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? profileImage;

  @HiveField(3)
  String? name;

  ReviewerModel({
    this.id,
    this.uuid,
    this.profileImage,
    this.name,
  });

  factory ReviewerModel.fromJson(Map<dynamic, dynamic> json) {
    return ReviewerModel(
      id: json['id'],
      uuid: json['uuid'],
      profileImage: json['profile_image'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'profile_image': profileImage,
        'name': name,
      };
}

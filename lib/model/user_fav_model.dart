import '/services/db_service.dart';
import 'package:hive/hive.dart';

part 'user_fav_model.g.dart';

@HiveType(typeId: favTypeID)
class UserFavouriteModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? userUuid;

  @HiveField(2)
  String? assetType;

  @HiveField(3)
  int? assetId;

  @HiveField(4)
  String? createdAt;

  @HiveField(5)
  String? updatedAt;

  UserFavouriteModel({
    this.id,
    this.userUuid,
    this.assetType,
    this.assetId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserFavouriteModel.fromJson(Map<String, dynamic> json) {
    return UserFavouriteModel(
      id: json['id'],
      userUuid: json['user_uuid'],
      assetType: json['asset_type'],
      assetId: json['asset_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_uuid': userUuid,
      'asset_type': assetType,
      'asset_id': assetId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<UserFavouriteModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      return UserFavouriteModel.fromJson(map);
    }).toList();
  }
}

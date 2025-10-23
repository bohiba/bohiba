class UserFavouriteModel {
  int? id;
  String? userUuid;
  String? assetType;
  int? assetId;
  String? createdAt;
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

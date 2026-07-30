import 'package:bohiba/dist/enums/enum_favourite_type.dart';

class FavouriteModel {
  int? id;
  int? userTruckId;
  int? truckId;

  int? userDriverId;
  int? driverId;

  int? minesId;

  bool? isFav;
  String? name;
  String? image;

  String? nameCode;

  int? type;

  FavouriteModel({
    this.id,
    this.userTruckId,
    this.truckId,
    this.userDriverId,
    this.driverId,
    this.minesId,
    this.isFav,
    this.name,
    this.image,
    this.nameCode,
    this.type,
  });

  /// 🔥 Factory Constructor (Auto Detect Type)
  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      id: json['id'],
      userTruckId: json['user_truck_id'],
      truckId: json['truck_id'],
      userDriverId: json['user_driver_id'],
      driverId: json['driver_id'],
      minesId: json['mines_id'],
      isFav: json['is_fav'],
      name: json['name'],
      image: json['image'],
      nameCode: json['name_code'],
      type: json['asset_type'],
    );
  }

  /// 🔥 Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_truck_id': userTruckId,
      'truck_id': truckId,
      'user_driver_id': userDriverId,
      'driver_id': driverId,
      'mines_id': minesId,
      'is_fav': isFav,
      'name': name,
      'image': image,
      'name_code': nameCode,
    };
  }

  static Map<String, dynamic> toDB(Map<dynamic, dynamic> json) {
    int type = _detectType(json);
    return {
      'id': json['id'],
      'userTruckId': json['user_truck_id'],
      'truckId': json['truck_id'],
      'userDriverId': json['user_driver_id'],
      'driverId': json['driver_id'],
      'companyId': json['company_id'],
      'isFav': json['is_fav'] == true ? 1 : 0,
      'name': json['name'],
      'image': json['image'],
      'nameCode': json['name_code'],
      'type': type,
    };
  }

  static FavouriteModel fromDB(Map map) {
    return FavouriteModel(
      id: map['id'],
      userTruckId: map['userTruckId'],
      truckId: map['truckId'],
      userDriverId: map['userDriverId'],
      driverId: map['driverId'],
      minesId: map['companyId'],
      isFav: map['isFav'] == 1 ? true : false,
      image: map['image'],
      name: map['name'],
      nameCode: map['nameCode'],
      type: int.tryParse(map['type'].toString()) ?? 0,
    );
  }

  /// Type detection: prefer explicit asset_type from server; fall back to
  /// non-null ID field inspection. containsKey alone is wrong — the server
  /// may return all keys with null values.
  static int _detectType(Map<dynamic, dynamic> json) {
    if (json['asset_type'] != null) {
      return json['asset_type'] as int;
    }
    if (json['truck_id'] != null || json['user_truck_id'] != null) {
      return EnumFavouriteType.truck.index;
    }
    if (json['driver_id'] != null || json['user_driver_id'] != null) {
      return EnumFavouriteType.driver.index;
    }
    if (json['company_id'] != null || json['mines_id'] != null) {
      return EnumFavouriteType.mines.index;
    }
    return EnumFavouriteType.unknown.index;
  }
}

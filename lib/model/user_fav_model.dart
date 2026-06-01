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

  String? type;

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
      type: json['type'],
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
      'type': _detectType(json),
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
      type: map['type'],
    );
  }

  /// 🔥 Type Detection Logic
  static String _detectType(Map<dynamic, dynamic> json) {
    if (json.containsKey('truck_id')) {
      return EnumFavouriteType.truck.name;
    } else if (json.containsKey('driver_id')) {
      return EnumFavouriteType.driver.name;
    } else if (json.containsKey('mines_id')) {
      return EnumFavouriteType.mines.name;
    } else {
      return EnumFavouriteType.unknown.name;
    }
  }
}

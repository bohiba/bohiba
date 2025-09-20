import '/extensions/bohiba_extension.dart';
import '/services/db_service.dart';
import '/model/user_fav_model.dart';
import '/services/global_service.dart';
import 'package:hive/hive.dart';

part 'truck_model.g.dart';

@HiveType(typeId: truckTypeID)
class TruckModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? truckImage;

  @HiveField(2)
  String? regdNumber;

  @HiveField(3)
  TruckDriverModel? driver;

  @HiveField(4)
  TruckOwnerModel? owner;

  @HiveField(5)
  RegistrationModel? registration;

  @HiveField(6)
  SpecsModel? specs;

  @HiveField(7)
  ValidityModel? validity;

  @HiveField(8)
  String? createdAt;

  @HiveField(9)
  String? updatedAt;

  @HiveField(10)
  bool isFav;

  TruckModel({
    this.id,
    this.truckImage,
    this.regdNumber,
    this.driver,
    this.owner,
    this.registration,
    this.specs,
    this.validity,
    this.createdAt,
    this.updatedAt,
    this.isFav = false,
  });

  factory TruckModel.fromJson(
    Map<String, dynamic> json, {
    List<UserFavouriteModel>? favList,
  }) {
    bool fav = favList?.any(
          (fav) => fav.assetType == "trucks" && fav.assetId == json["id"],
        ) ??
        false;

    return TruckModel(
      id: json['id'],
      truckImage: json['truck_image'] ??
          GlobalService.getAvatarUrl(
            json['regd_number'].toString().trim(),
            isTruck: true,
          ),
      regdNumber: json['regd_number'],
      isFav: fav,
      driver: json.containsKey('driver') && json['driver'] != null
          ? TruckDriverModel.fromJson(json['driver'])
          : null,
      owner: json.containsKey('owner') && json['owner'] != null
          ? TruckOwnerModel.fromJson(json['owner'])
          : null,
      registration: json['registration'] != null
          ? RegistrationModel.fromJson(json['registration'])
          : null,
      specs: json['specs'] == null ? null : SpecsModel.fromJson(json['specs']),
      validity: json['validity'] == null
          ? null
          : ValidityModel.fromJson(json['validity']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'truck_image': truckImage,
        'regd_number': regdNumber,
        'driver': driver?.toJson(),
        'owner': owner?.toJson(),
        'registration': registration?.toJson(),
        'specs': specs?.toJson(),
        'validity': validity?.toJson(),
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  static List<TruckModel> listFromJson(
    List<dynamic> jsonList, {
    List<UserFavouriteModel>? favList,
  }) {
    final favIds = (favList ?? [])
        .where((fav) => fav.assetType == "trucks" && fav.assetId != null)
        .map((fav) => fav.assetId!)
        .toSet();
    return jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      final isFav = favIds.contains(map["id"]);
      return TruckModel.fromJson(map)..isFav = isFav;
    }).toList();
  }
}

@HiveType(typeId: truckDriverTypeID)
class TruckDriverModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? profileImage;

  @HiveField(3)
  String? name;

  @HiveField(4)
  String? mobileNumber;

  TruckDriverModel({
    this.id,
    this.uuid,
    this.profileImage,
    this.name,
    this.mobileNumber,
  });

  factory TruckDriverModel.fromJson(Map<String, dynamic> json) =>
      TruckDriverModel(
        id: json['id'],
        uuid: json['uuid'],
        profileImage: json['profile_image'] ??
            GlobalService.getAvatarUrl(json['name'].toString().trim()),
        name: json['name'],
        mobileNumber: json['mobile_number'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'profile_image': profileImage,
        'name': name,
        'mobile_number': mobileNumber,
      };
}

@HiveType(typeId: truckOwnerTypeID)
class TruckOwnerModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? profileImage;

  @HiveField(3)
  String? name;

  @HiveField(4)
  String? mobileNumber;

  TruckOwnerModel({
    this.id,
    this.uuid,
    this.profileImage,
    this.name,
    this.mobileNumber,
  });

  factory TruckOwnerModel.fromJson(Map<String, dynamic> json) =>
      TruckOwnerModel(
        id: json['id'],
        uuid: json['uuid'],
        profileImage: json['profile_image'] ??
            GlobalService.getAvatarUrl(json['name'].toString().trim()),
        name: json['name'],
        mobileNumber: json['mobile_number'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'profile_image': profileImage,
        'name': name,
        'mobile_number': mobileNumber,
      };
}

@HiveType(typeId: registrationTypeID)
class RegistrationModel {
  @HiveField(0)
  String? place;

  @HiveField(1)
  String? registrationDate;

  @HiveField(2)
  String? rcStatus;

  @HiveField(3)
  String? rcModel;

  @HiveField(4)
  int? rcOwnerSr;

  @HiveField(5)
  String? rcVhClassDesc;

  RegistrationModel({
    this.place,
    this.registrationDate,
    this.rcStatus,
    this.rcModel,
    this.rcOwnerSr,
    this.rcVhClassDesc,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      RegistrationModel(
        place: json['place'],
        registrationDate: json['registration_date'],
        rcStatus: json['rc_status'],
        rcModel: json['rc_model'],
        rcOwnerSr: json['rc_owner_sr'],
        rcVhClassDesc: json['rc_vh_class_desc'],
      );

  Map<String, dynamic> toJson() => {
        'place': place,
        'registration_date': registrationDate,
        'rc_status': rcStatus,
        'rc_model': rcModel,
        'rc_owner_sr': rcOwnerSr,
        'rc_vh_class_desc': rcVhClassDesc,
      };
}

@HiveType(typeId: specsTypeID)
class SpecsModel {
  @HiveField(0)
  String? brand;

  @HiveField(1)
  String? model;

  @HiveField(2)
  String? engineNo;

  @HiveField(3)
  String? chassisNo;

  @HiveField(4)
  String? fuelType;

  @HiveField(5)
  double? unladenWeight;

  @HiveField(6)
  String? financer;

  @HiveField(7)
  String? insurancePolicyNo;

  @HiveField(8)
  String? insuranceCompany;

  SpecsModel({
    this.brand,
    this.model,
    this.engineNo,
    this.chassisNo,
    this.fuelType,
    this.unladenWeight,
    this.financer,
    this.insurancePolicyNo,
    this.insuranceCompany,
  });

  factory SpecsModel.fromJson(Map<String, dynamic> json) => SpecsModel(
        brand: json['brand'],
        model: json['model'],
        engineNo: json['engine_no'],
        chassisNo: json['chassis_no'],
        fuelType: json['fuel_type'],
        unladenWeight: json['unladen_weight'] == null
            ? null
            : json['unloaden_weight'].toString().toDouble(),
        financer: json['financer'],
        insurancePolicyNo: json['insurance_policy_no'],
        insuranceCompany: json['insurance_company'],
      );

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'model': model,
        'engine_no': engineNo,
        'chassis_no': chassisNo,
        'fuel_type': fuelType,
        'unladen_weight': unladenWeight,
        'financer': financer,
        'insurance_policy_no': insurancePolicyNo,
        'insurance_company': insuranceCompany,
      };
}

@HiveType(typeId: validityTypeID)
class ValidityModel {
  @HiveField(0)
  String? insuranceUpto;

  @HiveField(1)
  String? taxUpto;

  @HiveField(2)
  String? puccUpto;

  @HiveField(3)
  String? fitnessUpto;

  ValidityModel({
    this.insuranceUpto,
    this.taxUpto,
    this.puccUpto,
    this.fitnessUpto,
  });

  factory ValidityModel.fromJson(Map<String, dynamic> json) => ValidityModel(
        insuranceUpto: json['insurance_upto'],
        taxUpto: json['tax_upto'],
        puccUpto: json['pucc_upto'],
        fitnessUpto: json['fitness_upto'],
      );

  Map<String, dynamic> toJson() => {
        'insurance_upto': insuranceUpto,
        'tax_upto': taxUpto,
        'pucc_upto': puccUpto,
        'fitness_upto': fitnessUpto,
      };
}

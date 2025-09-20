import '/model/rating_model.dart';

import '/model/user_fav_model.dart';
import '/services/db_service.dart';
import 'package:hive/hive.dart';

part 'driver_model.g.dart';

@HiveType(typeId: driverTypeID)
class DriverModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  bool? isSynced;

  @HiveField(2)
  DriverProfile? profile;

  @HiveField(3)
  LicenseDetail? licenseDetail;

  @HiveField(4)
  List<RatingModel>? rating;

  @HiveField(5)
  String? createdAt;

  @HiveField(6)
  String? updatedAt;

  @HiveField(7)
  bool? isFav;

  @HiveField(8)
  DriverAddress? address;

  DriverModel({
    this.id,
    this.isSynced,
    this.profile,
    this.licenseDetail,
    this.rating,
    this.isFav = false,
    this.createdAt,
    this.updatedAt,
    this.address,
  });

  factory DriverModel.fromJson(
    Map<String, dynamic> json, {
    List<UserFavouriteModel>? favList,
  }) {
    bool fav = favList?.any(
          (fav) => fav.assetType == "drivers" && fav.assetId == json["id"],
        ) ??
        false;
    return DriverModel(
      id: json['id'],
      isSynced: json['is_synced'] == 1,
      isFav: fav,
      profile: json['profile'] != null
          ? DriverProfile.fromJson(json['profile'])
          : null,
      licenseDetail: json['license_detail'] != null
          ? LicenseDetail.fromJson(json['license_detail'])
          : null,
      address: json['address'] != null
          ? DriverAddress.fromJson(json['address'])
          : null,
      rating: json['rating'] != null
          ? List<RatingModel>.from(
              json['rating'].map((x) => RatingModel.fromJson(x)))
          : [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_synced': isSynced == true ? 1 : 0,
        'profile': profile?.toJson(),
        'license_detail': licenseDetail?.toJson(),
        'address': address?.toJson(),
        'rating': rating?.map((x) => x.toJson()).toList(),
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  static List<DriverModel> listFromJson(
    List<dynamic> jsonList, {
    List<UserFavouriteModel>? favList,
  }) {
    final favIds = (favList ?? [])
        .where((fav) => fav.assetType == "drivers" && fav.assetId != null)
        .map((fav) => fav.assetId!)
        .toSet();
    return jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      final isFav = favIds.contains(map["id"]);
      return DriverModel.fromJson(map)..isFav = isFav;
    }).toList();
  }
}

@HiveType(typeId: driverProfileTypeID)
class DriverProfile extends HiveObject {
  @HiveField(0)
  String? driverUuid;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? mobileNumber;

  @HiveField(4)
  String? image;

  @HiveField(5)
  String? dob;

  @HiveField(6)
  int? roleId;

  @HiveField(7)
  String? isActive;

  DriverProfile({
    this.driverUuid,
    this.name,
    this.email,
    this.mobileNumber,
    this.image,
    this.dob,
    this.roleId,
    this.isActive,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) => DriverProfile(
        driverUuid: json['driver_uuid'],
        name: json['name'],
        email: json['email'],
        mobileNumber: json['mobile_number'],
        image: json['profile_image'],
        dob: json['dob'],
        roleId: json['role_id'],
        isActive: json['is_active'],
      );

  Map<String, dynamic> toJson() => {
        'driver_uuid': driverUuid,
        'name': name,
        'email': email,
        'mobile_number': mobileNumber,
        'profile_image': image,
        'dob': dob,
        'role_id': roleId,
        'is_active': isActive,
      };
}

@HiveType(typeId: driverAddressTypeID)
class DriverAddress extends HiveObject {
  @HiveField(0)
  String? houseNo;

  @HiveField(1)
  String? locality;

  @HiveField(2)
  String? street;

  @HiveField(3)
  String? city;

  @HiveField(4)
  String? district;

  @HiveField(5)
  String? state;

  @HiveField(6)
  String? country;

  @HiveField(7)
  String? pinCode;

  DriverAddress({
    this.houseNo,
    this.locality,
    this.street,
    this.city,
    this.district,
    this.state,
    this.country,
    this.pinCode,
  });

  factory DriverAddress.fromJson(Map<String, dynamic> json) => DriverAddress(
        houseNo: json['house_no'],
        locality: json['locality'],
        street: json['street'],
        city: json['city'],
        district: json['district'],
        state: json['state'],
        country: json['country'],
        pinCode: json['pin_code'],
      );

  Map<String, dynamic> toJson() => {
        'house_no': houseNo,
        'locality': locality,
        'street': street,
        'city': city,
        'district': district,
        'state': state,
        'country': country,
        'pin_code': pinCode,
      };
}

@HiveType(typeId: licenseDetailTypeID)
class LicenseDetail extends HiveObject {
  @HiveField(0)
  String? licenseNumber;

  @HiveField(1)
  String? status;

  @HiveField(2)
  String? rto;

  @HiveField(3)
  String? cov;

  @HiveField(4)
  String? validityFrom;

  @HiveField(5)
  String? validityTill;

  LicenseDetail({
    this.licenseNumber,
    this.status,
    this.rto,
    this.cov,
    this.validityFrom,
    this.validityTill,
  });

  factory LicenseDetail.fromJson(Map<String, dynamic> json) => LicenseDetail(
        licenseNumber: json['license_number'],
        status: json['status'],
        rto: json['rto'],
        cov: json['cov'],
        validityFrom: json['validity_from'],
        validityTill: json['validity_till'],
      );

  Map<String, dynamic> toJson() => {
        'license_number': licenseNumber,
        'status': status,
        'rto': rto,
        'cov': cov,
        'validity_from': validityFrom,
        'validity_till': validityTill,
      };
}

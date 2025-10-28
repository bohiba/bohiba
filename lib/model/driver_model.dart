import '/model/rating_model.dart';

class UserModel {
  int? id;
  int? isSynced;
  int? isFav;
  UserProfile? profile;
  LicenseDetail? licenseDetail;
  List<RatingModel>? rating;
  String? createdAt;
  String? updatedAt;
  CommonUserAddress? address;
  int? trips;

  UserModel({
    this.id,
    this.isSynced,
    this.profile,
    this.licenseDetail,
    this.rating,
    this.isFav,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.trips,
  });

  factory UserModel.fromJson(dynamic json) {
    Map<dynamic, dynamic> mapObj = json;
    return UserModel(
      id: mapObj['id'],
      isSynced: mapObj['is_synced'],
      isFav: json['is_fav'],
      profile: mapObj['profile'] != null
          ? UserProfile.fromJson(mapObj['profile'])
          : null,
      licenseDetail: mapObj['license_detail'] != null
          ? LicenseDetail.fromJson(mapObj['license_detail'])
          : null,
      address: mapObj['address'] != null
          ? CommonUserAddress.fromJson(mapObj['address'])
          : null,
      rating: mapObj['rating'] != null
          ? List<RatingModel>.from(
              mapObj['rating'].map((x) => RatingModel.fromJson(x)))
          : [],
      trips: mapObj['trips'],
      createdAt: mapObj['created_at'],
      updatedAt: mapObj['updated_at'],
    );
  }

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'is_synced': isSynced,
  //       'is_fav': isFav,
  //       'profile': profile?.toJson(),
  //       'license_detail': licenseDetail?.toJson(),
  //       'address': address?.toJson(),
  //       'rating': rating?.map((x) => x.toJson()).toList(),
  //       'trips': trips,
  //       'created_at': createdAt,
  //       'updated_at': updatedAt,
  //     };

  static List<UserModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      return UserModel.fromJson(map);
    }).toList();
  }

  static Map<String, dynamic> toDB(dynamic json, {bool isOpenDriver = false}) {
    final Map<String, dynamic> driver = json as Map<String, dynamic>;
    final Map<String, dynamic> profile = driver['profile'] ?? {};
    final Map<String, dynamic> address = driver['address'] ?? {};
    final Map<String, dynamic> licenseDetail = driver['license_detail'] ?? {};
    final Map<String, dynamic> map = <String, dynamic>{
      'id': driver['id'],
      'isSynced': driver['is_synced'],
      'image': profile['profile_image'],
      'uuid': profile['driver_uuid'],
      'name': profile['name'],
      'email': profile['email'],
      'mobileNumber': profile['mobile_number'],
      'dob': profile['dob'],
      'roleId': profile['role_id'],
      'isActive': profile['is_active'],
      'houseNo': address['house_no'],
      'locality': address['locality'],
      'street': address['street'],
      'city': address['city'],
      'district': address['district'],
      'state': address['state'],
      'country': address['country'],
      'pinCode': address['pin_code'],
      'licenseNumber': licenseDetail['license_number'],
      'dlStatus': licenseDetail['status'],
      'cov': licenseDetail['cov'],
      'rto': licenseDetail['rto'],
      'validFrom': licenseDetail['validity_from'],
      'validTill': licenseDetail['validity_till'],
      'updatedAt': driver['updated_at'],
    };
    if (isOpenDriver) {
      if (profile.containsKey('connect')) {
        map['connect'] = profile['connect'];
      }

      if (address.containsKey('verified')) {
        map['verified'] = driver['verified'];
      }
    }

    if (!isOpenDriver) {
      map['isFav'] = driver['is_fav'] ?? 0;
    }

    return map;
  }

  static UserModel fromDB(Map<String, dynamic> dbMap) {
    return UserModel(
      id: dbMap['id'],
      isFav: dbMap['isFav'],
      isSynced: dbMap['isSynced'],
      createdAt: dbMap['createdAt'],
      updatedAt: dbMap['updatedAt'],
      profile: UserProfile.fromDbMap(dbMap),
      address: CommonUserAddress.fromDbMap(dbMap),
      licenseDetail: LicenseDetail.fromDbMap(dbMap),
      trips: dbMap['trips'],
    );
  }
}

class UserProfile {
  String? driverUuid;
  String? ownerUuid;
  String? name;
  String? email;
  String? mobileNumber;
  String? image;
  String? dob;
  int? roleId;
  String? isActive;
  String? connect;

  UserProfile({
    this.driverUuid,
    this.ownerUuid,
    this.name,
    this.email,
    this.mobileNumber,
    this.image,
    this.dob,
    this.roleId,
    this.isActive,
    this.connect,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        driverUuid: json['driver_uuid'],
        ownerUuid: json['owner_uuid'],
        name: json['name'],
        email: json['email'],
        mobileNumber: json['mobile_number'],
        image: json['profile_image'],
        dob: json['dob'],
        roleId: json['role_id'],
        isActive: json['is_active'],
        connect: json['connect'],
      );

  Map<String, dynamic> toJson() => {
        'driver_uuid': driverUuid,
        'owner_uuid': ownerUuid,
        'name': name,
        'email': email,
        'mobile_number': mobileNumber,
        'profile_image': image,
        'dob': dob,
        'role_id': roleId,
        'is_active': isActive,
        'connect': connect,
      };

  static UserProfile fromDbMap(Map<String, dynamic> map) {
    return UserProfile(
      driverUuid: map['uuid'],
      ownerUuid: map[''],
      name: map['name'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      image: map['image'],
      dob: map['dob'],
      roleId: map['roleId'],
      isActive: map['isActive'],
      connect: map['connect'],
    );
  }
}

class CommonUserAddress {
  int? id;
  String? verified;
  String? houseNo;
  String? locality;
  String? street;
  String? city;
  String? district;
  String? state;
  String? country;
  String? pinCode;

  CommonUserAddress({
    this.id,
    this.verified,
    this.houseNo,
    this.locality,
    this.street,
    this.city,
    this.district,
    this.state,
    this.country,
    this.pinCode,
  });

  factory CommonUserAddress.fromJson(Map<String, dynamic> json) =>
      CommonUserAddress(
        id: json['id'],
        verified: json['verified'],
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
        'id': id,
        'verified': verified,
        'house_no': houseNo,
        'locality': locality,
        'street': street,
        'city': city,
        'district': district,
        'state': state,
        'country': country,
        'pin_code': pinCode,
      };

  static CommonUserAddress fromDbMap(Map<String, dynamic> map) {
    return CommonUserAddress(
      verified: map['verified'],
      houseNo: map['houseNo'],
      locality: map['locality'],
      street: map['street'],
      city: map['city'],
      district: map['district'],
      state: map['state'],
      country: map['country'],
      pinCode: map['pinCode'],
    );
  }
}

class LicenseDetail {
  String? licenseNumber;
  String? status;
  String? rto;
  String? cov;
  String? validityFrom;
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

  static LicenseDetail fromDbMap(Map<String, dynamic> map) {
    return LicenseDetail(
      licenseNumber: map['licenseNumber'],
      status: map['dlStatus'],
      cov: map['cov'],
      rto: map['rto'],
      validityFrom: map['validFrom'],
      validityTill: map['validTill'],
    );
  }
}

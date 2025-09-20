import 'rating_model.dart';
import '/services/db_service.dart';
import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: profileTypeID)
class ProfileModel extends HiveObject {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? mobileNumber;

  @HiveField(4)
  String? dob;

  @HiveField(5)
  int? roleId;

  @HiveField(6)
  String? jobStatus;

  @HiveField(7)
  VerificationModel? verification;

  @HiveField(8)
  int? trucks;

  @HiveField(9)
  int? drivers;

  /// Only for Driver role (roleId == 8)
  @HiveField(10)
  List<RatingModel>? ratings;

  ProfileModel({
    this.uuid,
    this.name,
    this.email,
    this.mobileNumber,
    this.dob,
    this.roleId,
    this.jobStatus,
    this.verification,
    this.trucks,
    this.drivers,
    this.ratings,
  });

  factory ProfileModel.fromJson(Map<dynamic, dynamic> json) {
    return ProfileModel(
      uuid: json['uuid'],
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      dob: json['dob'],
      roleId: json['role_id'],
      jobStatus: json['job_status'],
      verification: json['verification'] == null
          ? null
          : VerificationModel.fromJson(json['verification']),
      trucks: json['trucks'],
      drivers: json['drivers'],
      ratings: json['ratings'] == null
          ? null
          : List<RatingModel>.from(
              json['ratings'].map((x) => RatingModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'email': email,
        'mobile_number': mobileNumber,
        'dob': dob,
        'role_id': roleId,
        'job_status': jobStatus,
        'verification': verification?.toJson(),
        'trucks': trucks,
        'drivers': drivers,
        'ratings': ratings?.map((x) => x.toJson()).toList(),
      };
}

@HiveType(typeId: verficationTypeID)
class VerificationModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? userUuid;

  @HiveField(2)
  String? panNumber;

  @HiveField(3)
  String? aadhaarNumber;

  @HiveField(4)
  String? dlNumber;

  @HiveField(5)
  String? verificationStatus;

  @HiveField(6)
  String? houseNo;

  @HiveField(7)
  String? locality;

  @HiveField(8)
  String? street;

  @HiveField(9)
  String? city;

  @HiveField(10)
  String? district;

  @HiveField(11)
  String? state;

  @HiveField(12)
  String? country;

  @HiveField(13)
  String? pinCode;

  @HiveField(14)
  String? createdAt;

  @HiveField(15)
  String? updatedAt;

  VerificationModel({
    this.id,
    this.userUuid,
    this.panNumber,
    this.aadhaarNumber,
    this.dlNumber,
    this.verificationStatus,
    this.houseNo,
    this.locality,
    this.street,
    this.city,
    this.district,
    this.state,
    this.country,
    this.pinCode,
    this.createdAt,
    this.updatedAt,
  });

  factory VerificationModel.fromJson(Map<dynamic, dynamic> json) {
    return VerificationModel(
      id: json['id'],
      userUuid: json['user_uuid'],
      panNumber: json['pan_number'],
      aadhaarNumber: json['aadhaar_number'],
      dlNumber: json['dl_number'],
      verificationStatus: json['verification_status'],
      houseNo: json['house_no'],
      locality: json['locality'],
      street: json['street'],
      city: json['city'],
      district: json['district'],
      state: json['state'],
      country: json['country'],
      pinCode: json['pin_code'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_uuid': userUuid,
        'pan_number': panNumber,
        'aadhaar_number': aadhaarNumber,
        'dl_number': dlNumber,
        'verification_status': verificationStatus,
        'house_no': houseNo,
        'locality': locality,
        'street': street,
        'city': city,
        'district': district,
        'state': state,
        'country': country,
        'pin_code': pinCode,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

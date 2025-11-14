import 'rating_model.dart';

class ProfileModel {
  int? id;
  String? uuid;
  String? image;
  String? name;
  String? email;
  String? mobileNumber;
  int? roleId;
  String? dob;
  String? jobStatus;
  int? trucks;
  int? driver;
  String? panNumber;
  String? aadharNumber;
  String? dlNumber;
  String? verified;
  String? houseNo;
  String? locality;
  String? street;
  String? city;
  String? district;
  String? state;
  String? country;
  String? pinCode;
  List<RatingModel>? ratings;

  ProfileModel({
    this.id,
    this.uuid,
    this.image,
    this.name,
    this.email,
    this.mobileNumber,
    this.roleId,
    this.dob,
    this.jobStatus,
    this.trucks,
    this.driver,
    this.panNumber,
    this.aadharNumber,
    this.dlNumber,
    this.verified,
    this.houseNo,
    this.locality,
    this.street,
    this.city,
    this.district,
    this.state,
    this.country,
    this.pinCode,
    this.ratings,
  });

  // ✅ From API JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final verification = json['verification'] ?? {};
    return ProfileModel(
      uuid: json['uuid'],
      image: json['profile_image'],
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      dob: json['dob'],
      roleId: json['role_id'],
      jobStatus: json['job_status'],
      trucks: json['trucks'],
      driver: json['drivers'],
      panNumber: verification['pan_number'],
      aadharNumber: verification['aadhaar_number'],
      dlNumber: verification['dl_number'],
      verified: verification['verification_status'],
      houseNo: verification['house_no'],
      locality: verification['locality'],
      street: verification['street'],
      city: verification['city'],
      district: verification['district'],
      state: verification['state'],
      country: verification['country'],
      pinCode: verification['pin_code'],
      ratings: verification['ratings'] == null
          ? null
          : List<RatingModel>.from(
              (json['ratings'] as List).map((x) => RatingModel.fromDB(x))),
    );
  }

  // ✅ To Map (for insert/update in SQLite)
  static Map<String, dynamic> toDB(dynamic json) {
    final verification = json['verification'] ?? {};
    return {
      'uuid': json['uuid'],
      'image': json['profile_image'],
      'name': json['name'],
      'email': json['email'],
      'mobileNumber': json['mobile_number'],
      'roleId': json['role_id'],
      'dob': json['dob'],
      'jobStatus': json['job_status'],
      'trucks': json['trucks'],
      'driver': json['drivers'],
      'panNumber': verification['pan_number'],
      'aadharNumber': verification['aadhaar_number'],
      'dlNumber': verification['dl_number'],
      'verified': verification['verification_status'],
      'houseNo': verification['house_no'],
      'locality': verification['locality'],
      'street': verification['street'],
      'city': verification['city'],
      'district': verification['district'],
      'state': verification['state'],
      'country': verification['country'],
      'pinCode': verification['pin_code'],
    };
  }

  // ✅ From DB Row → Model
  factory ProfileModel.fromDb(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      uuid: map['uuid'],
      image: map['image'],
      name: map['name'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      roleId: map['roleId'],
      dob: map['dob'],
      jobStatus: map['jobStatus'],
      trucks: map['trucks'],
      driver: map['driver'],
      panNumber: map['panNumber'],
      aadharNumber: map['aadharNumber'],
      dlNumber: map['dlNumber'],
      verified: map['verified'],
      houseNo: map['houseNo'],
      locality: map['locality'],
      street: map['street'],
      city: map['city'],
      district: map['district'],
      state: map['state'],
      country: map['country'],
      pinCode: map['pinCode'],
      ratings: map['ratings'] == null
          ? null
          : List<RatingModel>.from(
              (map['ratings'] as List).map((x) => RatingModel.fromDB(x))),
    );
  }
}

import '/services/db_service.dart';
import 'package:hive/hive.dart';

part 'open_driver_model.g.dart';

@HiveType(typeId: openDriverTypeID)
class OpenDriverModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? mobileNumber;

  @HiveField(5)
  String? profileImage;

  @HiveField(6)
  String? verified;

  @HiveField(7)
  String? district;

  @HiveField(8)
  String? state;

  @HiveField(9)
  String? connect;

  OpenDriverModel({
    this.id,
    this.uuid,
    this.profileImage,
    this.name,
    this.mobileNumber,
    this.verified,
    this.district,
    this.state,
    this.connect,
  });

  factory OpenDriverModel.fromJson(Map<String, dynamic> json) {
    return OpenDriverModel(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      profileImage: json['profile_image'],
      mobileNumber: json['mobile_number'],
      verified: json['verified'],
      district: json['district'],
      state: json['state'],
      connect: json['connect'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'name': name,
        'profile_image': profileImage,
        'mobile_number': mobileNumber,
        'verified': verified,
        'district': district,
        'state': state,
        'connect': connect,
      };

  static List<OpenDriverModel> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OpenDriverModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

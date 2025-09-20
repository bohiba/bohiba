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
  String? profileImage;

  @HiveField(4)
  String? mobileNumber;

  @HiveField(5)
  String? jobStatus;

  OpenDriverModel({
    this.id,
    this.uuid,
    this.name,
    this.profileImage,
    this.mobileNumber,
    this.jobStatus,
  });

  factory OpenDriverModel.fromJson(Map<String, dynamic> json) {
    return OpenDriverModel(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      profileImage: json['profile_image'],
      mobileNumber: json['mobile_number'],
      jobStatus: json['job_status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'name': name,
        'profile_image': profileImage,
        'mobile_number': mobileNumber,
        'job_status': jobStatus,
      };

  static List<OpenDriverModel> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => OpenDriverModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class JobDetailModel {
  final int? id;
  final String? startFrom;
  final String? ownerUuid;
  final String? jobTitle;
  final String? regdNumber;
  final String? location;
  final dynamic licenseType;
  final String? jobType;
  final String? description;
  final String? status;
  final List<InterestedDriver>? interestedDrivers;
  final String? createdAt;
  final String? updatedAt;

  JobDetailModel({
    this.id,
    this.startFrom,
    this.ownerUuid,
    this.jobTitle,
    this.regdNumber,
    this.location,
    this.licenseType,
    this.jobType,
    this.description,
    this.status,
    this.interestedDrivers,
    this.createdAt,
    this.updatedAt,
  });

  factory JobDetailModel.fromMap(Map json) => JobDetailModel(
        id: json["id"],
        startFrom: json["start_from"],
        ownerUuid: json["owner_uuid"],
        jobTitle: json["job_title"],
        regdNumber: json["regd_number"],
        location: json["location"],
        licenseType: json["license_type"],
        jobType: json["job_type"],
        description: json["description"],
        status: json["status"],
        interestedDrivers: json["interested_drivers"] == null
            ? []
            : List<InterestedDriver>.from(json["interested_drivers"]!
                .map((x) => InterestedDriver.fromMap(x))),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  factory JobDetailModel.fromDB(Map<String, dynamic> mapDB) => JobDetailModel(
        id: mapDB['id'],
        startFrom: mapDB['startFrom'],
        ownerUuid: mapDB['ownerUuid'],
        jobTitle: mapDB['jobTitle'],
        regdNumber: mapDB['vhNumber'],
        location: mapDB['location'],
        licenseType: mapDB['licenseType'],
        jobType: mapDB['jobType'],
        description: mapDB['description'],
        status: mapDB['status'],
        createdAt: mapDB['createdAt'],
        updatedAt: mapDB['updatedAt'],
      );

  static Map<String, dynamic> toDB(Map json) {
    return {
      "id": json["id"],
      "startFrom": json["start_from"],
      "ownerUuid": json["owner_uuid"],
      "jobTitle": json["job_title"],
      "vhNumber": json["regd_number"],
      "location": json["location"],
      "licenseType": json["license_type"],
      "jobType": json["job_type"],
      "description": json["description"],
      "status": json["status"],
      "createdAt": json["created_at"],
      "updatedAt": json["updated_at"],
    };
  }
}

class InterestedDriver {
  final int? id;
  final String? uuid;
  final String? profileImage;
  final String? name;
  final String? mobileNumber;
  final String? jobStatus;
  final String? createdAt;

  InterestedDriver({
    this.id,
    this.uuid,
    this.profileImage,
    this.name,
    this.mobileNumber,
    this.jobStatus,
    this.createdAt,
  });

  factory InterestedDriver.fromMap(Map<String, dynamic> json) =>
      InterestedDriver(
        id: json["id"],
        uuid: json["uuid"],
        profileImage: json["profile_image"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        jobStatus: json["job_status"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "uuid": uuid,
        "profile_image": profileImage,
        "name": name,
        "mobile_number": mobileNumber,
        "job_status": jobStatus,
        "created_at": createdAt,
      };
}

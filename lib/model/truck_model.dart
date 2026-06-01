class TruckModel {
  int? id;
  bool? isFav;

  int? truckId;
  String? truckImage;
  String? regdNumber;
  int? trips;

  int? driverId;
  String? driverUuid;
  String? driverImage;
  String? driverName;
  String? driverMobileNumber;

  int? ownerId;
  String? ownerUuid;
  String? ownerImage;
  String? ownerName;
  String? ownerMobileNumber;

  String? place;
  String? regdDate;
  int? rcStatus;
  String? rcModel;
  int? rcOwnerSr;
  String? rcDesc;

  String? vhBrand;
  String? vhModel;
  String? vhEngineNo;
  String? vhChassisNo;
  String? vhFuelType;
  double? vhUnladenWeight;
  String? vhFinancer;
  String? vhInsuranceNo;
  String? vhInsuranceCompany;

  String? insuranceUpto;
  String? taxUpto;
  String? puccUpto;
  String? fitnessUpto;

  String? updatedAt;
  String? createdAt;

  TruckModel({
    this.id,
    this.truckId,
    this.truckImage,
    this.regdNumber,
    this.isFav = false,
    this.trips = 0,
    this.driverId,
    this.driverImage,
    this.driverUuid,
    this.driverName,
    this.driverMobileNumber,
    this.ownerId,
    this.ownerUuid,
    this.ownerImage,
    this.ownerName,
    this.ownerMobileNumber,
    this.place,
    this.regdDate,
    this.rcStatus,
    this.rcModel,
    this.rcOwnerSr,
    this.rcDesc,
    this.vhBrand,
    this.vhModel,
    this.vhEngineNo,
    this.vhChassisNo,
    this.vhFuelType,
    this.vhUnladenWeight,
    this.vhFinancer,
    this.vhInsuranceNo,
    this.vhInsuranceCompany,
    this.insuranceUpto,
    this.taxUpto,
    this.puccUpto,
    this.fitnessUpto,
    this.updatedAt,
    this.createdAt,
  });

  static Map<String, dynamic> toDB(Map<String, dynamic> json) {
    final driver = json['driver'] ?? {};
    final owner = json['owner'] ?? {};
    final reg = json['registration'] ?? {};
    final specs = json['specs'] ?? {};
    final valid = json['validity'] ?? {};
    return {
      'id': json['id'],
      'truckId': json['truck_id'],
      'isFav': json['is_fav'] == false ? 0 : 1,
      'image': json['truck_image'],
      'vhNumber': json['regd_number'],
      'trips': json['trips'],
      'driverId': driver['id'],
      'driverImage': driver['image'],
      'driverUuid': driver['uuid'],
      'driverName': driver['name'],
      'driverMobileNumber': driver['mobile_number'],
      'ownerId': owner['id'],
      'ownerImage': owner['image'],
      'ownerUuid': owner['uuid'],
      'ownerName': owner['name'],
      'ownerMobileNumber': owner['mobile_number'],
      'registrationPlace': reg['place'],
      'registrationDate': reg['registration_date'],
      'rcStatus': reg['rc_status'],
      'rcModel': reg['rc_model'],
      'rcOwnerSr': reg['rc_owner_sr'],
      'vhDesc': reg['rc_vh_class_desc'],
      'vhBrand': specs['brand'],
      'vhModel': specs['model'],
      'vhEngineNo': specs['engine_number'],
      'vhChassisNo': specs['chassis_number'],
      'vhFuelType': specs['fuel_type'],
      'vhUnladenWeight': specs['unladen_weight'],
      'vhFinancer': specs['financer'],
      'vhInsuranceNo': specs['insurance_policy_no'],
      'vhInsuranceCompany': specs['insurance_company'],
      'insuranceUpto': valid['insurance_upto'],
      'taxUpto': valid['tax_upto'],
      'puccUpto': valid['pucc_upto'],
      'fitnessUpto': valid['fitness_upto'],
      'updatedAt': json['updated_at'],
      'createdAt': json['created_at']
    };
  }

  /// ✅ Convert back from DB Map
  factory TruckModel.fromDB(Map<String, dynamic> map) => TruckModel(
        id: map['id'],
        truckId: map['truckId'],
        truckImage: map['image'],
        regdNumber: map['vhNumber'],
        isFav: map['isFav'] == 0 ? false : true,
        trips: map['trips'],
      )
        ..driverId = map['driverId']
        ..driverUuid = map['driverUuid']
        ..driverImage = map['driverImage']
        ..driverName = map['driverName']
        ..driverMobileNumber = map['driverMobileNumber']
        ..ownerId = map['ownerId']
        ..ownerUuid = map['ownerUuid']
        ..ownerImage = map['ownerImage']
        ..ownerName = map['ownerName']
        ..ownerMobileNumber = map['ownerMobileNumber']
        ..place = map['registrationPlace']
        ..regdDate = map['registrationDate']
        ..rcStatus = map['rcStatus']
        ..rcModel = map['rcModel']
        ..rcOwnerSr = map['rcOwnerSr']
        ..rcDesc = map['vhDesc']
        ..vhBrand = map['vhBrand']
        ..vhModel = map['vhModel']
        ..vhEngineNo = map['vhEngineNo']
        ..vhChassisNo = map['vhChassisNo']
        ..vhFuelType = map['vhFuelType']
        ..vhUnladenWeight = (map['vhUnladenWeight'])?.toDouble() ?? 0.0
        ..vhFinancer = map['vhFinancer']
        ..vhInsuranceNo = map['vhInsuranceNo']
        ..vhInsuranceCompany = map['vhInsuranceCompany']
        ..insuranceUpto = map['insuranceUpto']
        ..taxUpto = map['taxUpto']
        ..puccUpto = map['puccUpto']
        ..fitnessUpto = map['fitnessUpto']
        ..updatedAt = map['updatedAt']
        ..createdAt = map['createdAt'];
}

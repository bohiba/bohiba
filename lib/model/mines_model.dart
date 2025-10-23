class MinesModel {
  int? id;
  int? isFav;
  String? logo;
  String? mineName;
  String? location;
  String? materialType;
  String? materialGrade;
  String? ownershipType;
  String? penaltyRisk;
  String? safetyGearMandate;
  String? shiftTiming;
  int? waitingPeriod;
  String? roadConditions;
  String? createdAt;
  String? updatedAt;

  MinesModel({
    this.id,
    this.isFav = 0,
    this.logo,
    this.mineName,
    this.location,
    this.materialType,
    this.materialGrade,
    this.ownershipType,
    this.penaltyRisk,
    this.safetyGearMandate,
    this.shiftTiming,
    this.waitingPeriod,
    this.roadConditions,
  });

  static Map<String, dynamic> toDB(dynamic json) {
    return {
      'id': json['id'],
      'isFav': json['is_fav'] ?? 0,
      'logo': json['logo'],
      'mineName': json['mine_name'],
      'location': json['location'],
      'materialType': json['material_type'],
      'materialGrade': json['material_grade'],
      'ownershipType': json['ownership_type'],
      'penaltyRisk': json['penalty_risk'],
      'gearMandate': json['safety_gear_mandate'],
      'shiftTiming': json['shift_timing'],
      'waitingPeriod': json['waiting_period'],
      'roadConditions': json['road_conditions'],
    };
  }

  static MinesModel fromDB(Map mines) {
    return MinesModel(
      id: mines['id'],
      isFav: mines['isFav'],
      logo: mines['logo'],
      mineName: mines['mineName'],
      location: mines['location'],
      materialType: mines['materialType'],
      materialGrade: mines['materialGrade'],
      ownershipType: mines['ownershipType'],
      penaltyRisk: mines['penaltyRisk'],
      safetyGearMandate: mines['gearMandate'],
      shiftTiming: mines['shiftTiming'],
      waitingPeriod: mines['waitingPeriod'],
      roadConditions: mines['roadConditions'],
    );
  }
}

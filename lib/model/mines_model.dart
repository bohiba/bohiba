class MinesModel {
  int? id;
  int? isFav;
  String? logo;
  String? name;
  String? nameCode;
  int? stateId;
  int? districtId;
  double? latitude;
  double? longitude;
  int? status;
  int? avgWaitingTime;

  MinesModel({
    this.id,
    this.isFav = 0,
    this.logo,
    this.name,
    this.nameCode,
    this.stateId,
    this.districtId,
    this.latitude,
    this.longitude,
    this.status,
    this.avgWaitingTime,
  });

  static Map<String, dynamic> toDB(dynamic json) {
    return {
      'id': json['id'],
      'isFav': json['is_fav'] == true ? 1 : 0,
      'logo': json['logo'],
      'name': json['name'],
      'nameCode': json['name_code'],
      'stateId': json['state_id'],
      'districtId': json['district_id'],
      'latitude': json['latitude'],
      'longitude': json['longitude'],
      'status': json['status'],
      'avgWaitingTime': json['avg_waiting_time'],
    };
  }

  static MinesModel fromDB(Map mines) {
    return MinesModel(
      id: mines['id'],
      isFav: mines['isFav'],
      logo: mines['logo'],
      name: mines['name'],
      nameCode: mines['nameCode'],
      stateId: mines['stateId'],
      districtId: mines['districtId'],
      latitude: mines['latitude'],
      longitude: mines['longitude'],
      status: mines['status'],
      avgWaitingTime: mines['avgWaitingTime'],
    );
  }
}

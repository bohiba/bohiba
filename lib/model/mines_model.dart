class MinesModel {
  int? id;
  int? isFav;
  String? uuid;
  String? logo;
  String? name;
  String? nameCode;
  String? website;
  String? type;
  String? status;
  String? state;
  String? district;
  double? latitude;
  double? longitude;
  int? avgWaitingTime;
  List<Minerals>? minerals;

  MinesModel({
    this.id,
    this.isFav = 0,
    this.logo,
    this.name,
    this.nameCode,
    this.state,
    this.district,
    this.latitude,
    this.longitude,
    this.status,
    this.avgWaitingTime,
  });

  static Map<String, dynamic> toDB(dynamic json) {
    return {
      'id': json['id'],
      'isFav': json['is_fav'] == true ? 1 : 0,
      'uuid': json['uuid'],
      'logo': json['logo'],
      'name': json['name'],
      'nameCode': json['name_code'],
      'website': json['website'],
      'type': json['type'],
      'status': json['status'],
      'state': json['state'],
      'district': json['district'],
      'latitude': json['latitude'],
      'longitude': json['longitude'],
      'avgWaitingTime': json['avg_waiting_time'],
      'minerals': json['minerals'] != null ? Minerals.toList(json['minerals']) : null,
    };
  }

  static MinesModel fromDB(Map mines) {
    return MinesModel(
      id: mines['id'],
      isFav: mines['isFav'],
      logo: mines['logo'],
      name: mines['name'],
      nameCode: mines['nameCode'],
      state: mines['state'],
      district: mines['district'],
      latitude: mines['latitude'],
      longitude: mines['longitude'],
      status: mines['status'],
      avgWaitingTime: mines['avgWaitingTime'],
    );
  }
}

class Minerals {
  int? id;
  String? name;
  String? nameCode;

  Minerals({this.id, this.name, this.nameCode});

  factory Minerals.fromJSON(Map json) {
    return Minerals(id: json['id'], name: json['name'], nameCode: json['name_code']);
  }

  static Minerals fromDB(Map json) {
    return Minerals(id: json['id'], name: json['name'], nameCode: json['nameCode']);
  }

  static Map<String, dynamic> toDB(dynamic json) {
    return {
      'id': json['id'],
      'name': json['name'],
      'nameCode': json['nameCode'],
    };
  }

  static List<Minerals> toList(List json) {
    return json.map((e) => Minerals.fromJSON(e)).toList();
  }
}

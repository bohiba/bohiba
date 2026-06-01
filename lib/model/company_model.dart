class CompanyModel {
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
  String? address;
  String? country;
  String? pinCode;

  double? latitude;
  double? longitude;
  String? mineralId;

  List<MineralModel>? minerals;

  factory CompanyModel.fromJSON(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      uuid: json['uuid'],
      logo: json['logo'],
      name: json['name'],
      nameCode: json['name_code'],
      website: json['website'],
      type: json['type']?.toString(),
      status: json['status']?.toString(),
      state: json['state'],
      district: json['district'],
      address: json['address'],
      country: json['country'],
      pinCode: json['pin_code'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      mineralId: json['mineral_id']?.toString(),
    );
  }

  CompanyModel({
    this.id,
    this.isFav = 0,
    this.uuid,
    this.logo,
    this.name,
    this.nameCode,
    this.website,
    this.type,
    this.status,
    this.state,
    this.district,
    this.address,
    this.country,
    this.pinCode,
    this.latitude,
    this.longitude,
    this.mineralId,
    this.minerals,
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
      'mineralId': json['mineral_id'],
      'address': json['address'],
      'country': json['country'],
      'pinCode': json['pin_code'],
    };
  }

  static CompanyModel fromDB(Map<String, dynamic> mines) {
    return CompanyModel(
      id: mines['id'],
      isFav: mines['isFav'],
      uuid: mines['uuid'],
      logo: mines['logo'],
      name: mines['name'],
      nameCode: mines['nameCode'],
      website: mines['website'],
      type: mines['type'],
      status: mines['status'],
      state: mines['state'],
      district: mines['district'],
      address: mines['address'],
      country: mines['country'],
      pinCode: mines['pinCode'],
      latitude: mines['latitude']?.toDouble(),
      longitude: mines['longitude']?.toDouble(),
      mineralId: mines['mineralId'],
    );
  }
}

class MineralModel {
  int? id;
  String? name;

  MineralModel({
    this.id,
    this.name,
  });

  factory MineralModel.fromJSON(Map json) {
    return MineralModel(id: json['id'], name: json['name']);
  }

  static MineralModel fromDB(Map json) {
    return MineralModel(id: json['id'], name: json['name']);
  }

  static Map<String, dynamic> toDB(dynamic json) {
    return {
      'id': json['id'],
      'name': json['name'],
    };
  }

  static List<MineralModel> toList(List json) {
    return json.map((e) => MineralModel.fromJSON(e)).toList();
  }
}

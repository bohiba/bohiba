// To parse this JSON data, do
//
//     final minesModel = minesModelFromJson(jsonString);

import 'dart:convert';

import '/model/user_fav_model.dart';
import '/services/db_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'mines_model.g.dart';

List<MinesModel> minesModelFromJson(String str) =>
    List<MinesModel>.from(json.decode(str).map((x) => MinesModel.fromJson(x)));

String minesModelToJson(List<MinesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: minesTypeID)
class MinesModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? logo;

  @HiveField(2)
  String? mineName;

  @HiveField(3)
  String? location;

  @HiveField(4)
  String? materialType;

  @HiveField(5)
  String? materialGrade;

  @HiveField(6)
  String? ownershipType;

  @HiveField(7)
  String? penaltyRisk;

  @HiveField(8)
  String? safetyGearMandate;

  @HiveField(9)
  String? shiftTiming;

  @HiveField(10)
  int? waitingPeriod;

  @HiveField(11)
  String? roadConditions;

  @HiveField(12)
  String? createdAt;

  @HiveField(13)
  String? updatedAt;

  @HiveField(14)
  bool? isFav;

  MinesModel({
    this.id,
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
    this.isFav = false,
    this.createdAt,
    this.updatedAt,
  });

  factory MinesModel.fromJson(Map<String, dynamic> json,
      {List<UserFavouriteModel>? favList}) {
    bool fav = favList?.any(
          (fav) => fav.assetType == "trucks" && fav.assetId == json["id"],
        ) ??
        false;
    return MinesModel(
      id: json["id"],
      isFav: fav,
      logo: json["logo"],
      mineName: json["mine_name"],
      location: json["location"],
      materialType: json["material_type"],
      materialGrade: json["material_grade"],
      ownershipType: json["ownership_type"],
      penaltyRisk: json["penalty_risk"],
      safetyGearMandate: json["safety_gear_mandate"],
      shiftTiming: json["shift_timing"],
      waitingPeriod: json["waiting_period"],
      roadConditions: json["road_conditions"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "mine_name": mineName,
        "location": location,
        "material_type": materialType,
        "material_grade": materialGrade,
        "ownership_type": ownershipType,
        "penalty_risk": penaltyRisk,
        "safety_gear_mandate": safetyGearMandate,
        "shift_timing": shiftTiming,
        "waiting_period": waitingPeriod,
        "road_conditions": roadConditions,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  static List<MinesModel> listFromJson(List<dynamic> jsonList,
      {List<UserFavouriteModel>? favList}) {
    final favIds = (favList ?? [])
        .where((fav) => fav.assetType == "trucks" && fav.assetId != null)
        .map((fav) => fav.assetId!)
        .toSet();
    return jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      final isFav = favIds.contains(map["id"]);
      return MinesModel.fromJson(map)..isFav = isFav;
    }).toList();
  }
}

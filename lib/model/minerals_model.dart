import 'dart:convert';

Minerals mineralsFromJson(String str) => Minerals.fromJson(json.decode(str));

String mineralsToJson(Minerals data) => json.encode(data.toJson());

class Minerals {
  List<Mineral>? minerals;

  Minerals({
    this.minerals,
  });

  factory Minerals.fromJson(Map<String, dynamic> json) => Minerals(
        minerals: json["minerals"] == null
            ? []
            : List<Mineral>.from(
                json["minerals"]!.map((x) => Mineral.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "minerals": minerals == null
            ? []
            : List<dynamic>.from(minerals!.map((x) => x.toJson())),
      };
}

class Mineral {
  int? id;
  String? name;

  Mineral({
    this.id,
    this.name,
  });

  factory Mineral.fromJson(Map<String, dynamic> json) => Mineral(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

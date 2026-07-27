// GET /api/locations — cached 24 h server-side; safe to hold in memory for the
// session because state/district data is static reference data.

class StateModel {
  final int id;
  final String name;
  final String? code;

  const StateModel({required this.id, required this.name, this.code});

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json['id'] as int,
        name: json['name'] as String,
        code: json['code'] as String?,
      );

  @override
  String toString() => name;
}

class DistrictModel {
  final int id;
  final int stateId;
  final String name;
  final String? code;

  const DistrictModel({
    required this.id,
    required this.stateId,
    required this.name,
    this.code,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        id: json['id'] as int,
        stateId: json['state_id'] as int,
        name: json['name'] as String,
        code: json['code'] as String?,
      );

  @override
  String toString() => name;
}

class LocationData {
  final List<StateModel> states;
  final List<DistrictModel> districts;

  const LocationData({required this.states, required this.districts});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    final stateList = (json['state'] as List? ?? [])
        .map((e) => StateModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final districtList = (json['district'] as List? ?? [])
        .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return LocationData(states: stateList, districts: districtList);
  }

  // Returns districts that belong to a given state.
  List<DistrictModel> districtsForState(int stateId) =>
      districts.where((d) => d.stateId == stateId).toList();

  StateModel? stateById(int id) =>
      states.cast<StateModel?>().firstWhere((s) => s?.id == id,
          orElse: () => null);

  DistrictModel? districtById(int id) =>
      districts.cast<DistrictModel?>().firstWhere((d) => d?.id == id,
          orElse: () => null);
}

class TripReportFilter {
  final int? transportId;
  final int? mineId;
  final int? plantId;
  final String? fromDate;
  final String? toDate;

  const TripReportFilter({
    this.transportId,
    this.mineId,
    this.plantId,
    this.fromDate,
    this.toDate,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'transporter_id': transportId,
      'origin_id': mineId,
      'destination_id': plantId,
      'start_date': fromDate,
      'end_date': toDate,
    };

    map.removeWhere((key, value) => value == null);
    return map;
  }

  bool get hasAnyFilter =>
      transportId != null ||
      mineId != null ||
      plantId != null ||
      fromDate != null ||
      toDate != null;

  int get activeCount => [transportId, mineId, plantId, fromDate, toDate]
      .where((v) => v != null)
      .length;
}

class TripReportModel {
  int? id;
  String? tripCode;
  String? regdNumber;
  String? date;
  String? transporter;
  String? origin;
  String? destination;
  double? loadWeight;
  double? shortWeight;
  double? netWeight;
  double? rate;
  int? tripStatus;

  TripReportModel({
    this.id,
    this.tripCode,
    this.regdNumber,
    this.date,
    this.transporter,
    this.origin,
    this.destination,
    this.loadWeight,
    this.shortWeight,
    this.netWeight,
    this.rate,
    this.tripStatus,
  });

  factory TripReportModel.fromJson(Map<String, dynamic> json) {
    return TripReportModel(
      id: json['id'],
      tripCode: json['trip_code'],
      regdNumber: json['regd_number'],
      date: json['date'],
      transporter: json['transporter'],
      origin: json['origin'],
      destination: json['destination'],
      loadWeight: (json['load_weight'] as num?)?.toDouble(),
      shortWeight: (json['short_weight'] as num?)?.toDouble(),
      netWeight: (json['net_weight'] as num?)?.toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      tripStatus: json['trip_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_code': tripCode,
      'regd_number': regdNumber,
      'date': date,
      'transporter': transporter,
      'origin': origin,
      'destination': destination,
      'load_weight': loadWeight,
      'short_weight': shortWeight,
      'net_weight': netWeight,
      'rate': rate,
      'trip_status': tripStatus,
    };
  }

  static List<TripReportModel> fromList(List<dynamic> list) {
    return list
        .map((e) => TripReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

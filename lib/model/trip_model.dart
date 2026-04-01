import 'package:intl/intl.dart';

class TripModel {
  int? id;
  int? isFav;
  String? tripCode;
  int? tripStatus;
  TripLocation? origin;
  TripLocation? destination;
  String? startDate;
  String? endedDate;
  int? transporterId;

  LoadDetail? loadDetail;
  TripFinance? finance;
  TripTruck? truck;
  TripDriver? driver;
  TripOwner? owner;

  List<Reassignment>? reassignment;
  List<TripExpense>? expenses;
  List<TripPayment>? payments;
  List<TripDocument>? documents;

  String? createdAt;
  String? updatedAt;

  TripModel({
    this.id,
    this.isFav,
    this.tripCode,
    this.tripStatus,
    this.origin,
    this.destination,
    this.startDate,
    this.endedDate,
    this.transporterId,
    this.loadDetail,
    this.finance,
    this.truck,
    this.driver,
    this.owner,
    this.reassignment,
    this.expenses,
    this.payments,
    this.documents,
    this.createdAt,
    this.updatedAt,
  });

  // ================== FROM API ==================
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json["id"],
      isFav: json["is_fav"] ?? 0,
      tripCode: json["trip_code"],
      tripStatus: json["trip_status"],
      origin: json["origin"] != null ? TripLocation.fromJson(json["origin"]) : null,
      destination: json["destination"] != null ? TripLocation.fromJson(json["destination"]) : null,
      startDate: _parseDate(json["started_at"]),
      endedDate: _parseDate(json["ended_at"]),
      transporterId: json["transporter_id"],
      loadDetail: json["load_detail"] != null ? LoadDetail.fromJson(json["load_detail"]) : null,
      finance: json["finance"] != null ? TripFinance.fromJson(json["finance"]) : null,
      truck: json["truck"] != null ? TripTruck.fromJson(json["truck"]) : null,
      driver: json["driver"] != null ? TripDriver.fromJson(json["driver"]) : null,
      reassignment: (json["reassignment"] as List? ?? []).map((e) => Reassignment.fromJson(e)).toList(),
      expenses: (json["expenses"] as List? ?? []).map((e) => TripExpense.fromJson(e)).toList(),
      payments: (json["payments"] as List? ?? []).map((e) => TripPayment.fromJson(e)).toList(),
      documents: (json["documents"] as List? ?? []).map((e) => TripDocument.fromJson(e)).toList(),
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  // ================== TO DB ==================
  static Map<String, dynamic> toDB(Map<dynamic, dynamic> json) {
    final load = json["load_detail"];
    final finance = json["finance"];
    final truck = json["truck"];
    final driver = json["driver"];
    final owner = json["owner"];

    return {
      'id': json['id'],
      'isFav': json['is_fav'] ?? 0,
      'tripCode': json['trip_code'],
      'tripStatus': json['trip_status'],
      'originId': json['origin']?['id'],
      'originName': json['origin']?['name'],
      'originNameCode': json['origin']?['name_code'],
      'originLat': json['origin']?['latitude'],
      'originLng': json['origin']?['longitude'],
      'originStatus': json['origin']?['status'],
      'originType': json['origin']?['type'],
      'destination': json['destination'],
      'destinationId': json['destination']?['id'],
      'destinationName': json['destination']?['name'],
      'destinationNameCode': json['destination']?['name_code'],
      'destinationLat': json['destination']?['latitude'],
      'destinationLng': json['destination']?['longitude'],
      'destinationStatus': json['destination']?['status'],
      'destinationType': json['destination']?['type'],
      'startedAt': _parseDate(json["started_at"]),
      'endedAt': _parseDate(json["ended_at"]),
      'transporterId': json['transporter_id'],

      // Load
      'materialType': load?['material_type'],
      'loadWeight': (load?['load_weight'] ?? 0).toDouble(),
      'shortWeight': (load?['short_weight'] ?? 0).toDouble(),
      'rate': (load?['rate'] ?? 0).toDouble(),

      // Finance
      'fnId': finance?['id'],
      'fnAmount': (finance?['amount'] ?? 0).toDouble(),
      'fnPayment': (finance?['trip_payment'] ?? 0).toDouble(),
      'fnExpense': (finance?['trip_expense'] ?? 0).toDouble(),
      'fnProfit': (finance?['trip_profit'] ?? 0).toDouble(),

      // Truck
      'vhId': truck?['id'],
      'vhNumber': truck?['regd_number'],
      'vhModel': truck?['model'],
      'vhDesc': truck?['rc_vh_class_desc'],

      // Driver
      'dvId': driver?['id'],
      'dvUuid': driver?['uuid'],
      'dvName': driver?['name'],
      'dvMobile': driver?['mobile'],

      // Owner
      'ownerId': owner?['id'],
      'ownerUuid': owner?['uuid'],
      'ownerName': owner?['name'],
      'ownerMobile': owner?['mobile'],
    };
  }

  // ================== FROM DB ==================
  factory TripModel.fromDb(Map<String, dynamic> map) {
    return TripModel(
      id: map["id"],
      isFav: map["isFav"],
      tripCode: map["tripCode"],
      tripStatus: map["tripStatus"],
      origin: TripLocation.originFromDb(map),
      destination: TripLocation.destinationFromDb(map),
      startDate: map["startedAt"],
      endedDate: map["endedAt"],
      transporterId: map["transporterId"],
      loadDetail: LoadDetail.fromDb(map),
      finance: TripFinance.fromDb(map),
      truck: TripTruck.fromDb(map),
      driver: map["dvId"] != null ? TripDriver.fromDb(map) : null,
      owner: map["ownerId"] != null ? TripOwner.fromDb(map) : null,
    );
  }

  // ================== HELPERS ==================
  static String? _parseDate(String? date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date).toString();
    } catch (e) {
      try {
        return DateFormat("yyyy-MM-dd HH:mm:ss a").parse(date).toString();
      } catch (e) {
        return null;
      }
    }
  }

  static String? jsonEncodeSafe(dynamic data) {
    if (data == null) return null;
    return data.toString();
  }

  static Map<String, dynamic>? jsonDecodeSafe(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) return data;
    return null;
  }
}

class TripLocation {
  int? id;
  String? name;
  String? nameCode;
  int? type;
  double? latitude;
  double? longitude;
  int? status;

  TripLocation({
    this.id,
    this.name,
    this.nameCode,
    this.type,
    this.latitude,
    this.longitude,
    this.status,
  });

  // FROM API
  factory TripLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TripLocation();

    return TripLocation(
      id: json["id"],
      name: json["name"],
      nameCode: json["name_code"],
      type: json["type"],
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      status: json["status"],
    );
  }

  // FROM DB
  factory TripLocation.originFromDb(Map<String, dynamic>? map) {
    if (map == null) return TripLocation();

    return TripLocation(
      id: map["originId"],
      name: map["originName"],
      nameCode: map["originNameCode"],
      type: map["originType"],
      latitude: (map["originLat"] ?? 0).toDouble(),
      longitude: (map["originLng"] ?? 0).toDouble(),
      status: map["originStatus"],
    );
  }

  factory TripLocation.destinationFromDb(Map<String, dynamic>? map) {
    if (map == null) return TripLocation();

    return TripLocation(
      id: map["destinationId"],
      name: map["destinationName"],
      nameCode: map["destinationNameCode"],
      type: map["destinationType"],
      latitude: (map["destinationLat"] ?? 0).toDouble(),
      longitude: (map["destinationLng"] ?? 0).toDouble(),
      status: map["destinationStatus"],
    );
  }

  // TO DB (store as JSON string or map)
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_code": nameCode,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
      };
}

class LoadDetail {
  String? materialType;
  double? loadWeight;
  double? shortWeight;
  double? rate;

  LoadDetail({
    this.materialType,
    this.loadWeight,
    this.shortWeight,
    this.rate,
  });

  factory LoadDetail.fromJson(Map<String, dynamic> json) {
    return LoadDetail(
      materialType: json["material_type"]?.toString(),
      loadWeight: (json["load_weight"] ?? 0).toDouble(),
      shortWeight: (json["short_weight"] ?? 0).toDouble(),
      rate: (json["rate"] ?? 0).toDouble(),
    );
  }

  factory LoadDetail.fromDb(Map<String, dynamic> map) {
    return LoadDetail(
      materialType: map["materialType"],
      loadWeight: (map["loadWeight"] ?? 0).toDouble(),
      shortWeight: (map["shortWeight"] ?? 0).toDouble(),
      rate: (map["rate"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "material_type": materialType,
        "load_weight": loadWeight,
        "short_weight": shortWeight,
        "rate": rate,
      };
}

class TripFinance {
  int? id;
  double? amount;
  double? tripPayment;
  double? tripExpense;
  double? tripProfit;

  TripFinance({
    this.id,
    this.amount,
    this.tripPayment,
    this.tripExpense,
    this.tripProfit,
  });

  factory TripFinance.fromJson(Map<String, dynamic> json) {
    return TripFinance(
      id: json["id"],
      amount: (json["amount"] ?? 0).toDouble(),
      tripPayment: (json["trip_payment"] ?? 0).toDouble(),
      tripExpense: (json["trip_expense"] ?? 0).toDouble(),
      tripProfit: (json["trip_profit"] ?? 0).toDouble(),
    );
  }

  factory TripFinance.fromDb(Map<String, dynamic> map) {
    return TripFinance(
      id: map["fnId"],
      amount: (map["fnAmount"] ?? 0).toDouble(),
      tripPayment: (map["fnPayment"] ?? 0).toDouble(),
      tripExpense: (map["fnExpense"] ?? 0).toDouble(),
      tripProfit: (map["fnProfit"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "trip_payment": tripPayment,
        "trip_expense": tripExpense,
        "trip_profit": tripProfit,
      };
}

class TripTruck {
  int? id;
  String? regdNumber;
  String? model;
  String? rcVhClassDesc;

  TripTruck({
    this.id,
    this.regdNumber,
    this.model,
    this.rcVhClassDesc,
  });

  factory TripTruck.fromJson(Map<String, dynamic> json) {
    return TripTruck(
      id: json["id"],
      regdNumber: json["regd_number"],
      model: json["model"],
      rcVhClassDesc: json["rc_vh_class_desc"],
    );
  }

  factory TripTruck.fromDb(Map<String, dynamic> map) {
    return TripTruck(
      id: map["vhId"],
      regdNumber: map["vhNumber"],
      model: map["vhModel"],
      rcVhClassDesc: map["vhDesc"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "regd_number": regdNumber,
        "model": model,
        "rc_vh_class_desc": rcVhClassDesc,
      };
}

class TripDriver {
  int? id;
  String? uuid;
  String? name;
  String? mobile;

  TripDriver({
    this.id,
    this.uuid,
    this.name,
    this.mobile,
  });

  factory TripDriver.fromJson(Map<String, dynamic> json) {
    return TripDriver(
      id: json["id"],
      uuid: json["uuid"],
      name: json["name"],
      mobile: json["mobile"],
    );
  }

  factory TripDriver.fromDb(Map<String, dynamic> map) {
    return TripDriver(
      id: map["dvId"],
      uuid: map["dvUuid"],
      name: map["dvName"],
      mobile: map["dvMobile"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "mobile": mobile,
      };
}

class TripOwner {
  int? id;
  String? uuid;
  String? name;
  String? mobile;

  TripOwner({
    this.id,
    this.uuid,
    this.name,
    this.mobile,
  });

  factory TripOwner.fromJson(Map<String, dynamic> json) {
    return TripOwner(
      id: json["id"],
      uuid: json["uuid"],
      name: json["name"],
      mobile: json["mobile"],
    );
  }

  factory TripOwner.fromDb(Map<String, dynamic> map) {
    return TripOwner(
      id: map["ownerId"],
      uuid: map["ownerUuid"],
      name: map["ownerName"],
      mobile: map["ownerMobile"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "mobile": mobile,
      };
}

class Reassignment {
  int? id;
  int? tripId;
  String? regdNumber;
  String? reason;
  String? date;
  String? reassignVehicle;

  Reassignment({
    this.id,
    this.tripId,
    this.regdNumber,
    this.reason,
    this.date,
    this.reassignVehicle,
  });

  factory Reassignment.fromJson(Map<String, dynamic> json) {
    return Reassignment(
      id: json["id"],
      tripId: json["trip_id"],
      regdNumber: json["regd_number"],
      reason: json["reason"],
      date: _parseDate(json["reassigned_at"]),
      reassignVehicle: json["truck_regd_number"],
    );
  }

  factory Reassignment.fromDb(Map<String, dynamic> map) {
    return Reassignment(
      id: map["id"],
      tripId: map["tripId"],
      regdNumber: map["vhNumber"],
      reason: map["reason"],
      date: map["reassignmentAt"],
      reassignVehicle: map["reAssignVhNumber"],
    );
  }

  static Map<String, dynamic> toDB(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'tripId': json['trip_id'],
      'vhNumber': json["regd_number"],
      'reassignmentAt': _parseDate(json["reassigned_at"]),
      'reAssignVhNumber': json['truck_regd_number'],
      'reason': json["reason"],
    };
  }
}

class TripExpense {
  int? id;
  int? tripId;
  String? expenseType;
  String? addedByUuid;
  String? paymentMode;
  double? paid;
  String? paidTo;
  String? expenseDate;
  String? remarks;

  TripExpense({
    this.id,
    this.tripId,
    this.expenseType,
    this.addedByUuid,
    this.paymentMode,
    this.paid,
    this.paidTo,
    this.expenseDate,
    this.remarks,
  });

  factory TripExpense.fromJson(Map<String, dynamic> json) {
    return TripExpense(
      id: json["id"],
      tripId: json["trip_id"],
      expenseType: json["expense_type"],
      addedByUuid: json["added_by_uuid"],
      paymentMode: json["payment_mode"],
      paid: (json["paid"] ?? 0).toDouble(),
      paidTo: json["paid_to"],
      expenseDate: _parseDate(json["expense_date"]),
      remarks: json["remarks"],
    );
  }

  factory TripExpense.fromDb(Map<String, dynamic> map) {
    return TripExpense(
      id: map["id"],
      tripId: map["tripId"],
      expenseType: map["expenseType"],
      addedByUuid: map["addedByUuid"],
      paymentMode: map["paymentMode"],
      paid: (map["paid"] ?? 0).toDouble(),
      paidTo: map["paidTo"],
      expenseDate: map["expenseDate"],
      remarks: map["remarks"],
    );
  }

  static Map<String, dynamic> toDB(Map json) {
    return {
      'id': json['id'],
      'tripId': json['trip_id'],
      'expenseType': json['expense_type'],
      'paymentMode': json['payment_mode'],
      'paid': json['paid']?.toDouble() ?? 0.0,
      'paidTo': json['paid_to'],
      'expenseDate': json['expense_date'],
      'remarks': json['remarks'],
    };
  }
}

class TripPayment {
  int? id;
  int? tripId;
  String? paymentType;
  String? paymentMode;
  double? amount;
  String? paidBy;
  String? receivedBy;
  String? paymentTime;

  TripPayment({
    this.id,
    this.tripId,
    this.paymentType,
    this.paymentMode,
    this.amount,
    this.paidBy,
    this.receivedBy,
    this.paymentTime,
  });

  factory TripPayment.fromJson(Map<String, dynamic> json) {
    return TripPayment(
      id: json["id"],
      tripId: json["trip_id"],
      paymentType: json["payer_type"],
      paymentMode: json["payment_mode"],
      amount: (json["amount"] ?? 0).toDouble(),
      paidBy: json["paid_by"],
      receivedBy: json["received_by"],
      paymentTime: _parseDate(json["payment_time"]),
    );
  }

  factory TripPayment.fromDb(Map<String, dynamic> map) {
    return TripPayment(
      id: map["id"],
      tripId: map["tripId"],
      paymentType: map["payerType"],
      paymentMode: map["paymentMode"],
      amount: (map["amount"] ?? 0).toDouble(),
      paidBy: map["paidBy"],
      receivedBy: map["receivedBy"],
      paymentTime: map["paymentTime"],
    );
  }

  static Map<String, dynamic> toDB(dynamic db) {
    return {
      "id": db['id'],
      "tripId": db["trip_id"],
      "payerType": db["payer_type"],
      "payementMode": db["payment_mode"],
      "amount": double.parse(db["amount"]?.toString() ?? "0.0"),
      "paidBy": db["paid_by"],
      "receivedBy": db["received_by"],
      "paymentTime": db["payment_time"],
    };
  }
}

class TripDocument {
  int? id;
  int? tripId;
  String? docType;
  String? image;
  String? uploadedBy;
  String? updatedAt;

  TripDocument({
    this.id,
    this.tripId,
    this.docType,
    this.image,
    this.uploadedBy,
    this.updatedAt,
  });

  factory TripDocument.fromJson(Map<String, dynamic> json) {
    return TripDocument(
      id: json["id"],
      tripId: json["trip_id"],
      docType: json["doc_type"],
      image: json["doc_image"], // ✅ FIXED
      uploadedBy: json["uploaded_by_uuid"],
      updatedAt: json["updated_at"],
    );
  }

  factory TripDocument.fromDb(Map<String, dynamic> map) {
    return TripDocument(
      id: map["id"],
      tripId: map["tripId"],
      docType: map["docType"],
      image: map["image"],
      uploadedBy: map["uploadedBy"],
      updatedAt: map["uploadedAt"],
    );
  }
  static Map<String, dynamic> toDB(dynamic json) {
    return {
      "id": json["id"],
      "tripId": json["trip_id"],
      "docType": json["doc_type"],
      "image": json["doc_image"],
      "uploadedBy": json["uploaded_by_uuid"],
      "uploadedAt": json["updated_at"],
    };
  }
}

String? _parseDate(String? date) {
  if (date == null) return null;
  try {
    return DateTime.parse(date).toString();
  } catch (_) {
    return null;
  }
}

import 'package:intl/intl.dart';

class TripModel {
  int? id;
  int? isFav;
  String? tripCode;
  String? tripStatus;
  String? origin;
  String? destination;
  String? startDate;
  String? endedDate;
  String? transporter;
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
    this.transporter,
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

  factory TripModel.fromDb(Map<String, dynamic> mapObj) {
    return TripModel(
      id: mapObj["id"],
      isFav: mapObj["isFav"],
      tripCode: mapObj["tripCode"],
      tripStatus: mapObj["tripStatus"],
      origin: mapObj["origin"],
      destination: mapObj["destination"],
      startDate: mapObj["startedAt"],
      endedDate: mapObj["endedAt"],
      transporter: mapObj['transporter'],
      loadDetail: LoadDetail.fromDb(mapObj),
      finance: TripFinance.fromDb(mapObj),
      truck: TripTruck.fromDb(mapObj),
      driver: TripDriver.fromDb(mapObj),
      owner: TripOwner.fromDb(mapObj),
    );
  }

  static Map<String, dynamic> toDB(dynamic json) {
    Map<String, dynamic>? loadInfo = json["load_detail"];
    Map<String, dynamic>? financeInfo = json["finance"];
    Map<String, dynamic>? truckInfo = json["truck"];
    Map<String, dynamic>? driverInfo = json['driver'];
    Map<String, dynamic>? ownerInfo = json['owner'];
    DateTime startedDate = DateFormat("dd-MM-yyyy").parse(json["started_at"]);
    String strStartedDate = DateFormat("yyyy-MM-dd").format(startedDate);

    DateTime endDated = DateFormat("dd-MM-yyyy").parse(json["ended_at"]);
    String strEndedDate = DateFormat("yyyy-MM-dd").format(endDated);

    return {
      'id': json['id'],
      'isFav': json['is_fav'] ?? 0,
      'tripCode': json['trip_code'],
      'tripStatus': json['trip_status'],
      'origin': json['origin'],
      'destination': json['destination'],
      'startedAt': strStartedDate,
      'endedAt': strEndedDate,
      'transporter': json['transporter'],
      'materialType': loadInfo == null ? null : loadInfo['material_type'],
      'loadWeight': loadInfo == null ? null : loadInfo['load_weight'],
      'shortWeight': loadInfo == null ? null : loadInfo['short_weight'],
      'rate': loadInfo == null ? null : loadInfo['rate'],
      'fnId': financeInfo == null ? null : financeInfo['id'],
      'fnAmount': financeInfo == null ? null : financeInfo['amount'],
      'fnPayment': financeInfo == null ? null : financeInfo['trip_payment'],
      'fnExpense': financeInfo == null ? null : financeInfo['trip_profit'],
      'fnProfit': financeInfo == null ? null : financeInfo['trip_expense'],
      'vhId': truckInfo == null ? null : truckInfo['id'],
      'vhNumber': truckInfo == null ? null : truckInfo['regd_number'],
      'vhModel': truckInfo == null ? null : truckInfo['model'],
      'vhDesc': truckInfo == null ? null : truckInfo['rc_vh_class_desc'],
      'dvId': driverInfo == null ? null : driverInfo['id'],
      'dvUuid': driverInfo == null ? null : driverInfo['uuid'],
      'dvName': driverInfo == null ? null : driverInfo['name'],
      'dvMobile': driverInfo == null ? null : driverInfo['mobile'],
      'ownerId': ownerInfo == null ? null : ownerInfo['id'],
      'ownerImage': ownerInfo == null ? null : ownerInfo['image'],
      'ownerUuid': ownerInfo == null ? null : ownerInfo['uuid'],
      'ownerName': ownerInfo == null ? null : ownerInfo['name'],
      'ownerMobileNumber': ownerInfo == null ? null : ownerInfo['mobile'],
    };
  }
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

  factory LoadDetail.fromJson(Map<String, dynamic> json) => LoadDetail(
        materialType: json["material_type"],
        loadWeight: json["load_weight"]?.toDouble() ?? 0.0,
        shortWeight: json["short_weight"]?.toDouble() ?? 0.0,
        rate: json["rate"]?.toDouble() ?? 0.0,
      );

  factory LoadDetail.fromDb(Map<String, dynamic> map) {
    return LoadDetail(
      materialType: map["materialType"],
      loadWeight: map["loadWeight"]?.toDouble() ?? 0.0,
      shortWeight: map["shortWeight"]?.toDouble() ?? 0.0,
      rate: map["rate"]?.toDouble() ?? 0.0,
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

  factory TripFinance.fromJson(Map<String, dynamic> json) => TripFinance(
        id: json["id"],
        amount: json["amount"]?.toDouble(),
        tripPayment: json["trip_payment"]?.toDouble(),
        tripExpense: json["trip_expense"]?.toDouble(),
        tripProfit: json["trip_profit"]?.toDouble(),
      );

  factory TripFinance.fromDb(Map<String, dynamic> map) {
    return TripFinance(
      id: map["fnId"],
      amount: map["fnAmount"]?.toDouble() ?? 0.0,
      tripPayment: map["fnPayment"]?.toDouble() ?? 0.0,
      tripExpense: map["fnExpense"]?.toDouble() ?? 0.0,
      tripProfit: map["fnProfit"]?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount?.toDouble(),
        "trip_payment": tripPayment?.toDouble(),
        "trip_expense": tripExpense?.toDouble(),
        "trip_profit": tripProfit?.toDouble(),
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

  factory TripTruck.fromJson(Map<String, dynamic> json) => TripTruck(
        id: json["id"],
        regdNumber: json["regd_number"],
        model: json["model"],
        rcVhClassDesc: json["rc_vh_class_desc"],
      );

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

  factory TripDriver.fromJson(Map<String, dynamic> json) => TripDriver(
        id: json['id'],
        uuid: json["uuid"],
        name: json["name"],
        mobile: json["mobile"],
      );

  factory TripDriver.fromDb(Map<String, dynamic> map) => TripDriver(
        id: map['dvId'],
        uuid: map["dvUuid"],
        name: map["dvName"],
        mobile: map["dvMobile"],
      );

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

  factory TripOwner.fromJson(Map<String, dynamic> json) => TripOwner(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        mobile: json["mobile"],
      );

  factory TripOwner.fromDb(Map<String, dynamic> map) {
    return TripOwner(
      id: map["ownerId"],
      uuid: map["ownerUuid"],
      name: map["ownerName"],
      mobile: map["ownerMobileNumber"],
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
    DateTime reassignDate = DateFormat("dd-MM-yyyy").parse(json["reassigned_at"]);
    String strReassignDate = DateFormat("yyyy-MM-dd").format(reassignDate);
    return Reassignment(
      id: json['id'],
      tripId: json['trip_id'],
      regdNumber: json["regd_number"],
      reason: json["reason"],
      date: strReassignDate,
      reassignVehicle: json['truck_regd_number'],
    );
  }

  factory Reassignment.fromDb(Map<String, dynamic> map) {
    return Reassignment(
      id: map['id'],
      tripId: map['tripId'],
      regdNumber: map["vhNumber"],
      reason: map["reason"],
      date: map["reassignmentAt"],
      reassignVehicle: map['reAssignVhNumber'],
    );
  }

  static Map<String, dynamic> toDB(dynamic json) {
    return {
      'id': json['id'],
      'tripId': json['trip_id'],
      'vhNumber': json["regd_number"],
      'reassignmentAt': json["reassigned_at"],
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
    DateTime expenseDate = DateFormat("dd-MM-yyyy").parse(json["expense_date"]);
    String strExpenseDate = DateFormat("yyyy-MM-dd").format(expenseDate);
    return TripExpense(
      id: json["id"],
      tripId: json["trip_id"],
      expenseType: json["expense_type"],
      addedByUuid: json["added_by_uuid"],
      paymentMode: json["payment_mode"],
      paid: json["paid"]?.toDouble() ?? 0.0,
      paidTo: json["paid_to"],
      expenseDate: strExpenseDate,
      remarks: json["remarks"],
    );
  }

  factory TripExpense.fromDb(Map<String, dynamic> map) {
    return TripExpense(
      id: map["id"],
      tripId: map["tripId"],
      expenseType: map["expenseType"],
      addedByUuid: map["added_by_uuid"],
      paymentMode: map["paymentMode"],
      paid: map["paid"].toDouble() ?? 0.0,
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
    DateTime paymentDate = DateFormat("dd-MM-yyyy").parse(json["payment_time"]);
    String strPaymentDate = DateFormat("yyyy-MM-dd").format(paymentDate);
    return TripPayment(
      id: json["id"],
      tripId: json["trip_id"],
      paymentType: json["payer_type"],
      paymentMode: json["payment_mode"],
      amount: json["amount"].toDouble(),
      paidBy: json["paid_by"],
      receivedBy: json["received_by"],
      paymentTime: strPaymentDate,
    );
  }

  factory TripPayment.fromDb(Map<String, dynamic> map) {
    return TripPayment(
      id: map["id"],
      tripId: map["tripId"],
      paymentType: map["payerType"],
      paymentMode: map["payementMode"],
      amount: double.parse(map["amount"].toString()),
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

  /// FROM API to TRIP MODEL
  factory TripDocument.fromJson(Map<String, dynamic> json) => TripDocument(
        id: json["id"],
        tripId: json["trip_id"],
        docType: json["doc_type"],
        image: json["image"],
        uploadedBy: json['uploaded_by_uuid'],
        updatedAt: json["updated_at"],
      );

  // FROM DB to TRIP MODEL
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
    return {"id": json["id"], "tripId": json["trip_id"], "docType": json["doc_type"], "image": json["doc_image"], "uploadedBy": json["uploaded_by_uuid"], "uploadedAt": json["updated_at"]};
  }
}

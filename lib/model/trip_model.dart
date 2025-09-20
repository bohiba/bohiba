import '/model/user_fav_model.dart';
import '/services/db_service.dart';
import 'package:hive/hive.dart';

part 'trip_model.g.dart';

@HiveType(typeId: tripTypeID)
class TripModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? tripCode;

  @HiveField(2)
  String? tripStatus;

  @HiveField(3)
  String? origin;

  @HiveField(4)
  String? destination;

  @HiveField(5)
  String? startDate;

  @HiveField(6)
  String? endedDate;

  @HiveField(7)
  LoadDetail? loadDetail;

  @HiveField(8)
  TripFinance? finance;

  @HiveField(9)
  TripTruck? truck;

  @HiveField(10)
  TripDriver? driver;

  @HiveField(11)
  TripOwner? owner;

  @HiveField(12)
  List<Reassignment>? reassignment;

  @HiveField(13)
  List<TripExpense>? expenses;

  @HiveField(14)
  List<TripPayment>? payments;

  @HiveField(15)
  List<TripDocument>? documents;

  @HiveField(16)
  String? createdAt;

  @HiveField(17)
  String? updatedAt;

  @HiveField(18)
  bool? isFav;

  TripModel({
    this.id,
    this.tripCode,
    this.tripStatus,
    this.origin,
    this.destination,
    this.startDate,
    this.endedDate,
    this.loadDetail,
    this.finance,
    this.truck,
    this.driver,
    this.owner,
    this.reassignment,
    this.expenses,
    this.payments,
    this.documents,
    this.isFav = false,
    this.createdAt,
    this.updatedAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json,
      {List<UserFavouriteModel>? favList}) {
    bool fav = favList?.any(
          (fav) => fav.assetType == "trips" && fav.assetId == json["id"],
        ) ??
        false;
    return TripModel(
      id: json["id"],
      isFav: fav,
      tripCode: json["trip_code"],
      tripStatus: json["trip_status"],
      origin: json["origin"],
      destination: json["destination"],
      startDate: json["started_at"],
      endedDate: json["ended_at"],
      loadDetail: json["load_detail"] == null
          ? null
          : LoadDetail.fromJson(json["load_detail"]),
      finance: json["finance"] == null
          ? null
          : TripFinance.fromJson(json["finance"]),
      truck: json["truck"] == null ? null : TripTruck.fromJson(json["truck"]),
      driver:
          json["driver"] == null ? null : TripDriver.fromJson(json["driver"]),
      owner: json["owner"] == null ? null : TripOwner.fromJson(json["owner"]),
      reassignment: json["reassignment"] == null
          ? []
          : List<Reassignment>.from(
              json["reassignment"].map((x) => Reassignment.fromJson(x))),
      expenses: json["expenses"] == null
          ? []
          : List<TripExpense>.from(
              json["expenses"].map((x) => TripExpense.fromJson(x))),
      payments: json["payments"] == null
          ? []
          : (List<TripPayment>.from(
              json["payments"].map((x) => TripPayment.fromJson(x)),
            )..sort((a, b) {
              final dateA =
                  DateTime.tryParse(a.paymentTime ?? '') ?? DateTime(0);
              final dateB =
                  DateTime.tryParse(b.paymentTime ?? '') ?? DateTime(0);
              return dateB.compareTo(dateA);
            })),
      // payments: json["payments"] == null
      //     ? []
      //     : List<TripPayment>.from(
      //         json["payments"].map((x) => TripPayment.fromJson(x))),
      documents: json["documents"] == null
          ? []
          : List<TripDocument>.from(
              json["documents"].map((x) => TripDocument.fromJson(x))),
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "trip_code": tripCode,
        "trip_status": tripStatus,
        "origin": origin,
        "destination": destination,
        "started_at": startDate,
        "ended_at": endedDate,
        "load_detail": loadDetail?.toJson(),
        "finance": finance?.toJson(),
        "truck": truck?.toJson(),
        "driver": driver?.toJson(),
        "owner": owner?.toJson(),
        "reassignment":
            List<dynamic>.from(reassignment?.map((x) => x.toJson()) ?? []),
        "expenses": List<dynamic>.from(expenses?.map((x) => x.toJson()) ?? []),
        "payments": List<dynamic>.from(payments?.map((x) => x.toJson()) ?? []),
        "documents":
            List<dynamic>.from(documents?.map((x) => x.toJson()) ?? []),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  static List<TripModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      return TripModel.fromJson(map);
    }).toList();
  }
}

@HiveType(typeId: tripLoadDetailTypeID)
class LoadDetail {
  @HiveField(0)
  String? materialType;

  @HiveField(1)
  double? loadWeight;

  @HiveField(2)
  double? shortWeight;

  @HiveField(3)
  double? rate;

  LoadDetail({
    this.materialType,
    this.loadWeight,
    this.shortWeight,
    this.rate,
  });

  factory LoadDetail.fromJson(Map<String, dynamic> json) => LoadDetail(
        materialType: json["material_type"],
        loadWeight: json["load_weight"]?.toDouble(),
        shortWeight: json["short_weight"]?.toDouble(),
        rate: json["rate"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "material_type": materialType,
        "load_weight": loadWeight,
        "short_weight": shortWeight,
        "rate": rate,
      };
}

@HiveType(typeId: tripFinanceTypeID)
class TripFinance {
  @HiveField(0)
  int? id;

  @HiveField(1)
  double? amount;

  @HiveField(2)
  double? tripPayment;

  @HiveField(3)
  double? tripExpense;

  @HiveField(4)
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount?.toDouble(),
        "trip_payment": tripPayment?.toDouble(),
        "trip_expense": tripExpense?.toDouble(),
        "trip_profit": tripProfit?.toDouble(),
      };
}

@HiveType(typeId: tripTruckTypeID)
class TripTruck {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? regdNumber;

  @HiveField(2)
  String? model;

  @HiveField(3)
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "regd_number": regdNumber,
        "model": model,
        "rc_vh_class_desc": rcVhClassDesc,
      };
}

@HiveType(typeId: tripDriverTypeID)
class TripDriver {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? mobile;

  @HiveField(4)
  String? email;

  TripDriver({
    this.id,
    this.uuid,
    this.name,
    this.mobile,
    this.email,
  });

  factory TripDriver.fromJson(Map<String, dynamic> json) => TripDriver(
        id: json['id'],
        uuid: json["uuid"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "mobile": mobile,
        "email": email,
      };
}

@HiveType(typeId: tripOwnerTypeID)
class TripOwner {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? mobile;

  @HiveField(4)
  String? email;

  TripOwner({
    this.id,
    this.uuid,
    this.name,
    this.mobile,
    this.email,
  });

  factory TripOwner.fromJson(Map<String, dynamic> json) => TripOwner(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
        "mobile": mobile,
        "email": email,
      };
}

@HiveType(typeId: reassignmentTypeID)
class Reassignment {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? regdNumber;

  @HiveField(2)
  String? reason;

  @HiveField(3)
  String? date;

  Reassignment({
    this.id,
    this.regdNumber,
    this.reason,
    this.date,
  });

  factory Reassignment.fromJson(Map<String, dynamic> json) => Reassignment(
        id: json['id'],
        regdNumber: json["regd_number"],
        reason: json["reason"],
        date: json["reassigned_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regd_number": regdNumber,
        "reason": reason,
        "reassigned_at": date,
      };
}

@HiveType(typeId: tripExpenseTypeID)
class TripExpense {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? expenseType;

  @HiveField(2)
  String? addedByUuid;

  @HiveField(3)
  String? paymentMode;

  @HiveField(4)
  double? paid;

  @HiveField(5)
  String? paidTo;

  @HiveField(6)
  String? expenseDate;

  @HiveField(7)
  String? remarks;

  TripExpense({
    this.id,
    this.expenseType,
    this.addedByUuid,
    this.paymentMode,
    this.paid,
    this.paidTo,
    this.expenseDate,
    this.remarks,
  });

  factory TripExpense.fromJson(Map<String, dynamic> json) => TripExpense(
        id: json["id"],
        expenseType: json["expense_type"],
        addedByUuid: json["added_by_uuid"],
        paymentMode: json["payment_mode"],
        paid: json["paid"].toDouble(),
        paidTo: json["paid_to"],
        expenseDate: json["expense_date"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "expense_type": expenseType,
        "added_by_uuid": addedByUuid,
        "payment_mode": paymentMode,
        "paid": paid,
        "paid_to": paidTo,
        "expense_date": expenseDate,
        "remarks": remarks,
      };
}

@HiveType(typeId: tripPaymentTypeID)
class TripPayment {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? payerType;

  @HiveField(2)
  String? paymentMode;

  @HiveField(3)
  double? amount;

  @HiveField(4)
  String? paidBy;

  @HiveField(5)
  String? receivedBy;

  @HiveField(6)
  String? paymentTime;

  TripPayment({
    this.id,
    this.payerType,
    this.paymentMode,
    this.amount,
    this.paidBy,
    this.receivedBy,
    this.paymentTime,
  });

  factory TripPayment.fromJson(Map<String, dynamic> json) => TripPayment(
        id: json["id"],
        payerType: json["payer_type"],
        paymentMode: json["payment_mode"],
        amount: json["amount"].toDouble(),
        paidBy: json["paid_by"],
        receivedBy: json["received_by"],
        paymentTime: json["payment_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payer_type": payerType,
        "payment_mode": paymentMode,
        "amount": amount,
        "paid_by": paidBy,
        "received_by": receivedBy,
        "payment_time": paymentTime,
      };
}

@HiveType(typeId: tripDocumentTypeID)
class TripDocument {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? docType;

  @HiveField(2)
  String? image;

  @HiveField(3)
  String? uploadedByUuid;

  @HiveField(4)
  String? remarks;

  TripDocument({
    this.id,
    this.docType,
    this.image,
    this.uploadedByUuid,
    this.remarks,
  });

  factory TripDocument.fromJson(Map<String, dynamic> json) => TripDocument(
        id: json["id"],
        docType: json["doc_type"],
        image: json["image"],
        uploadedByUuid: json["uploaded_by_uuid"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doc_type": docType,
        "image": image,
        "uploaded_by_uuid": uploadedByUuid,
        "remarks": remarks,
      };
}

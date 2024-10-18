class CompanyModel {
  static List<CompanyDetailModel> companyList = [];
}

class CompanyDetailModel {
  int? id;
  String? consignerName;
  String? consigneeLogo;
  String? loc;
  List<ConsigneeDetailsModel>? consigneeDetails;

  CompanyDetailModel({
    this.id,
    this.consignerName,
    this.consigneeLogo,
    this.loc,
    this.consigneeDetails,
  });

  factory CompanyDetailModel.fromMap(Map<String, dynamic> map) {
    List<dynamic>? consigneeDetailsList = map["consigneeDetails"];
    List<ConsigneeDetailsModel>? consigneeDetails = consigneeDetailsList
        ?.map((item) => ConsigneeDetailsModel.fromMap(item))
        .toList();

    return CompanyDetailModel(
      id: map["id"],
      consignerName: map["consignerName"],
      consigneeLogo: map["consigneeLogo"],
      loc: map["loc"],
      consigneeDetails: consigneeDetails,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "consignerName": consignerName,
    "consigneeLogo": consigneeLogo,
    "loc": loc,
    "consigneeDetails": consigneeDetails?.map((item) => item.toMap()).toList(),
  };
}

class ConsigneeDetailsModel {
  String? id;
  String? date;
  String? permitNo;
  String? consigneeName;
  String? mineralName;
  String? mineralType;
  String? transporterName;
  double? transportPrice;
  double? driverBonus;
  double? fuelBonus;
  String? consigneeAddress;

  ConsigneeDetailsModel({
    this.id,
    this.date,
    this.permitNo,
    this.consigneeName,
    this.mineralName,
    this.mineralType,
    this.transporterName,
    this.transportPrice,
    this.driverBonus,
    this.fuelBonus,
    this.consigneeAddress,
  });

  factory ConsigneeDetailsModel.fromMap(Map<String, dynamic> map) {
    return ConsigneeDetailsModel(
      id: map["id"],
      date: map["date"],
      permitNo: map["permitNo"],
      consigneeName: map["consigneeName"],
      mineralName: map["mineralName"],
      mineralType: map["mineralType"],
      transporterName:
      map["transporterName"],
      transportPrice:
      map["transportPrice"],
      driverBonus: map["driverBonus"],
      fuelBonus: map["fuelBonus"],
      consigneeAddress:
      map["consigneeAddress"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "date": date,
    "permitNo": permitNo,
    "consigneeName": consigneeName,
    "mineralName": mineralName,
    "mineralType": mineralType,
    "transporterName": transporterName,
    "transportPrice": transportPrice,
    "driverBonus": driverBonus,
    "fuelBonus": fuelBonus,
    "consigneeAddress": consigneeAddress,
  };
}
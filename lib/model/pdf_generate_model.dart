import '/model/owner_company_model.dart' show CompanyAddress, CompanyLegal;

class PdfGenerateModel {
  Owner? owner;
  // Null when the owner has not yet created a company profile (BR-01 not met).
  ReportOwnerCompany? ownerCompany;
  Transporter? transporter;
  RouteInfo? route;
  List<TripReport>? trips;
  ReportSummary? summary;

  PdfGenerateModel({
    this.owner,
    this.ownerCompany,
    this.transporter,
    this.route,
    this.trips,
    this.summary,
  });

  factory PdfGenerateModel.fromJson(Map<String, dynamic> json) {
    return PdfGenerateModel(
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
      ownerCompany: json['owner_company'] != null
          ? ReportOwnerCompany.fromJson(
              json['owner_company'] as Map<String, dynamic>)
          : null,
      transporter: json['transporter'] != null
          ? Transporter.fromJson(json['transporter'])
          : null,
      route: json['route'] != null ? RouteInfo.fromJson(json['route']) : null,
      trips:
          (json['trips'] as List?)?.map((e) => TripReport.fromJson(e)).toList(),
      summary: json['summary'] != null
          ? ReportSummary.fromJson(json['summary'])
          : null,
    );
  }
}

class Owner {
  String? name;
  String? mobile;
  String? panNumber;
  String? bankName;
  String? bankAccountNumber;
  String? bankIfsc;

  Owner({
    this.name,
    this.mobile,
    this.panNumber,
    this.bankName,
    this.bankAccountNumber,
    this.bankIfsc,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'],
      mobile: json['mobile'],
      panNumber: json['pan_number'],
      bankName: json['bank_name'],
      bankAccountNumber: json['bank_account_number'],
      bankIfsc: json['bank_ifsc'],
    );
  }
}

// Company profile of the trip owner, included in the /generate payload so the
// PDF can print letterhead details (GST, PAN, address, contact phones) without
// a second API call. All sub-fields are nullable — the owner may not have
// completed every section of their company profile at report-generation time.
class ReportOwnerCompany {
  final String? name;
  final String? phone;
  final String? email;
  final String? website;
  // Null when legal details have not been submitted yet (BR-09 write-once).
  final CompanyLegal? legal;
  // Null when the company address has not been saved yet.
  final CompanyAddress? address;
  // Phone numbers from all company contacts — empty list when none added.
  final List<String> contactPhones;

  const ReportOwnerCompany({
    this.name,
    this.phone,
    this.email,
    this.website,
    this.legal,
    this.address,
    this.contactPhones = const [],
  });

  factory ReportOwnerCompany.fromJson(Map<String, dynamic> json) {
    return ReportOwnerCompany(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      legal: json['legal'] != null
          ? CompanyLegal.fromJson(json['legal'] as Map<String, dynamic>)
          : null,
      address: json['address'] != null
          ? CompanyAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      contactPhones: List<String>.from(json['contact_phones'] ?? []),
    );
  }
}

class Transporter {
  int? id;
  String? name;
  List<String>? mobiles;

  Transporter({
    this.id,
    this.name,
    this.mobiles,
  });

  factory Transporter.fromJson(Map<String, dynamic> json) {
    return Transporter(
      id: json['id'],
      name: json['name'],
      mobiles: List<String>.from(json['mobiles'] ?? []),
    );
  }
}

class RouteInfo {
  String? from;
  String? to;

  RouteInfo({
    this.from,
    this.to,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      from: json['from'],
      to: json['to'],
    );
  }
}

class TripReport {
  int? slNo;
  String? date;
  String? vehicleNumber;
  String? tripCode;
  double? loadWeight;
  double? shortWeight;
  double? netWeight;
  double? rate;
  double? amount;
  double? dieselAmount;
  String? origin;
  String? destination;

  TripReport({
    this.slNo,
    this.date,
    this.vehicleNumber,
    this.tripCode,
    this.loadWeight,
    this.shortWeight,
    this.netWeight,
    this.rate,
    this.amount,
    this.dieselAmount,
    this.origin,
    this.destination,
  });

  factory TripReport.fromJson(Map<String, dynamic> json) {
    return TripReport(
      slNo: json['sl_no'],
      date: json['date'],
      vehicleNumber: json['vehicle_number'],
      tripCode: json['trip_code'],
      loadWeight: (json['load_weight'] as num?)?.toDouble(),
      shortWeight: (json['short_weight'] as num?)?.toDouble(),
      netWeight: (json['net_weight'] as num?)?.toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      dieselAmount: (json['diesel_amount'] as num?)?.toDouble(),
      origin: json['origin'],
      destination: json['destination'],
    );
  }
}

class ReportSummary {
  double? totalNetWeight;
  double? totalShortage;
  double? totalAmount;
  double? totalHsdAmount;
  double? paymentReceived;
  double? netPayable;
  int? tripCount;

  ReportSummary({
    this.totalNetWeight,
    this.totalShortage,
    this.totalAmount,
    this.totalHsdAmount,
    this.paymentReceived,
    this.netPayable,
    this.tripCount,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalNetWeight: (json['total_net_weight'] as num?)?.toDouble(),
      totalShortage: (json['total_shortage'] as num?)?.toDouble(),
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      totalHsdAmount: (json['total_hsd_amount'] as num?)?.toDouble(),
      paymentReceived: (json['payment_received'] as num?)?.toDouble(),
      netPayable: (json['net_payable'] as num?)?.toDouble(),
      tripCount: json['trip_count'],
    );
  }
}

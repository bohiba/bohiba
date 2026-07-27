// Designation codes per business-logic §3.5
const Map<int, String> kDesignationLabels = {
  0: 'Other',
  1: 'Accountant',
  2: 'Contractor',
  3: 'Engineer',
  4: 'Geologist',
  5: 'HR',
  6: 'Manager',
  7: 'Owner',
  8: 'Security',
  9: 'Surveyor',
  10: 'Nominated Owner',
  11: 'Mine Agent',
};

// Status codes per business-logic §3.3 — integer values from the DB smallint column
const int kStatusPending = 101;
const int kStatusOperating = 200;
const int kStatusShelved = 300;
const int kStatusRetired = 400;

String companyStatusLabel(int? status) {
  switch (status) {
    case kStatusPending:
      return 'Pending Approval';
    case kStatusOperating:
      return 'Active';
    case kStatusShelved:
      return 'Shelved';
    case kStatusRetired:
      return 'Retired';
    default:
      return 'Pending Approval';
  }
}

class OwnerCompanyModel {
  final int? id;
  final String? uuid;
  final String? name;
  final String? nameCode;
  final String? type;
  final int? entityType;
  final int?
      status; // DB smallint: 101=PENDING, 200=OPERATING, 300=SHELVED, 400=RETIRED
  final String? logo;
  final String? email;
  final String? phone;
  final String? website;
  final CompanyAddress? address;
  final List<CompanyContact>? contacts;
  // BR-09: write-once; null until first POST /legal succeeds
  final CompanyLegal? legal;

  const OwnerCompanyModel({
    this.id,
    this.uuid,
    this.name,
    this.nameCode,
    this.type,
    this.entityType,
    this.status,
    this.logo,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.contacts,
    this.legal,
  });

  factory OwnerCompanyModel.fromJson(Map<String, dynamic> json) {
    return OwnerCompanyModel(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      nameCode: json['name_code'],
      type: json['type']?.toString(),
      entityType: json['entity_type'],
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status']?.toString() ?? ''),
      logo: json['logo'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: json['address'] != null
          ? CompanyAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      contacts: (json['contacts'] as List?)
          ?.map((e) => CompanyContact.fromJson(e as Map<String, dynamic>))
          .toList(),
      legal: json['legal'] != null
          ? CompanyLegal.fromJson(json['legal'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'website': website,
      };

  OwnerCompanyModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? website,
    String? logo,
    CompanyAddress? address,
    List<CompanyContact>? contacts,
    int? status,
    CompanyLegal? legal,
  }) {
    return OwnerCompanyModel(
      id: id,
      uuid: uuid,
      name: name ?? this.name,
      nameCode: nameCode,
      type: type,
      entityType: entityType,
      status: status ?? this.status,
      logo: logo ?? this.logo,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      address: address ?? this.address,
      contacts: contacts ?? this.contacts,
      legal: legal ?? this.legal,
    );
  }
}

// BR-09: Write-once — no edit/delete after first submission.
// BR-10: Deleted only when the company is deleted (CASCADE on company_legal.company_id).
class CompanyLegal {
  final int? id;
  final String? gstNo;
  final String? panNo;
  final String? cinNo;
  final String? registrationType;
  final int? establishedYear;

  const CompanyLegal({
    this.id,
    this.gstNo,
    this.panNo,
    this.cinNo,
    this.registrationType,
    this.establishedYear,
  });

  factory CompanyLegal.fromJson(Map<String, dynamic> json) {
    return CompanyLegal(
      id: json['id'],
      gstNo: json['gst_no'],
      panNo: json['pan_no'],
      cinNo: json['cin_no'],
      registrationType: json['registration_type'],
      establishedYear: json['established_year'] is int
          ? json['established_year'] as int
          : int.tryParse(json['established_year']?.toString() ?? ''),
    );
  }

  // BR-11: At least one field must be non-empty.
  bool get hasAnyField =>
      (gstNo?.isNotEmpty ?? false) ||
      (panNo?.isNotEmpty ?? false) ||
      (cinNo?.isNotEmpty ?? false) ||
      (registrationType?.isNotEmpty ?? false) ||
      establishedYear != null;

  Map<String, dynamic> toJson() => {
        if (gstNo != null && gstNo!.isNotEmpty) 'gst_no': gstNo,
        if (panNo != null && panNo!.isNotEmpty) 'pan_no': panNo,
        if (cinNo != null && cinNo!.isNotEmpty) 'cin_no': cinNo,
        if (registrationType != null && registrationType!.isNotEmpty)
          'registration_type': registrationType,
        if (establishedYear != null) 'established_year': establishedYear,
      };
}

class CompanyAddress {
  final int? id;
  final String? address;
  final String? district;
  final String? districtName;
  final String? state;
  final String? stateName;
  final String? country;
  final String? pincode;
  final double? latitude;
  final double? longitude;

  const CompanyAddress({
    this.id,
    this.address,
    this.district,
    this.districtName,
    this.state,
    this.stateName,
    this.country,
    this.pincode,
    this.latitude,
    this.longitude,
  });

  factory CompanyAddress.fromJson(Map<String, dynamic> json) {
    return CompanyAddress(
      id: json['id'],
      address: json['address'],
      district: json['district'],
      districtName: json['district_name'],
      state: json['state'],
      stateName: json['state_name'],
      country: json['country'],
      pincode: json['pincode']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'district': district,
        'state': state,
        'country': country ?? 'INDIA',
        'pincode': pincode,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

  String get displayLine {
    final parts = [address, districtName, stateName, pincode]
        .where((s) => s != null && s.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}

class CompanyContact {
  final int? id;
  final String? name;
  final int? designation;
  final String? phone;
  final String? email;
  final String? address;
  final String? dateOfAppointed;

  const CompanyContact({
    this.id,
    this.name,
    this.designation,
    this.phone,
    this.email,
    this.address,
    this.dateOfAppointed,
  });

  factory CompanyContact.fromJson(Map<String, dynamic> json) {
    return CompanyContact(
      id: json['id'],
      name: json['name'],
      designation: json['designation'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      dateOfAppointed: json['date_of_appointed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'designation': designation ?? 0,
        'phone': phone,
        if (email != null && email!.isNotEmpty) 'email': email,
        if (address != null && address!.isNotEmpty) 'address': address,
        if (dateOfAppointed != null) 'date_of_appointed': dateOfAppointed,
      };

  String get designationLabel => kDesignationLabels[designation] ?? 'Other';
}

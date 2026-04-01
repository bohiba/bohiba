import 'dart:io';

import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

extension StringFormatExt on String {
  /// Returns short code from status string, e.g.
  /// "in_transit" → "IT", "on_hold" → "OH"
  String get shortCode {
    final parts = split(' ').where((e) => e.isNotEmpty).toList();
    return parts.map((word) => word[0].toUpperCase()).join();
  }

  double toDouble({double defaultValue = 0.0}) {
    return double.tryParse(this) ?? defaultValue;
  }

  /// Converts "not_looking" → "NOT LOOKING"
  String toDisplayLabel() {
    return split('_').map((e) => e.toUpperCase()).join(' ');
  }

  /// Optional: Capitalized format → "Not Looking"
  String toCapitalizedLabel() {
    return replaceAll('_', ' ').split(' ').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  String toAcronym() {
    return split(' ') // Split by spaces
        .where((word) => word.isNotEmpty) // Remove empty strings
        .map((word) => word[0].toUpperCase()) // Take first letter & capitalize
        .join(' '); // Join with dots
  }

  String toDDMMYYYY({String defaultFormat = "dd-MM-yyyy"}) {
    try {
      final dt = DateFormat("yyyy-MM-dd").parse(this);
      return DateFormat(defaultFormat).format(dt);
    } catch (e) {
      return this;
    }
  }

  bool get isValidDL {
    final regex = RegExp(r'^[A-Z]{2}[0-9]{13}$');
    return regex.hasMatch(this);
  }

  bool get isValidPan {
    final regex = RegExp(r'^[A-Z]{3}[PCHFTA]{1}[A-Z]{1}[0-9]{4}[A-Z]{1}$');
    return regex.hasMatch(toUpperCase());
  }

  bool get isValidAadhaar {
    final regex = RegExp(r'^(?:[2-9][0-9]{11}|[2-9][0-9]{3}-[0-9]{4}-[0-9]{4})$');
    return regex.hasMatch(trim());
  }

  /// Validates if the string is a valid phone number.
  /// - Only digits allowed (no +, -, spaces, or symbols)
  /// - Length between 10 to 12 (for flexibility)
  /// - Must start with 6, 7, 8, or 9 (for Indian numbers)
  bool get isValidPhone {
    final regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(trim());
  }
}

extension IntFormatExt on int {
  String toHHMM() {
    final hours = this ~/ 60;
    final minutes = this % 60;
    final hourStr = hours.toString().padLeft(2, '0');
    final minuteStr = minutes.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  String roleName() {
    switch (this) {
      case 0:
        return 'Super Admin';
      case 1:
        return 'Admin';
      case 2:
        return 'Manager';
      case 6:
        return 'Truck Owner';
      case 7:
        return 'Truck Manager';
      case 8:
        return 'Driver';
      case 9:
        return 'Guest';
      default:
        return 'Unknown';
    }
  }

  bool get isAdmin => this == 0 || this == 1;
  bool get isOwner => this == 6;
  bool get isDriver => this == 8;
  bool get isGuest => this == 9;
}

extension DoubleFormatExt on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}

/// Date Extension 'dd-MM-yyyy'
extension DateFormatter on DateTime {
  String format() {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}

// Share Extension
class ShareDriverDetails {
  final int id;
  final String name;
  final String dLNumber;
  final String vehicle;
  final String mobileNo;
  final String dob;
  final String validUpto;
  final String type;

  ShareDriverDetails({
    required this.id,
    required this.name,
    required this.dLNumber,
    required this.vehicle,
    required this.mobileNo,
    required this.dob,
    required this.validUpto,
    required this.type,
  });
}

extension DriverShareExtension on ShareDriverDetails {
  String get shareableDriverDetails {
    return '''
🚛 *Driver Information* 🚛  

*Name*: $name  
*License Number*: $dLNumber  
*Vehicle Number*: $vehicle  
*Contact*: $mobileNo  
*Date of Birth*: $dob  
*License Valid Until*: $validUpto  
*Role*: ${type.toUpperCase()}  

Visit Driver Profile: 
${Platform.isIOS ? "https://apps.apple.com/app/bohiba/driver-details/$id" : "https://play.google.com/store/apps/details?id=com.bohiba.app/driver-details/$id"}
''';
  }

  Future<void> share() async {
    await Share.share(shareableDriverDetails);
  }
}

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

extension StringToDouble on String {
  double toDouble({double defaultValue = 0.0}) {
    return double.tryParse(this) ?? defaultValue;
  }
}

extension MinutesFormatter on int {
  String toHHMM() {
    final hours = this ~/ 60;
    final minutes = this % 60;
    final hourStr = hours.toString().padLeft(2, '0');
    final minuteStr = minutes.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
}

extension DisplayStringExtension on String {
  /// Converts "not_looking" → "NOT LOOKING"
  String toDisplayLabel() {
    return split('_').map((e) => e.toUpperCase()).join(' ');
  }

  /// Optional: Capitalized format → "Not Looking"
  String toCapitalizedLabel() {
    return split('_')
        .map((e) => e.isEmpty ? '' : e[0].toUpperCase() + e.substring(1))
        .join(' ');
  }
}

/// Convert Int to String role_id
extension UserRoleExtension on int {
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

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}

// Stirng
extension AcronymExtension on String {
  String toAcronym() {
    return split(' ') // Split by spaces
        .where((word) => word.isNotEmpty) // Remove empty strings
        .map((word) => word[0].toUpperCase()) // Take first letter & capitalize
        .join(' '); // Join with dots
  }
}

extension DLValidator on String {
  bool get isValidDL {
    final regex = RegExp(r'^[A-Z]{2}[0-9]{2}[0-9]{4}[0-9]{7}$');
    return regex.hasMatch(this);
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

extension ShareAppExtension on ShareApp {
  String get shareApp {
    return '''
📢 *About Bohiba* 📢  

Bohiba is a comprehensive fleet and driver management solution, designed to help businesses and individuals **efficiently manage drivers, track vehicles, and ensure regulatory compliance**.  

✅ *Features of Bohiba*:  
🔹 *Real-time driver & vehicle tracking*
🔹 *Easy document & license management*  
🔹 *Seamless communication & notifications*
🔹 *Data-driven insights for better decision-making*

Join thousands of businesses that trust Bohiba to *streamline fleet operations* and enhance *driver efficiency*.  

📲 *Download Now*:  
🔗 ${Platform.isIOS ? "https://apps.apple.com/app/bohiba" : "https://play.google.com/store/apps/details?id=com.bohiba.app"}  
''';
  }

  Future<void> share() async {
    await Share.share(shareApp);
  }
}

class ShareApp {
  final String code;
  ShareApp({
    required this.code,
  });
}

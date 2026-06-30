import 'package:flutter/material.dart';

extension ExtMinesStatus on String {
  String get minesStatusName {
    switch (toLowerCase()) {
      case 'blocked':
        return 'BLOCKED';
      case 'active':
        return 'ACTIVE';
      case 'inactive':
        return 'INACTIVE';
      case 'under maintenance':
        return 'UNDER MAINTENANCE';
      case 'temporarily closed':
        return 'TEMPORARILY CLOSED';
      case 'permanently closed':
        return 'PERMANENTLY CLOSED';
      case 'suspended':
        return 'SUSPENDED';
      case 'archived':
        return 'ARCHIVED';
      case 'under verification':
        return 'UNDER VERIFICATION';
      default:
        return 'UNKNOWN';
    }
  }
}

extension EnumMinesStatusExtension on String {
  int get minesStatusCode {
    switch (toLowerCase()) {
      case 'blocked':
        return 0;
      case 'active':
        return 1;
      case 'inactive':
        return 2;
      case 'under maintenance':
        return 3;
      case 'temporarily closed':
        return 4;
      case 'permanently closed':
        return 5;
      case 'suspended':
        return 6;
      case 'archived':
        return 7;
      case 'under verification':
        return 8;
      default:
        return -1;
    }
  }
}

extension MinesStatusColorExtension on String? {
  Color get minesStatusColor {
    switch (this) {
      case 'OPERATING':
        return Colors.green;
      case 'UNDER REVIEW':
        return Colors.indigo;
      case 'INACTIVE':
        return Colors.amber;
      case 'UNDER MAINTENANCE':
        return Colors.orange;
      case 'LIMITED OPERATION':
        return Colors.lightGreen;
      case 'TEMPORARILY CLOSED':
        return Colors.deepOrange;
      case 'PROPOSED':
        return Colors.cyan;
      case 'PERMANENTLY CLOSED':
        return Colors.red;
      case 'COMPLIANCE HOLD':
        return Colors.deepPurple;
      case 'BLACKLISTED':
        return Colors.black87;
      case 'ARCHIVED':
        return Colors.grey;
      case 'REJECTED':
        return Colors.redAccent;
      case 'SUSPENDED':
        return Colors.brown;
      case 'RETIRED':
        return Colors.blueGrey;
      case 'SHELVED':
        return Colors.teal;
      case 'BLOCKED':
        return Colors.red.shade900;
      case 'NON':
        return Colors.grey.shade400;
      default:
        return Colors.grey;
    }
  }
}

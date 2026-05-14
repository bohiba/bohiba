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
      case 'BLOCKED':
        return Colors.red;
      case 'ACTIVE':
        return Colors.green;
      case 'INACTIVE':
        return Colors.yellow;
      case 'UNDER MAINTENANCE':
        return Colors.orange;
      case 'TEMPORARILY CLOSED':
        return Colors.purple;
      case 'PERMANENTLY CLOSED':
        return Colors.pink;
      case 'SUSPENDED':
        return Colors.brown;
      case 'ARCHIVED':
        return Colors.grey;
      case 'UNDER VERIFICATION':
        return Colors.blue;
      default:
        return Colors.yellow;
    }
  }
}

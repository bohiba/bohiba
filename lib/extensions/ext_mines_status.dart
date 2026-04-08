import 'package:flutter/material.dart';

extension ExtMinesStatus on int {
  String get minesStatusName {
    switch (this) {
      case 0:
        return 'BLOCKED';
      case 1:
        return 'ACTIVE';
      case 2:
        return 'INACTIVE';
      case 3:
        return 'UNDER MAINTENANCE';
      case 4:
        return 'TEMPORARILY CLOSED';
      case 5:
        return 'PERMANENTLY CLOSED';
      case 6:
        return 'SUSPENDED';
      case 7:
        return 'ARCHIVED';
      case 8:
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

extension MinesStatusColorExtension on int {
  Color get minesStatusColor {
    switch (this) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.pink;
      case 6:
        return Colors.brown;
      case 7:
        return Colors.grey;
      case 8:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}

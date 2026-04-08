import 'package:flutter/material.dart';

extension TruckWaitingStatusExtension on int {
  String get truckWaitingStatusName {
    switch (this) {
      case 0:
        return 'Arrived Outside';
      case 1:
        return 'In Parking';
      case 2:
        return 'In Queue';
      case 3:
        return 'Entered';
      case 4:
        return 'Loading';
      case 5:
        return 'Unloading';
      case 6:
        return 'Exited';
      case 7:
        return 'Re-entered';
      default:
        return 'Unknown';
    }
  }
}

extension ExtTruckWaitingStatusColor on int {
  Color get truckWaitingStatusColor {
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

import '../dist/enums/app_enums.dart';
import '/services/global_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticConroller extends GetxController {
  Rx<String> selectedRange = "Week".obs;

  List<Map> arrTripAnalytic = [
    {
      'id': 1,
      'name': 'Completed Trip',
      'enable': true,
    },
    {
      'id': 2,
      'name': 'Idle Day',
      'enable': true,
    },
    {
      'id': 3,
      'name': 'Earning/ Trip',
      'enable': true,
    },
    {
      'id': 4,
      'name': 'Failed Trip',
      'enable': true,
    },
    {
      'id': 5,
      'name': 'Distance traveled',
      'enable': false,
    },
    {
      'id': 5,
      'name': 'Avg Distance/ Trip',
      'enable': false,
    },
  ];

  @override
  void onReady() {
    super.onReady();
    GlobalService.showDialog(
      status: AlertStatus.info,
      title: 'Note',
      description: 'The displayed analytics are based on demo data, designed to highlight our upcoming features and showcase the powerful insights Bohiba will deliver.',
    );
  }

  Widget bottomTitleWidget(double value, TitleMeta meta) {
    switch (selectedRange.value) {
      case "Week":
        const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        if (value.toInt() >= 1 && value.toInt() <= 7) {
          return Text(days[value.toInt() - 1], style: const TextStyle(fontSize: 10));
        }
        return const SizedBox.shrink();

      case "1 Month":
        // Show dates 1, 5, 10, 15, 20, 25, 30
        if (value % 5 == 0) {
          return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
        }
        return const SizedBox.shrink();

      case "3 Months":
        // Show weeks: 0, 15, 30, 45, 60, 75, 90
        if (value % 15 == 0) {
          return Text("Day ${value.toInt()}", style: const TextStyle(fontSize: 10));
        }
        return const SizedBox.shrink();

      default:
        return Text(value.toInt().toString());
    }
  }
}

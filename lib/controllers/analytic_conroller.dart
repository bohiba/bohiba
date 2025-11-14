import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticConroller extends GetxController {
  Rx<String> selectedRange = "Week".obs;

  @override
  void onReady() {
    super.onReady();
    GlobalService.showDialog(
      status: AlertStatus.info,
      title: 'Note',
      description:
          'The displayed analytics are based on demo data, designed to highlight our upcoming features and showcase the powerful insights Bohiba will deliver.',
    );
  }

  Widget bottomTitleWidget(double value, TitleMeta meta) {
    switch (selectedRange.value) {
      case "Week":
        const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        if (value.toInt() >= 1 && value.toInt() <= 7) {
          return Text(days[value.toInt() - 1],
              style: const TextStyle(fontSize: 10));
        }
        return const SizedBox.shrink();

      case "1 Month":
        // Show dates 1, 5, 10, 15, 20, 25, 30
        if (value % 5 == 0) {
          return Text(value.toInt().toString(),
              style: const TextStyle(fontSize: 10));
        }
        return const SizedBox.shrink();

      case "3 Months":
        // Show weeks: 0, 15, 30, 45, 60, 75, 90
        if (value % 15 == 0) {
          return Text("Day ${value.toInt()}",
              style: const TextStyle(fontSize: 10));
        }
        return const SizedBox.shrink();

      default:
        return Text(value.toInt().toString());
    }
  }
}

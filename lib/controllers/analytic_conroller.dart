import '/component/bohiba_colors.dart';
import '/dist/enums/app_enums.dart';
import '/services/global_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ---------------------------------------------------------------------------
//  Data models — owned by controller, rendered by page
// ---------------------------------------------------------------------------

class AnalyticQuickStat {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const AnalyticQuickStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class AnalyticMetric {
  final String label;
  final String value;
  final double trendPct; // positive = up, negative = down
  final IconData icon;

  const AnalyticMetric({
    required this.label,
    required this.value,
    required this.trendPct,
    required this.icon,
  });
}

// ---------------------------------------------------------------------------
//  Controller
// ---------------------------------------------------------------------------

class AnalyticConroller extends GetxController {
  final isLoading = false.obs;
  final selectedRange = 'Week'.obs;

  // Hero KPI (finance headline shown at the top)
  final heroTitle = 'Total Revenue'.obs;
  final heroValue = '₹ 2,00,000'.obs;
  final heroTrend = 15.0.obs;

  // On-time delivery rate (shown in banner)
  final onTimeRate = 94.5.obs;

  // ── Quick stats strip ────────────────────────────────────────────────────

  List<AnalyticQuickStat> get quickStats => [
        const AnalyticQuickStat(
          label: 'Trips Done',
          value: '124',
          icon: Icons.local_shipping_outlined,
          color: BohibaColors.primaryColor,
        ),
        const AnalyticQuickStat(
          label: 'Active Trucks',
          value: '18',
          icon: Icons.fire_truck_outlined,
          color: BohibaColors.successColor,
        ),
        AnalyticQuickStat(
          label: 'Driver Rating',
          value: '4.8★',
          icon: Icons.star_outline_rounded,
          color: const Color(0xFFFA9238),
        ),
        const AnalyticQuickStat(
          label: 'On-Time %',
          value: '94.5%',
          icon: Icons.timer_outlined,
          color: BohibaColors.successColor,
        ),
      ];

  // ── Trip section ─────────────────────────────────────────────────────────

  final tripMetrics = const <AnalyticMetric>[
    AnalyticMetric(label: 'Completed Trips', value: '124', trendPct: 12.0, icon: Icons.check_circle_outline),
    AnalyticMetric(label: 'Idle Days', value: '8', trendPct: -3.0, icon: Icons.pause_circle_outline),
    AnalyticMetric(label: 'Earning / Trip', value: '₹ 1,613', trendPct: 8.0, icon: Icons.trending_up_rounded),
    AnalyticMetric(label: 'Failed Trips', value: '3', trendPct: -40.0, icon: Icons.cancel_outlined),
  ];

  final tripSpots = const [
    FlSpot(1, 18), FlSpot(2, 22), FlSpot(3, 19), FlSpot(4, 28),
    FlSpot(5, 24), FlSpot(6, 30), FlSpot(7, 34),
  ];

  // ── Fuel section ─────────────────────────────────────────────────────────

  final fuelMetrics = const <AnalyticMetric>[
    AnalyticMetric(label: 'Total Fuel Cost', value: '₹ 50,000', trendPct: -5.0, icon: Icons.local_gas_station_outlined),
    AnalyticMetric(label: 'Efficiency', value: '6.5 kmpl', trendPct: 3.0, icon: Icons.speed_outlined),
    AnalyticMetric(label: 'Maintenance', value: '₹ 10,000', trendPct: -2.0, icon: Icons.build_outlined),
    AnalyticMetric(label: 'Cost / km', value: '₹ 4.8', trendPct: -1.5, icon: Icons.route_outlined),
  ];

  final fuelSpots = const [
    FlSpot(1, 7500), FlSpot(2, 9100), FlSpot(3, 8200),
    FlSpot(4, 8600), FlSpot(5, 7800), FlSpot(6, 8900),
  ];

  // ── Driver section ───────────────────────────────────────────────────────

  final driverMetrics = const <AnalyticMetric>[
    AnalyticMetric(label: 'Avg Rating', value: '4.8 / 5', trendPct: 2.0, icon: Icons.star_outline_rounded),
    AnalyticMetric(label: 'Retention Rate', value: '90%', trendPct: 5.0, icon: Icons.group_outlined),
    AnalyticMetric(label: 'Safety Incidents', value: '5', trendPct: -2.0, icon: Icons.warning_amber_outlined),
    AnalyticMetric(label: 'Trips / Driver', value: '6.9', trendPct: 4.0, icon: Icons.person_outline),
  ];

  final driverBarGroups = [
    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 4.5, color: BohibaColors.primaryColor, width: 22, borderRadius: BorderRadius.circular(4))]),
    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 4.7, color: BohibaColors.primaryColor, width: 22, borderRadius: BorderRadius.circular(4))]),
    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4.8, color: BohibaColors.primaryColor, width: 22, borderRadius: BorderRadius.circular(4))]),
    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4.9, color: BohibaColors.primaryColor, width: 22, borderRadius: BorderRadius.circular(4))]),
    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 4.6, color: BohibaColors.primaryColor, width: 22, borderRadius: BorderRadius.circular(4))]),
  ];

  // ── Truck section ────────────────────────────────────────────────────────

  final truckMetrics = const <AnalyticMetric>[
    AnalyticMetric(label: 'Utilization', value: '85%', trendPct: 3.0, icon: Icons.fire_truck_outlined),
    AnalyticMetric(label: 'Downtime', value: '10 days', trendPct: -2.0, icon: Icons.schedule_outlined),
    AnalyticMetric(label: 'Maint. Cost', value: '₹ 2,000', trendPct: -1.0, icon: Icons.build_circle_outlined),
    AnalyticMetric(label: 'Avg Load', value: '78%', trendPct: 6.0, icon: Icons.inventory_outlined),
  ];

  final truckSpots = const [
    FlSpot(1, 75), FlSpot(2, 78), FlSpot(3, 80), FlSpot(4, 82),
    FlSpot(5, 79), FlSpot(6, 85), FlSpot(7, 85),
  ];

  // ── Finance section ──────────────────────────────────────────────────────

  final financeMetrics = const <AnalyticMetric>[
    AnalyticMetric(label: 'Total Revenue', value: '₹ 2,00,000', trendPct: 15.0, icon: Icons.currency_rupee),
    AnalyticMetric(label: 'Profit Margin', value: '20%', trendPct: 2.0, icon: Icons.show_chart_rounded),
    AnalyticMetric(label: 'Outstanding', value: '₹ 15,000', trendPct: -8.0, icon: Icons.receipt_long_outlined),
    AnalyticMetric(label: 'Avg Invoice', value: '₹ 1,613', trendPct: 5.0, icon: Icons.payments_outlined),
  ];

  final revenueSpots = const [
    FlSpot(1, 140000), FlSpot(2, 160000), FlSpot(3, 155000),
    FlSpot(4, 175000), FlSpot(5, 168000), FlSpot(6, 200000),
  ];

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onReady() {
    super.onReady();
    GlobalService.showDialog(
      status: AlertStatus.info,
      title: 'Note',
      description: 'Analytics shown are demo data. Real-time data will be available once the API is connected.',
    );
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  void onPeriodChanged(String period) {
    selectedRange.value = period;
    // TODO: fetch data from API for the selected period
  }

  // ── Chart helpers ────────────────────────────────────────────────────────

  Widget bottomTitleWidget(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 9);
    switch (selectedRange.value) {
      case 'Week':
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final i = value.toInt() - 1;
        return (i >= 0 && i < days.length) ? Text(days[i], style: style) : const SizedBox.shrink();

      case '1M':
        return (value % 5 == 0) ? Text('${value.toInt()}', style: style) : const SizedBox.shrink();

      case '3M':
        return (value % 15 == 0) ? Text('W${(value / 7).ceil()}', style: style) : const SizedBox.shrink();

      case 'YTD':
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        final i = value.toInt() - 1;
        return (i >= 0 && i < months.length) ? Text(months[i], style: style) : const SizedBox.shrink();

      default:
        return Text('${value.toInt()}', style: style);
    }
  }
}

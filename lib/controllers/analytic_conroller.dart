import '/component/bohiba_colors.dart';
import '/dist/enums/app_enums.dart';
import '/services/analytic_service.dart';
import '/services/global_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ---------------------------------------------------------------------------
//  Screen-specific data models (see §4.6 — model classes in controller file)
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
  // ── Loading / period ──────────────────────────────────────────────────────
  final isLoading = false.obs;
  final selectedRange = 'Week'.obs;

  // ── Hero KPI ──────────────────────────────────────────────────────────────
  final heroTitle = 'Total Revenue'.obs;
  final heroValue = '₹ 0'.obs;
  final heroTrend = 0.0.obs;

  // ── On-time delivery rate ─────────────────────────────────────────────────
  final onTimeRate = 0.0.obs;

  // ── Quick stats strip ─────────────────────────────────────────────────────
  final quickStats = <AnalyticQuickStat>[].obs;

  // ── Trip section ──────────────────────────────────────────────────────────
  final tripMetrics = <AnalyticMetric>[].obs;
  final tripSpots = <FlSpot>[const FlSpot(0, 0)].obs;
  final tripChartLabels = <String>[].obs;
  final tripChartHeaderValue = '0 trips'.obs;
  final tripChartHeaderTrend = 0.0.obs;

  // ── Fuel section ──────────────────────────────────────────────────────────
  final fuelMetrics = <AnalyticMetric>[].obs;
  final fuelSpots = <FlSpot>[const FlSpot(0, 0)].obs;
  final fuelChartLabels = <String>[].obs;
  final fuelChartHeaderValue = '₹ 0'.obs;
  final fuelChartHeaderTrend = 0.0.obs;

  // ── Driver section ────────────────────────────────────────────────────────
  final driverMetrics = <AnalyticMetric>[].obs;
  final driverBarGroups = <BarChartGroupData>[].obs;
  final driverBarLabels = <String>[].obs;
  final driverChartHeaderValue = '0.0 / 5'.obs;
  final driverChartHeaderTrend = 0.0.obs;

  // ── Truck section ─────────────────────────────────────────────────────────
  final truckMetrics = <AnalyticMetric>[].obs;
  final truckSpots = <FlSpot>[const FlSpot(0, 0)].obs;
  final truckChartLabels = <String>[].obs;
  final truckChartHeaderValue = '0%'.obs;
  final truckChartHeaderTrend = 0.0.obs;

  // ── Finance section ───────────────────────────────────────────────────────
  final financeMetrics = <AnalyticMetric>[].obs;
  final revenueSpots = <FlSpot>[const FlSpot(0, 0)].obs;
  final revenueChartLabels = <String>[].obs;
  final financeChartHeaderValue = '₹ 0'.obs;
  final financeChartHeaderTrend = 0.0.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onReady() {
    super.onReady();
    // Fetch on first open with default period 'week'.
    fetchAllData('week');
  }

  // ── Public actions ────────────────────────────────────────────────────────

  /// Called by _PeriodFilter pills. Maps UI label → API period value, then fetches.
  void onPeriodChanged(String uiPeriod) {
    selectedRange.value = uiPeriod;
    fetchAllData(_toApiPeriod(uiPeriod));
  }

  /// Fires all 6 endpoints in parallel. Sets isLoading around the batch.
  Future<void> fetchAllData(String apiPeriod) async {
    isLoading.value = true;
    try {
      // All 6 are independent — fire in parallel for speed.
      final results = await Future.wait([
        AnalyticService.fetchSummary(apiPeriod),
        AnalyticService.fetchTrips(apiPeriod),
        AnalyticService.fetchFuel(apiPeriod),
        AnalyticService.fetchDrivers(apiPeriod),
        AnalyticService.fetchTrucks(apiPeriod),
        AnalyticService.fetchFinance(apiPeriod),
      ]);

      _applySummary(results[0]);
      _applyTrips(results[1]);
      _applyFuel(results[2]);
      _applyDrivers(results[3]);
      _applyTrucks(results[4]);
      _applyFinance(results[5]);

      // If ALL endpoints returned null, the server or network is down.
      final allFailed = results.every((r) => r == null);
      if (allFailed) {
        GlobalService.showDialog(
          status: AlertStatus.warning,
          title: 'No Data',
          description:
              'Could not load analytics. Check your connection and try again.',
        );
      }
    } catch (e) {
      // Catch any unexpected error from Future.wait itself.
      GlobalService.showDialog(
        status: AlertStatus.warning,
        title: 'Error',
        description: 'Failed to load analytics. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Chart helpers (used by page's _BohibaLineChart / _BohibaBarChart) ─────

  /// Returns a bottom-title builder scoped to the given date-string label list.
  /// Called once per chart with its own labels so each section formats correctly.
  Widget Function(double, TitleMeta) bottomTitleBuilder(List<String> labels) {
    return (value, meta) {
      final i = value.toInt();
      if (i < 0 || i >= labels.length) return const SizedBox.shrink();
      return Text(
        _formatDateLabel(labels[i]),
        style: const TextStyle(fontSize: 9),
      );
    };
  }

  // ── Private: period mapping ───────────────────────────────────────────────

  /// Maps UI pill labels → API period strings.
  /// API only accepts: week | 1m | 3m | ytd
  String _toApiPeriod(String uiLabel) {
    switch (uiLabel) {
      case 'Week':
        return 'week';
      case '1M':
        return '1m';
      case '3M':
        return '3m';
      case 'YTD':
        return 'ytd';
      default:
        return 'week';
    }
  }

  // ── Private: API response → reactive fields ───────────────────────────────

  void _applySummary(Map<String, dynamic>? data) {
    if (data == null) return; // keep whatever was shown before
    final hero = data['hero'] as Map<String, dynamic>? ?? {};
    final qs = data['quick_stats'] as Map<String, dynamic>? ?? {};

    heroTitle.value = hero['title'] as String? ?? 'Total Revenue';
    heroValue.value = hero['formatted_value'] as String? ?? '₹ 0';
    heroTrend.value = (hero['trend_pct'] as num?)?.toDouble() ?? 0.0;
    onTimeRate.value =
        (data['on_time_delivery_rate'] as num?)?.toDouble() ?? 0.0;

    final rating = (qs['avg_driver_rating'] as num?)?.toDouble() ?? 0.0;
    final onTimePct = (qs['on_time_pct'] as num?)?.toDouble() ?? 0.0;

    quickStats.assignAll([
      AnalyticQuickStat(
        label: 'Trips Done',
        value: '${qs['completed_trips'] ?? 0}',
        icon: Icons.local_shipping_outlined,
        color: BohibaColors.primaryColor,
      ),
      AnalyticQuickStat(
        label: 'Active Trucks',
        value: '${qs['active_trucks'] ?? 0}',
        icon: Icons.fire_truck_outlined,
        color: BohibaColors.successColor,
      ),
      AnalyticQuickStat(
        label: 'Driver Rating',
        value: '${rating.toStringAsFixed(1)}★',
        icon: Icons.star_outline_rounded,
        color: const Color(0xFFFA9238),
      ),
      AnalyticQuickStat(
        label: 'On-Time %',
        value: '${onTimePct.toStringAsFixed(1)}%',
        icon: Icons.timer_outlined,
        color: BohibaColors.successColor,
      ),
    ]);
  }

  void _applyTrips(Map<String, dynamic>? data) {
    if (data == null) return;
    final m = data['metrics'] as Map<String, dynamic>? ?? {};
    final ct = m['completed_trips'] as Map<String, dynamic>? ?? {};
    final id = m['idle_days'] as Map<String, dynamic>? ?? {};
    final ept = m['earning_per_trip'] as Map<String, dynamic>? ?? {};
    final ft = m['failed_trips'] as Map<String, dynamic>? ?? {};

    tripMetrics.assignAll([
      AnalyticMetric(
        label: 'Completed Trips',
        value: '${ct['value'] ?? 0}',
        trendPct: (ct['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.check_circle_outline,
      ),
      AnalyticMetric(
        label: 'Idle Days',
        value: '${id['value'] ?? 0}',
        trendPct: (id['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.pause_circle_outline,
      ),
      AnalyticMetric(
        label: 'Earning / Trip',
        value: ept['formatted_value'] as String? ?? '₹ 0',
        trendPct: (ept['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.trending_up_rounded,
      ),
      AnalyticMetric(
        label: 'Failed Trips',
        value: '${ft['value'] ?? 0}',
        trendPct: (ft['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.cancel_outlined,
      ),
    ]);

    // Chart header driven by completed_trips
    tripChartHeaderValue.value = '${ct['value'] ?? 0} trips';
    tripChartHeaderTrend.value = (ct['trend_pct'] as num?)?.toDouble() ?? 0.0;

    final chart = data['chart'] as Map<String, dynamic>? ?? {};
    final series = chart['series'] as List<dynamic>? ?? [];
    tripChartLabels.assignAll(series.map((e) => e['x'] as String? ?? ''));
    tripSpots.assignAll(_toLineSpots(series));
  }

  void _applyFuel(Map<String, dynamic>? data) {
    if (data == null) return;
    final m = data['metrics'] as Map<String, dynamic>? ?? {};
    final tfc = m['total_fuel_cost'] as Map<String, dynamic>? ?? {};
    final eff = m['avg_fuel_efficiency_kmpl'] as Map<String, dynamic>? ?? {};
    final mc = m['maintenance_cost'] as Map<String, dynamic>? ?? {};
    final cpk = m['cost_per_km'] as Map<String, dynamic>? ?? {};

    fuelMetrics.assignAll([
      AnalyticMetric(
        label: 'Total Fuel Cost',
        value: tfc['formatted_value'] as String? ?? '₹ 0',
        trendPct: (tfc['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.local_gas_station_outlined,
      ),
      AnalyticMetric(
        label: 'Efficiency',
        value: eff['formatted_value'] as String? ?? '0 kmpl',
        trendPct: (eff['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.speed_outlined,
      ),
      AnalyticMetric(
        label: 'Maintenance',
        value: mc['formatted_value'] as String? ?? '₹ 0',
        trendPct: (mc['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.build_outlined,
      ),
      AnalyticMetric(
        label: 'Cost / km',
        value: cpk['formatted_value'] as String? ?? '₹ 0',
        trendPct: (cpk['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.route_outlined,
      ),
    ]);

    fuelChartHeaderValue.value = tfc['formatted_value'] as String? ?? '₹ 0';
    fuelChartHeaderTrend.value = (tfc['trend_pct'] as num?)?.toDouble() ?? 0.0;

    final chart = data['chart'] as Map<String, dynamic>? ?? {};
    final series = chart['series'] as List<dynamic>? ?? [];
    fuelChartLabels.assignAll(series.map((e) => e['x'] as String? ?? ''));
    fuelSpots.assignAll(_toLineSpots(series));
  }

  void _applyDrivers(Map<String, dynamic>? data) {
    if (data == null) return;
    final m = data['metrics'] as Map<String, dynamic>? ?? {};
    final adr = m['avg_driver_rating'] as Map<String, dynamic>? ?? {};
    final drr = m['driver_retention_rate'] as Map<String, dynamic>? ?? {};
    final si = m['safety_incidents'] as Map<String, dynamic>? ?? {};
    final atd = m['avg_trips_per_driver'] as Map<String, dynamic>? ?? {};

    driverMetrics.assignAll([
      AnalyticMetric(
        label: 'Avg Rating',
        value: adr['formatted_value'] as String? ?? '0.0 / 5',
        trendPct: (adr['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.star_outline_rounded,
      ),
      AnalyticMetric(
        label: 'Retention Rate',
        value: drr['formatted_value'] as String? ?? '0%',
        trendPct: (drr['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.group_outlined,
      ),
      AnalyticMetric(
        label: 'Safety Incidents',
        value: '${si['value'] ?? 0}',
        trendPct: (si['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.warning_amber_outlined,
      ),
      AnalyticMetric(
        label: 'Trips / Driver',
        value: atd['formatted_value'] as String? ?? '0.0',
        trendPct: (atd['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.person_outline,
      ),
    ]);

    driverChartHeaderValue.value =
        adr['formatted_value'] as String? ?? '0.0 / 5';
    driverChartHeaderTrend.value =
        (adr['trend_pct'] as num?)?.toDouble() ?? 0.0;

    final chart = data['chart'] as Map<String, dynamic>? ?? {};
    final series = chart['series'] as List<dynamic>? ?? [];

    // Driver chart uses avg_rating for bar height; x is a date (month buckets).
    driverBarLabels.assignAll(series.map((e) {
      final x = e['x'] as String? ?? '';
      try {
        final date = DateTime.parse(x);
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return months[(date.month - 1).clamp(0, 11)];
      } catch (_) {
        return x;
      }
    }));

    driverBarGroups.assignAll(
      series.asMap().entries.map((e) {
        final rating = (e.value['avg_rating'] as num?)?.toDouble() ?? 0.0;
        return BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: rating,
              color: BohibaColors.primaryColor,
              width: 22,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _applyTrucks(Map<String, dynamic>? data) {
    if (data == null) return;
    final m = data['metrics'] as Map<String, dynamic>? ?? {};
    final util = m['avg_utilization_pct'] as Map<String, dynamic>? ?? {};
    final down = m['total_downtime_days'] as Map<String, dynamic>? ?? {};
    final mc =
        m['avg_maintenance_cost_per_truck'] as Map<String, dynamic>? ?? {};
    final load = m['avg_load_pct'] as Map<String, dynamic>? ?? {};

    truckMetrics.assignAll([
      AnalyticMetric(
        label: 'Utilization',
        value: util['formatted_value'] as String? ?? '0%',
        trendPct: (util['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.fire_truck_outlined,
      ),
      AnalyticMetric(
        label: 'Downtime',
        value: down['formatted_value'] as String? ?? '0 days',
        trendPct: (down['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.schedule_outlined,
      ),
      AnalyticMetric(
        label: 'Maint. Cost',
        value: mc['formatted_value'] as String? ?? '₹ 0',
        trendPct: (mc['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.build_circle_outlined,
      ),
      AnalyticMetric(
        label: 'Avg Load',
        value: load['formatted_value'] as String? ?? '0%',
        trendPct: (load['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.inventory_outlined,
      ),
    ]);

    truckChartHeaderValue.value = util['formatted_value'] as String? ?? '0%';
    truckChartHeaderTrend.value =
        (util['trend_pct'] as num?)?.toDouble() ?? 0.0;

    final chart = data['chart'] as Map<String, dynamic>? ?? {};
    final series = chart['series'] as List<dynamic>? ?? [];
    truckChartLabels.assignAll(series.map((e) => e['x'] as String? ?? ''));
    truckSpots.assignAll(_toLineSpots(series));
  }

  void _applyFinance(Map<String, dynamic>? data) {
    if (data == null) return;
    final m = data['metrics'] as Map<String, dynamic>? ?? {};
    final rev = m['total_revenue'] as Map<String, dynamic>? ?? {};
    final pm = m['profit_margin_pct'] as Map<String, dynamic>? ?? {};
    final oi = m['outstanding_invoices'] as Map<String, dynamic>? ?? {};
    final ai = m['avg_invoice_value'] as Map<String, dynamic>? ?? {};

    financeMetrics.assignAll([
      AnalyticMetric(
        label: 'Total Revenue',
        value: rev['formatted_value'] as String? ?? '₹ 0',
        trendPct: (rev['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.currency_rupee,
      ),
      AnalyticMetric(
        label: 'Profit Margin',
        value: pm['formatted_value'] as String? ?? '0%',
        trendPct: (pm['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.show_chart_rounded,
      ),
      AnalyticMetric(
        label: 'Outstanding',
        value: oi['formatted_value'] as String? ?? '₹ 0',
        trendPct: (oi['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.receipt_long_outlined,
      ),
      AnalyticMetric(
        label: 'Avg Invoice',
        value: ai['formatted_value'] as String? ?? '₹ 0',
        trendPct: (ai['trend_pct'] as num?)?.toDouble() ?? 0.0,
        icon: Icons.payments_outlined,
      ),
    ]);

    financeChartHeaderValue.value = rev['formatted_value'] as String? ?? '₹ 0';
    financeChartHeaderTrend.value =
        (rev['trend_pct'] as num?)?.toDouble() ?? 0.0;

    final chart = data['chart'] as Map<String, dynamic>? ?? {};
    final series = chart['series'] as List<dynamic>? ?? [];
    revenueChartLabels.assignAll(series.map((e) => e['x'] as String? ?? ''));
    revenueSpots.assignAll(_toLineSpots(series));
  }

  // ── Private: chart conversion helpers ────────────────────────────────────

  /// Converts a line-chart series `[{"x":"2026-06-01","y":0}, ...]`
  /// to index-based FlSpot list (x = index, y = value).
  /// Uses index because the chart x-axis maps to label strings, not raw dates.
  List<FlSpot> _toLineSpots(List<dynamic> series) {
    if (series.isEmpty) return [const FlSpot(0, 0)];
    return series.asMap().entries.map((e) {
      final y = (e.value['y'] as num?)?.toDouble() ?? 0.0;
      return FlSpot(e.key.toDouble(), y);
    }).toList();
  }

  /// Formats an ISO-date string for the chart's x-axis based on the selected period.
  String _formatDateLabel(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      switch (selectedRange.value) {
        case 'Week':
          // e.g. "Mon", "Tue" — date is a specific calendar day
          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          return days[(date.weekday - 1).clamp(0, 6)];
        case '1M':
          // e.g. "6" — just the day of month for weekly buckets
          return '${date.day}';
        case '3M':
          // e.g. "Mar 10" — week-start dates
          const months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ];
          return '${months[(date.month - 1).clamp(0, 11)]} ${date.day}';
        case 'YTD':
          // e.g. "Jan", "Feb" — monthly buckets
          const months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ];
          return months[(date.month - 1).clamp(0, 11)];
        default:
          return '${date.day}';
      }
    } catch (_) {
      return '';
    }
  }
}

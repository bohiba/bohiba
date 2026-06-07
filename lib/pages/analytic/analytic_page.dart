import '/theme/bohiba_theme.dart';
import '/component/app_skeleton_loader.dart';
import '/controllers/analytic_conroller.dart';
import '/dist/component_exports.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// =============================================================================
//  Main Page
// =============================================================================

class AnalyticPage extends GetView<AnalyticConroller> {
  const AnalyticPage({super.key});

  static const _periods = ['Week', '1M', '3M', 'YTD'];
  static const _sectionLabels = ['Trip', 'Fuel', 'Driver', 'Truck', 'Finance'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _sectionLabels.length,
      child: Scaffold(
        backgroundColor: BohibaColors.bgColor,
        appBar: TitleAppbar(title: 'Analytics'),
        body: Obx(() {
          if (controller.isLoading.value) return const _AnalyticSkeleton();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period filter pills — always visible below AppBar
              _PeriodFilter(
                selected: controller.selectedRange.value,
                periods: _periods,
                onSelect: controller.onPeriodChanged,
              ),
              Expanded(
                child: NestedScrollView(
                  headerSliverBuilder: (ctx, _) => [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeroKpiCard(
                            title: controller.heroTitle.value,
                            value: controller.heroValue.value,
                            trendPct: controller.heroTrend.value,
                            period: controller.selectedRange.value,
                          ),
                          _QuickStatStrip(
                              stats: controller.quickStats.toList()),
                          _OnTimeDeliveryBanner(
                              rate: controller.onTimeRate.value),
                        ],
                      ),
                    ),
                  ],
                  body: Column(
                    children: [
                      // Pinned section tab bar
                      Container(
                        color: BohibaColors.bgColor,
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelColor: BohibaColors.primaryColor,
                          unselectedLabelColor: BohibaColors.greyColor,
                          indicatorColor: BohibaColors.primaryColor,
                          indicatorWeight: 2.5,
                          labelStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                          tabs:
                              _sectionLabels.map((s) => Tab(text: s)).toList(),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _SectionScrollView(
                                child: _TripContent(c: controller)),
                            _SectionScrollView(
                                child: _FuelContent(c: controller)),
                            _SectionScrollView(
                                child: _DriverContent(c: controller)),
                            _SectionScrollView(
                                child: _TruckContent(c: controller)),
                            _SectionScrollView(
                                child: _FinanceContent(c: controller)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// =============================================================================
//  Period Filter Pills
// =============================================================================

class _PeriodFilter extends StatelessWidget {
  final String selected;
  final List<String> periods;
  final void Function(String) onSelect;

  const _PeriodFilter({
    required this.selected,
    required this.periods,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        itemCount: periods.length,
        separatorBuilder: (_, __) => Gap(8.w),
        itemBuilder: (_, i) {
          final isSelected = periods[i] == selected;
          return GestureDetector(
            onTap: () => onSelect(periods[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? BohibaColors.primaryColor
                    : BohibaColors.tileColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected
                      ? BohibaColors.primaryColor
                      : BohibaColors.borderColor,
                ),
              ),
              child: Text(
                periods[i],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : BohibaColors.greyColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
//  Hero KPI Card
// =============================================================================

class _HeroKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final double trendPct;
  final String period;

  const _HeroKpiCard({
    required this.title,
    required this.value,
    required this.trendPct,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 14.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF047BFC), Color(0xFF2F96FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: BohibaColors.primaryColor.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with trend badge
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _TrendBadge(trendPct: trendPct, onDark: true),
            ],
          ),
          Gap(6.h),
          // Hero value
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          Gap(2.h),
          Text(
            'vs previous $period',
            style: TextStyle(color: Colors.white54, fontSize: 10.sp),
          ),
          Gap(14.h),
          // Mini sparkline
          SizedBox(
            height: 48.h,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(
                  bottomTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1.4),
                      FlSpot(1, 1.6),
                      FlSpot(2, 1.55),
                      FlSpot(3, 1.75),
                      FlSpot(4, 1.68),
                      FlSpot(5, 2.0),
                    ],
                    isCurved: true,
                    color: Colors.white70,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.18),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Quick Stat Strip
// =============================================================================

class _QuickStatStrip extends StatelessWidget {
  final List<AnalyticQuickStat> stats;

  const _QuickStatStrip({required this.stats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: stats.length,
        separatorBuilder: (_, __) => Gap(10.w),
        itemBuilder: (_, i) => _QuickStatChip(stat: stats[i]),
      ),
    );
  }
}

class _QuickStatChip extends StatelessWidget {
  final AnalyticQuickStat stat;

  const _QuickStatChip({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: stat.color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: stat.color.withValues(alpha: 0.18), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(stat.icon, color: stat.color, size: 18.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.value,
                style: TextStyle(
                  color: BohibaColors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stat.label,
                style: TextStyle(color: BohibaColors.greyColor, fontSize: 9.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  On-Time Delivery Banner
// =============================================================================

class _OnTimeDeliveryBanner extends StatelessWidget {
  final double rate;

  const _OnTimeDeliveryBanner({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
            color: bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.28),
            width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: bohibaTheme.colorScheme.onPrimary, size: 20.r),
          Gap(10.w),
          Expanded(
            child: Text(
              'On-Time Delivery Rate',
              style: TextStyle(
                fontSize: 13.sp,
                color: BohibaColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${rate.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: bohibaTheme.colorScheme.onPrimary,
            ),
          ),
          Gap(4.w),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 13.r, color: BohibaColors.greyColor),
        ],
      ),
    );
  }
}

// =============================================================================
//  Loading skeleton
// =============================================================================

class _AnalyticSkeleton extends StatelessWidget {
  const _AnalyticSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.0.w, bottom: 10.h),
            child: Row(
              children: List.generate(
                4,
                (index) => Container(
                  width: 55.w,
                  height: 25.h,
                  margin: EdgeInsets.only(right: 5.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 35.w),
                  decoration: BoxDecoration(
                    color: bohibaTheme.cardColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ),
          Gap(4.h),
          Container(
            height: 160.h,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: bohibaTheme.cardColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 75.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: bohibaTheme.dividerColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    Container(
                      width: 35.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: bohibaTheme.dividerColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(4.h),
          Container(
            height: 160.h,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              color: bohibaTheme.cardColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          Gap(4.h),
          AppSkeletonLoader(height: 90.h, skeletonLength: 4),
          Gap(4.h),
          AppSkeletonLoader(height: 90.h, skeletonLength: 4),
          Gap(4.h),
          AppSkeletonLoader(height: 90.h, skeletonLength: 4),
        ],
      ),
    );
  }
}

// =============================================================================
//  Scroll wrapper for each tab
// =============================================================================

class _SectionScrollView extends StatelessWidget {
  final Widget child;

  const _SectionScrollView({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80.h),
      child: child,
    );
  }
}

// =============================================================================
//  Shared: 2-column metric grid
// =============================================================================

Widget _metricGrid(List<AnalyticMetric> metrics) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      childAspectRatio: 1.7,
    ),
    itemCount: metrics.length,
    itemBuilder: (_, i) => _MetricCard(metric: metrics[i]),
  );
}

class _MetricCard extends StatelessWidget {
  final AnalyticMetric metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: BohibaColors.bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: BohibaColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon + trend badge row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(metric.icon, size: 16.r, color: BohibaColors.primaryColor),
              const Spacer(),
              _TrendBadge(trendPct: metric.trendPct),
            ],
          ),
          // Value + label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: BohibaColors.black,
                ),
              ),
              Text(
                metric.label,
                style:
                    TextStyle(fontSize: 10.sp, color: BohibaColors.greyColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Trend badge
// =============================================================================

class _TrendBadge extends StatelessWidget {
  final double trendPct;
  final bool onDark;

  const _TrendBadge({required this.trendPct, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final isPositive = trendPct >= 0;
    final Color trendColor;
    final Color bgColor;

    if (onDark) {
      trendColor = Colors.white;
      bgColor = Colors.white.withValues(alpha: 0.2);
    } else if (trendPct == 0) {
      trendColor = bohibaTheme.textTheme.headlineSmall!.color!;
      bgColor = bohibaTheme.cardColor.withValues(alpha: 0.5);
    } else if (isPositive) {
      trendColor = bohibaTheme.colorScheme.onPrimary;
      bgColor = bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.1);
    } else {
      trendColor = bohibaTheme.colorScheme.onTertiary;
      bgColor = bohibaTheme.colorScheme.onTertiary.withValues(alpha: 0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: 9.r,
            color: trendColor,
          ),
          Gap(1.w),
          Text(
            '${trendPct.abs().toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: trendColor,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Chart section header
// =============================================================================

Widget _chartHeader({
  required String title,
  required String value,
  required String trendLabel,
  required double trendPct,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    TextStyle(fontSize: 12.sp, color: BohibaColors.greyColor)),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: BohibaColors.black,
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TrendBadge(trendPct: trendPct),
            Gap(2.h),
            Text(trendLabel,
                style:
                    TextStyle(fontSize: 9.sp, color: BohibaColors.greyColor)),
          ],
        ),
      ],
    ),
  );
}

// =============================================================================
//  Section content widgets
// =============================================================================

class _TripContent extends StatelessWidget {
  final AnalyticConroller c;

  const _TripContent({required this.c});

  @override
  Widget build(BuildContext context) {
    // Reading RxList via .toList() is tracked by the parent Obx so this
    // widget rebuilds whenever tripMetrics / tripSpots / tripChartLabels change.
    final metrics = c.tripMetrics.toList();
    final spots = c.tripSpots.toList();
    final labels = c.tripChartLabels.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metricGrid(metrics),
        _chartHeader(
          title: 'Trips Over Time',
          value: c.tripChartHeaderValue.value,
          trendLabel: 'vs prev period',
          trendPct: c.tripChartHeaderTrend.value,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _BohibaLineChart(
            spots: spots,
            bottomTitlesBuilder: c.bottomTitleBuilder(labels),
          ),
        ),
      ],
    );
  }
}

class _FuelContent extends StatelessWidget {
  final AnalyticConroller c;

  const _FuelContent({required this.c});

  @override
  Widget build(BuildContext context) {
    final metrics = c.fuelMetrics.toList();
    final spots = c.fuelSpots.toList();
    final labels = c.fuelChartLabels.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metricGrid(metrics),
        _chartHeader(
          title: 'Fuel Costs Over Time',
          value: c.fuelChartHeaderValue.value,
          trendLabel: 'vs prev period',
          trendPct: c.fuelChartHeaderTrend.value,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _BohibaLineChart(
            spots: spots,
            bottomTitlesBuilder: c.bottomTitleBuilder(labels),
          ),
        ),
      ],
    );
  }
}

class _DriverContent extends StatelessWidget {
  final AnalyticConroller c;

  const _DriverContent({required this.c});

  @override
  Widget build(BuildContext context) {
    final metrics = c.driverMetrics.toList();
    final barGroups = c.driverBarGroups.toList();
    final barLabels = c.driverBarLabels.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metricGrid(metrics),
        _chartHeader(
          title: 'Driver Performance',
          value: c.driverChartHeaderValue.value,
          trendLabel: 'vs prev period',
          trendPct: c.driverChartHeaderTrend.value,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _BohibaBarChart(
            barGroups: barGroups,
            bottomLabels: barLabels,
          ),
        ),
      ],
    );
  }
}

class _TruckContent extends StatelessWidget {
  final AnalyticConroller c;

  const _TruckContent({required this.c});

  @override
  Widget build(BuildContext context) {
    final metrics = c.truckMetrics.toList();
    final spots = c.truckSpots.toList();
    final labels = c.truckChartLabels.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metricGrid(metrics),
        _chartHeader(
          title: 'Truck Utilization',
          value: c.truckChartHeaderValue.value,
          trendLabel: 'vs prev period',
          trendPct: c.truckChartHeaderTrend.value,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _BohibaLineChart(
            spots: spots,
            bottomTitlesBuilder: c.bottomTitleBuilder(labels),
          ),
        ),
      ],
    );
  }
}

class _FinanceContent extends StatelessWidget {
  final AnalyticConroller c;

  const _FinanceContent({required this.c});

  @override
  Widget build(BuildContext context) {
    final metrics = c.financeMetrics.toList();
    final spots = c.revenueSpots.toList();
    final labels = c.revenueChartLabels.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _metricGrid(metrics),
        _chartHeader(
          title: 'Revenue Over Time',
          value: c.financeChartHeaderValue.value,
          trendLabel: 'vs prev period',
          trendPct: c.financeChartHeaderTrend.value,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _BohibaLineChart(
            spots: spots,
            bottomTitlesBuilder: c.bottomTitleBuilder(labels),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
//  Chart widgets
// =============================================================================

class _BohibaLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final Widget Function(double, TitleMeta) bottomTitlesBuilder;

  const _BohibaLineChart({
    required this.spots,
    required this.bottomTitlesBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Guard: chart crashes with 0 or 1 point — show placeholder instead.
    if (spots.length < 2) {
      return SizedBox(
        height: ScreenUtils.height * 0.22,
        child: Center(
          child: Text(
            'No data for this period',
            style: TextStyle(
              fontSize: 12.sp,
              color: BohibaColors.greyColor,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: ScreenUtils.height * 0.22,
      child: LineChart(
        LineChartData(
          minX: spots.first.x,
          maxX: spots.last.x,
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) =>
                  BohibaColors.black.withValues(alpha: 0.85),
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map((s) => LineTooltipItem(
                        s.y > 999
                            ? '₹ ${s.y.toStringAsFixed(0)}'
                            : s.y.toStringAsFixed(1),
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                  .toList(),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: BohibaColors.borderColor, width: 1),
              bottom: BorderSide(color: BohibaColors.borderColor, width: 1),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFEDEDED), strokeWidth: 0.5),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                interval: 1.0,
                getTitlesWidget: bottomTitlesBuilder,
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              isStrokeCapRound: true,
              color: BohibaColors.primaryColor,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 3,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: BohibaColors.primaryColor,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    BohibaColors.primaryColor.withValues(alpha: 0.14),
                    BohibaColors.primaryColor.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BohibaBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final List<String> bottomLabels;

  const _BohibaBarChart({
    required this.barGroups,
    required this.bottomLabels,
  });

  // Guard: show placeholder when API returns empty driver series.
  bool get _isEmpty => barGroups.isEmpty;

  double get _maxY {
    double max = 0;
    for (final g in barGroups) {
      for (final r in g.barRods) {
        if (r.toY > max) max = r.toY;
      }
    }
    // Minimum maxY of 5.0 prevents a zero-height chart when all values are 0.
    return max == 0 ? 5.0 : max * 1.25;
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return SizedBox(
        height: 200.h,
        child: Center(
          child: Text(
            'No data for this period',
            style: TextStyle(fontSize: 12.sp, color: BohibaColors.greyColor),
          ),
        ),
      );
    }
    return SizedBox(
      height: 200.h,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) =>
                  BohibaColors.black.withValues(alpha: 0.85),
              getTooltipItem: (_, __, rod, ___) => BarTooltipItem(
                rod.toY.toStringAsFixed(1),
                const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: BohibaColors.borderColor, width: 1),
              bottom: BorderSide(color: BohibaColors.borderColor, width: 1),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFEDEDED), strokeWidth: 0.5),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i >= 0 && i < bottomLabels.length) {
                    return Text(
                      bottomLabels[i],
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: BohibaColors.greyColor,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }
}

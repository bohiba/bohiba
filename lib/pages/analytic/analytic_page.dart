import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AnalyticPage extends StatelessWidget {
  const AnalyticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Analytic'),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: ScreenUtils.height20,
                  left: ScreenUtils.width15,
                  right: ScreenUtils.width15,
                  bottom: 70,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle("Trip Analytics"),
                    Wrap(
                      spacing: 5.w,
                      runSpacing: 5.h,
                      children: [
                        metricCard('Total Trip', '1,250'),
                        metricCard("Average Trip Distance", "350 miles"),
                        metricCard("On-Time Delivery Rate", "95%"),
                      ],
                    ),
                    chartSection(
                      title: "Trips Over Time",
                      value: "1,250",
                      subLabel: "Last 30 Days",
                      subValue: "+12%",
                      subColor: const Color(0xFF0BDA5B),
                      child: ReusableLineChart(
                        spots: [
                          FlSpot(1.5, 4.2),
                          FlSpot(2.6, 2.8),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 3),
                          FlSpot(8.2, 4),
                          FlSpot(9.5, 3),
                          FlSpot(10.5, 4),
                        ],
                      ),
                    ),
                    sectionTitle("Fuel & Expense Analytics"),
                    Wrap(
                      spacing: 5.w,
                      runSpacing: 5.h,
                      children: [
                        metricCard("Total Fuel Cost", "\$50,000"),
                        metricCard("Average Fuel Efficiency", "6.5 MPG"),
                        metricCard("Maintenance Expenses", "\$10,000"),
                      ],
                    ),
                    chartSection(
                      title: "Fuel Costs by Month",
                      value: "\$50,000",
                      subLabel: "Last 6 Months",
                      subValue: "-5%",
                      subColor: Color(0xFFFA6238),
                      child: Placeholder(
                        fallbackHeight: 180,
                        color: Colors.tealAccent.shade100,
                      ),
                    ),
                    sectionTitle("Driver Analytics"),
                    Wrap(
                      spacing: 5.w,
                      runSpacing: 5.h,
                      children: [
                        metricCard("Average Driver Rating", "4.8/5"),
                        metricCard("Driver Retention Rate", "90%"),
                        metricCard("Safety Incidents", "5"),
                      ],
                    ),
                    chartSection(
                      title: "Driver Performance",
                      value: "4.8/5",
                      subLabel: "Last Quarter",
                      subValue: "+2%",
                      subColor: bohibaTheme.colorScheme.surface,
                      child: ReusableBarChart(
                        height: 250,
                        showBorder: true,
                        borderColor: bohibaTheme.dividerColor,
                        showGrid: false,
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: 8,
                                color: bohibaTheme.primaryColor,
                                width: 20,
                                borderRadius: BorderRadius.zero,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: 5,
                                color: bohibaTheme.primaryColor,
                                width: 20,
                                borderRadius: BorderRadius.zero,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: 10,
                                color: bohibaTheme.primaryColor,
                                width: 20,
                                borderRadius: BorderRadius.zero,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                toY: 7,
                                color: bohibaTheme.primaryColor,
                                width: 20,
                                borderRadius: BorderRadius.zero,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    sectionTitle("Truck Analytics"),
                    Wrap(
                      spacing: 5.w,
                      runSpacing: 5.h,
                      children: [
                        metricCard("Average Truck Utilization", "85%"),
                        metricCard("Truck Downtime", "10 days"),
                        metricCard("Maintenance Costs per Truck", "\$2,000"),
                      ],
                    ),
                    chartSection(
                      title: "Truck Utilization",
                      value: "85%",
                      subLabel: "Last Month",
                      subValue: "+3%",
                      subColor: Color(0xFF0BDA5B),
                      child: ReusableLineChart(
                        spots: [
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 2.5),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(11, 4),
                        ],
                      ),
                    ),
                    sectionTitle("Finance Analytics"),
                    Wrap(
                      spacing: 5.w,
                      runSpacing: 5.h,
                      children: [
                        metricCard("Total Revenue", "\$200,000"),
                        metricCard("Profit Margin", "20%"),
                        metricCard("Outstanding Invoices", "\$15,000"),
                      ],
                    ),
                    chartSection(
                      title: "Revenue Over Time",
                      value: "\$200,000",
                      subLabel: "Last Year",
                      subValue: "+15%",
                      subColor: Color(0xFF0BDA5B),
                      child: Placeholder(
                        fallbackHeight: 180,
                        color: Colors.green.shade200,
                      ),
                    ),
                    sectionTitle("Business Insights"),
                    sectionText(
                        "Key trends and insights based on your data, including areas for improvement and opportunities for growth."),
                    sectionTitle("Alerts & Predictions"),
                    sectionText(
                        "Upcoming maintenance alerts, predicted fuel costs, and other important notifications."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======= UI helper widgets =======

  static Widget sectionTitle(String title) => Padding(
        padding: EdgeInsets.only(top: 15.h, bottom: 5.0.h),
        child: Text(title, style: bohibaTheme.textTheme.headlineLarge),
      );

  static Widget sectionText(String text) => Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10.h),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      );

  static Widget metricRow(List<Widget> children) => Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: children
              .map((w) => Expanded(
                  child: Padding(padding: const EdgeInsets.all(6), child: w)))
              .toList(),
        ),
      );

  static Widget metricCard(String label, String value) => Container(
        width: ScreenUtils.width * 0.45,
        constraints: BoxConstraints(
          maxHeight: ScreenUtils.height * 0.15,
          minWidth: ScreenUtils.width * 0.45,
        ),
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: bohibaTheme.dividerColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: bohibaTheme.textTheme.labelLarge,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  static Widget chartSection({
    required String title,
    required String value,
    required String subLabel,
    required String subValue,
    required Color subColor,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 25.h, bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: bohibaTheme.textTheme.headlineMedium),
          Text(
            value,
            style: bohibaTheme.textTheme.displaySmall,
          ),
          Row(
            children: [
              Text(
                subLabel,
                style: bohibaTheme.textTheme.titleMedium,
              ),
              Gap(5.h),
              Text(
                subValue,
                style: TextStyle(
                  color: subColor,
                  fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                ),
              ),
            ],
          ),
          Gap(10.h),
          child,
        ],
      ),
    );
  }
}

class ReusableLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double lineWidth;
  final bool isCurved;
  final bool showBorder;
  final bool showGrid;
  final bool showTitles;
  final Color? borderColor;
  final double? height;

  const ReusableLineChart({
    required this.spots,
    this.lineWidth = 2.0,
    this.isCurved = true,
    this.showBorder = true,
    this.showGrid = false,
    this.showTitles = true,
    this.borderColor,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? ScreenUtils.height * 0.23,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(
            show: showBorder,
            border: Border(
              left: BorderSide(color: bohibaTheme.dividerColor, width: 1),
              bottom: BorderSide(color: bohibaTheme.dividerColor, width: 1),
            ),
          ),
          gridData: FlGridData(show: showGrid),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showTitles,
                reservedSize: 30,
                getTitlesWidget: (value, meta) =>
                    Text(value.toInt().toString()),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showTitles,
                reservedSize: 10,
                getTitlesWidget: (value, meta) =>
                    Text(value.toInt().toString()),
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: isCurved,
              color: bohibaTheme.primaryColor,
              // gradient: LinearGradient(
              //   colors: [
              //     bohibaTheme.disabledColor,
              //     bohibaTheme.primaryColor,
              //   ],
              // ),
              barWidth: lineWidth,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    bohibaTheme.primaryColor.withValues(alpha: 0.2),
                    Colors.blue.withValues(alpha: 0.0),
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

class ReusableBarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final bool showBorder;
  final bool showGrid;
  final bool showTitles;
  final Color? borderColor;
  final double? height;
  final Color? barColor;

  const ReusableBarChart({
    required this.barGroups,
    this.showBorder = false,
    this.showGrid = false,
    this.showTitles = true,
    this.borderColor,
    this.height,
    this.barColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? bohibaTheme.dividerColor;

    return SizedBox(
      height: height ?? 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          borderData: FlBorderData(
            show: showBorder,
            border: Border(
              left: BorderSide(color: color, width: 1),
              bottom: BorderSide(color: color, width: 1),
            ),
          ),
          gridData: FlGridData(show: showGrid),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showTitles,
                reservedSize: 28,
                getTitlesWidget: (value, meta) =>
                    Text(value.toInt().toString()),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showTitles,
                reservedSize: 28,
                getTitlesWidget: (value, meta) =>
                    Text(value.toInt().toString()),
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }

  double _getMaxY() {
    double maxY = 0;
    for (var group in barGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > maxY) maxY = rod.toY;
      }
    }
    return maxY * 1.2; // add 20% padding on top
  }
}

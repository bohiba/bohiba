import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '/dist/component_exports.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class ReportsHomeScreen extends StatelessWidget {
  const ReportsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Reports'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.width15, vertical: ScreenUtils.height10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generate Reports',
              style: bohibaTheme.textTheme.displaySmall,
            ),
            Gap(ScreenUtils.height5),
            Text(
              'Export trip data as a PDF for record-keeping, sharing, or billing.',
              style: bohibaTheme.textTheme.bodySmall,
            ),
            Gap(ScreenUtils.height15),
            _ReportCard(
              icon: RemixIcons.file_chart_line,
              title: 'Trip report',
              description:
                  'Filter by transport, mine, plant, and date. Select trips and export a PDF.',
              onTap: () => Get.toNamed(AppRoute.tripReportFilter),
            ),
            Gap(ScreenUtils.height10),
            _ReportCard(
              icon: RemixIcons.money_dollar_circle_line,
              title: 'Expense report',
              description: 'Coming soon.',
              enabled: false,
            ),
            Gap(ScreenUtils.height10),
            _ReportCard(
              icon: RemixIcons.car_line,
              title: 'Fleet report',
              description: 'Coming soon.',
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final bool enabled;

  const _ReportCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = bohibaTheme;
    final primary = theme.primaryColor;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: enabled ? primary : null,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                  bottom: enabled ? Radius.zero : Radius.circular(10.r),
                ),
                border: enabled ? Border.all(width: 1.0, color: primary) : null,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: enabled
                          ? Colors.white.withValues(alpha: 0.18)
                          : primary.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(icon,
                        color: enabled ? Colors.white : primary, size: 20.r),
                  ),
                  Gap(12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: enabled ? Colors.white : primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!enabled)
                        Text(
                          'Coming soon',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: enabled
                                ? Colors.white
                                : bohibaTheme.primaryColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (enabled)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description, style: theme.textTheme.bodySmall),
                    Gap(10.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onTap,
                            icon: Icon(RemixIcons.add_large_fill,
                                size: 16.r, color: Colors.white),
                            label: Text(
                              'GENERATE REPORT',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

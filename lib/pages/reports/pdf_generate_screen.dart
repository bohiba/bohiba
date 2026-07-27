import 'package:bohiba/component/bohiba_buttons/primary_icon_button.dart';
import 'package:bohiba/model/pdf_generate_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

import '/controllers/trip_report_controller.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

class PdfGenerateScreen extends GetView<TripReportController> {
  const PdfGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final step = controller.reportStep.value;
      return Scaffold(
        appBar: TitleAppbar(
          title: 'Trip report',
          showLeading: step == ReportStep.done || step == ReportStep.error,
          actions: step == ReportStep.done
              ? [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (val) {
                      if (val == 'download') controller.downloadPdf();
                      if (val == 'share') controller.sharePdf();
                      if (val == 'print') controller.printPdf();
                      if (val == 'regen') {
                        controller.reportStep.value = ReportStep.idle;
                        controller.generatePdf();
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'download', child: Text('Download')),
                      PopupMenuItem(value: 'share', child: Text('Share')),
                      PopupMenuItem(value: 'print', child: Text('Print')),
                      PopupMenuItem(value: 'regen', child: Text('Regenerate')),
                    ],
                  ),
                ]
              : null,
        ),
        body: _buildBody(step),
        bottomNavigationBar: step == ReportStep.done
            ? _PdfActions(controller: controller)
            : null,
      );
    });
  }

  Widget _buildBody(ReportStep step) {
    switch (step) {
      case ReportStep.fetching:
        return _ProgressBody(
          steps: const ['Sending trip IDs', 'Fetching trip details'],
          currentIndex: 0,
          subtitle:
              'Fetching details for ${controller.selectionCount} trips...',
        );
      case ReportStep.generating:
        return _ProgressBody(
          steps: const [
            'Sending trip IDs',
            'Fetching trip details',
            'Generating PDF',
          ],
          currentIndex: 2,
          subtitle: 'Building your PDF report...',
        );
      case ReportStep.done:
        final data = controller.reportData.value;
        if (data == null) return const SizedBox.shrink();
        return _TripPreviewList(data: data);
      case ReportStep.error:
        return _ErrorBody(onRetry: controller.retryGenerate);
      case ReportStep.idle:
        return _ProgressBody(
          steps: const ['Preparing report'],
          currentIndex: 0,
          subtitle: 'Starting...',
        );
    }
  }
}

class _TripPreviewList extends StatelessWidget {
  final PdfGenerateModel data;
  const _TripPreviewList({required this.data});

  String _fmt(String? raw) {
    if (raw == null) return '-';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('dd/MM/yy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: bohibaTheme.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline,
                  size: 18.r, color: bohibaTheme.primaryColor),
              Gap(8.w),
              Text(
                'PDF ready  •  ${data.trips?.length ?? 0} trip${(data.trips?.length ?? 0) == 1 ? '' : 's'}',
                style: bohibaTheme.textTheme.bodyMedium?.copyWith(
                  color: bohibaTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Gap(12.h),
        ...(data.trips ?? []).map((t) => _TripPreviewCard(trip: t, fmt: _fmt)),
        if (data.summary != null) _TotalsSummaryRow(summary: data.summary!),
        Gap(80.h),
      ],
    );
  }
}

class _TripPreviewCard extends StatelessWidget {
  final TripReport trip;
  final String Function(String?) fmt;
  const _TripPreviewCard({required this.trip, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: bohibaTheme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: bohibaTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  trip.tripCode ?? '-',
                  style: bohibaTheme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700, fontSize: 13.sp),
                ),
              ),
              if (trip.vehicleNumber != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: bohibaTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    trip.vehicleNumber!,
                    style: bohibaTheme.textTheme.labelSmall?.copyWith(
                        color: bohibaTheme.primaryColor, fontSize: 10.sp),
                  ),
                ),
            ],
          ),
          Gap(8.h),
          _Row('Origin', trip.origin),
          _Row('Destination', trip.destination),
          Divider(height: 12.h, color: bohibaTheme.dividerColor),
          Row(
            children: [
              Expanded(child: _Row('Date', fmt(trip.date))),
              if (trip.netWeight != null)
                Expanded(
                  child:
                      _Row('Net Wt (MT)', trip.netWeight!.toStringAsFixed(2)),
                ),
            ],
          ),
          if (trip.rate != null) _Row('Rate', trip.rate!.toStringAsFixed(2)),
          if (trip.shortWeight != null)
            _Row('Shortage (MT)', trip.shortWeight!.toStringAsFixed(2)),
        ],
      ),
    );
  }
}

class _TotalsSummaryRow extends StatelessWidget {
  final ReportSummary summary;
  const _TotalsSummaryRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    String fmtNum(double? v, {int decimals = 2}) =>
        v != null ? v.toStringAsFixed(decimals) : '-';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bohibaTheme.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: bohibaTheme.primaryColor.withValues(alpha: 0.30),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'TOTALS',
                style: bohibaTheme.textTheme.labelSmall?.copyWith(
                  color: bohibaTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Text(
                '${summary.tripCount ?? 0} trip${(summary.tripCount ?? 0) == 1 ? '' : 's'}',
                style: bohibaTheme.textTheme.labelSmall?.copyWith(
                  color: bohibaTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          Divider(height: 10.h, color: bohibaTheme.primaryColor.withValues(alpha: 0.20)),
          Row(
            children: [
              Expanded(
                child: _TotalCell(
                  label: 'Net Wt (MT)',
                  value: fmtNum(summary.totalNetWeight),
                ),
              ),
              Expanded(
                child: _TotalCell(
                  label: 'Amount',
                  value: fmtNum(summary.totalAmount),
                ),
              ),
              Expanded(
                child: _TotalCell(
                  label: 'Short (MT)',
                  value: fmtNum(summary.totalShortage),
                ),
              ),
              Expanded(
                child: _TotalCell(
                  label: 'Diesel',
                  value: fmtNum(summary.totalHsdAmount),
                  isLast: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalCell extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  const _TotalCell({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: isLast ? 0 : 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: bohibaTheme.textTheme.labelSmall?.copyWith(
              color: BohibaColors.greyColor,
              fontSize: 9.sp,
            ),
          ),
          Gap(2.h),
          Text(
            value,
            style: bohibaTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String? value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88.w,
            child: Text(label,
                style: bohibaTheme.textTheme.labelSmall
                    ?.copyWith(color: BohibaColors.greyColor, fontSize: 10.sp)),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: bohibaTheme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBody extends StatelessWidget {
  final List<String> steps;
  final int currentIndex;
  final String subtitle;

  const _ProgressBody({
    required this.steps,
    required this.currentIndex,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24.r,
              height: 24.r,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: bohibaTheme.primaryColor,
              ),
            ),
            Gap(20.h),
            Text('Generating your report',
                style: bohibaTheme.textTheme.titleMedium),
            Gap(6.h),
            Text(subtitle,
                style: bohibaTheme.textTheme.bodySmall,
                textAlign: TextAlign.center),
            Gap(24.h),
            ...List.generate(steps.length + 1, (i) {
              if (i < steps.length) {
                final isDone = i < currentIndex;
                final isActive = i == currentIndex;
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      _StepDot(isDone: isDone, isActive: isActive),
                      Gap(10.w),
                      Text(
                        steps[i],
                        style: bohibaTheme.textTheme.bodySmall?.copyWith(
                          color: isActive
                              ? bohibaTheme.primaryColor
                              : isDone
                                  ? BohibaColors.successColor
                                  : BohibaColors.greyColor,
                          fontWeight:
                              isActive ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // "Preparing preview" always pending
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      _StepDot(isDone: false, isActive: false),
                      Gap(10.w),
                      Text('Preparing preview',
                          style: bohibaTheme.textTheme.bodySmall
                              ?.copyWith(color: BohibaColors.greyColor)),
                    ],
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isDone;
  final bool isActive;
  const _StepDot({required this.isDone, required this.isActive});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    if (isDone) {
      bg = BohibaColors.successColor.withValues(alpha: 0.12);
      fg = BohibaColors.successColor;
      icon = Icons.check;
    } else if (isActive) {
      bg = bohibaTheme.primaryColor.withValues(alpha: 0.12);
      fg = bohibaTheme.primaryColor;
      icon = Icons.rotate_right;
    } else {
      bg = bohibaTheme.dividerColor;
      fg = BohibaColors.greyColor;
      icon = Icons.circle_outlined;
    }
    return Container(
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, size: 13.r, color: fg),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorBody({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_copy_outlined,
                size: 52.r, color: BohibaColors.warningColor),
            Gap(12.h),
            Text('PDF generation failed',
                style: bohibaTheme.textTheme.titleMedium),
            Gap(6.h),
            Text(
              'Something went wrong while building the PDF. Your trip data is safe.',
              style: bohibaTheme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            Gap(20.h),
            Row(
              children: [
                Expanded(
                  child: PrimaryTextIconButton(
                    onPressed: onRetry,
                    widget: const Icon(Icons.refresh, color: Colors.white),
                    label: 'RETRY',
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfActions extends StatelessWidget {
  final TripReportController controller;
  const _PdfActions({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bohibaTheme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: bohibaTheme.dividerColor)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryTextIconButton(
              onPressed: controller.downloadPdf,
              widget: const Icon(Icons.download),
              label: "DOWNLOAD PDF",
            ),
            Gap(8.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.sharePdf,
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 40.h),
                    ),
                  ),
                ),
                Gap(8.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.printPdf,
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('Print'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 40.h),
                    ),
                  ),
                ),
                Gap(8.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      controller.reportStep.value = ReportStep.idle;
                      controller.generatePdf();
                    },
                    icon: const Icon(RemixIcons.refresh_line),
                    label: const Text('Regen'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 40.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

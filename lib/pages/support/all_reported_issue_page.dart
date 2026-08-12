import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '../../controllers/all_ticket_controller.dart';
import '/model/ticket_model.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class AllReportedIssuePage extends GetView<AllTicketController> {
  const AllReportedIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(title: 'My Tickets'),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return _TicketSkeleton();
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return _ErrorState(
            message: controller.errorMessage.value,
            onRetry: controller.fetchTickets,
          );
        }

        if (controller.tickets.isEmpty) {
          return const _EmptyState();
        }

        return RefreshIndicator(
          color: bohibaTheme.primaryColor,
          onRefresh: controller.fetchTickets,
          child: ListView.separated(
            padding: EdgeInsets.only(
              top: ScreenUtils.height15,
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
              bottom: 100.h,
            ),
            itemCount: controller.tickets.length,
            separatorBuilder: (_, __) => Gap(ScreenUtils.height10),
            itemBuilder: (context, index) {
              return _TicketCard(
                ticket: controller.tickets[index],
                onTap: () =>
                    _showTicketDetail(context, controller.tickets[index]),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            navigatorState.pushNamed(AppRoute.reportIssue).then((onValue) {
          if (onValue == true) {
            controller.fetchTickets();
          }
        }),
        backgroundColor: bohibaTheme.primaryColor,
        icon: Icon(Remix.add_line, color: BohibaColors.white),
        label: Text(
          'New Ticket',
          style: TextStyle(
            color: BohibaColors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  void _showTicketDetail(BuildContext context, TicketModel ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bohibaTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TicketDetailSheet(ticket: ticket),
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const _TicketCard({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color priorityColor = _priorityColor(ticket.priority ?? '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bohibaTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: bohibaTheme.colorScheme.surface,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.width10,
                    vertical: ScreenUtils.height10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // UID + status row
                      Row(
                        children: [
                          _UidChip(uid: ticket.uid ?? ''),
                          const Spacer(),
                          _StatusBadge(
                            label: ticket.status ?? '',
                            isResolved: ticket.isResolved,
                          ),
                        ],
                      ),
                      Gap(ScreenUtils.height8),
                      // Title
                      Text(
                        ticket.title ?? '',
                        style: bohibaTheme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(ScreenUtils.height8),
                      // Category + priority chips
                      Row(
                        children: [
                          _CategoryChip(label: ticket.category ?? ""),
                          Gap(ScreenUtils.width8),
                          _PriorityChip(
                            label: ticket.priority ?? '',
                            color: priorityColor,
                          ),
                          const Spacer(),
                          // Created date
                          Text(
                            _formatDate(ticket.createdAt ?? ''),
                            style: bohibaTheme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'HIGH':
        return BohibaColors.warningColor;
      case 'MEDIUM':
        return BohibaColors.orange;
      case 'LOW':
        return BohibaColors.successColor;
      default:
        return BohibaColors.successColor;
    }
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }
}

// ── Detail bottom sheet ───────────────────────────────────────────────────────

class _TicketDetailSheet extends StatelessWidget {
  final TicketModel ticket;

  const _TicketDetailSheet({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) {
        return Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BohibaColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.width20,
                  vertical: ScreenUtils.height5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // UID + priority row
                    Row(
                      children: [
                        _UidChip(uid: ticket.uid ?? ''),
                        const Spacer(),
                        _PriorityChip(
                          label: ticket.priority ?? '',
                          color: _priorityColor(ticket.priority ?? ''),
                        ),
                      ],
                    ),
                    Gap(ScreenUtils.height10),
                    Text(
                      ticket.title ?? '',
                      style: bohibaTheme.textTheme.headlineSmall,
                    ),
                    Gap(ScreenUtils.height5),
                    _CategoryChip(label: ticket.category ?? ''),
                    Gap(ScreenUtils.height15),
                    _DetailRow(
                      icon: Remix.file_text_line,
                      label: 'Description',
                      value: ticket.description ?? '',
                    ),
                    if (ticket.remark != null && ticket.remark!.isNotEmpty) ...[
                      Gap(ScreenUtils.height10),
                      _DetailRow(
                        icon: Remix.chat_3_line,
                        label: 'Remark',
                        value: ticket.remark!,
                      ),
                    ],
                    Gap(ScreenUtils.height10),
                    _DetailRow(
                      icon: Remix.checkbox_circle_line,
                      label: 'Status',
                      value: ticket.status ?? '',
                      valueColor: ticket.isResolved
                          ? BohibaColors.successColor
                          : bohibaTheme.primaryColor,
                    ),
                    Gap(ScreenUtils.height10),
                    _DetailRow(
                      icon: Remix.calendar_line,
                      label: 'Created',
                      value: ticket.createdAt ?? "",
                    ),
                    if (ticket.resolvedAt != null) ...[
                      Gap(ScreenUtils.height10),
                      _DetailRow(
                        icon: Remix.check_double_line,
                        label: 'Resolved At',
                        value: ticket.resolvedAt!,
                        valueColor: BohibaColors.successColor,
                      ),
                    ],
                    Gap(ScreenUtils.height30),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'HIGH':
        return BohibaColors.warningColor;
      case 'MEDIUM':
        return BohibaColors.orange;
      default:
        return BohibaColors.successColor;
    }
  }
}

// ── Reusable atoms ────────────────────────────────────────────────────────────

class _UidChip extends StatelessWidget {
  final String uid;
  const _UidChip({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bohibaTheme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        uid,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: bohibaTheme.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool isResolved;
  const _StatusBadge({required this.label, required this.isResolved});

  @override
  Widget build(BuildContext context) {
    final Color color =
        isResolved ? BohibaColors.successColor : BohibaColors.orange;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bohibaTheme.dividerColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: bohibaTheme.textTheme.titleMedium?.color,
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final Color color;
  const _PriorityChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: bohibaTheme.primaryColor),
        Gap(ScreenUtils.width10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: bohibaTheme.textTheme.titleMedium,
              ),
              Gap(2.h),
              Text(
                value,
                style: bohibaTheme.textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── States ────────────────────────────────────────────────────────────────────

class _TicketSkeleton extends StatelessWidget {
  const _TicketSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(ScreenUtils.width15),
      itemCount: 5,
      separatorBuilder: (_, __) => Gap(ScreenUtils.height10),
      itemBuilder: (_, __) => Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: bohibaTheme.dividerColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Remix.customer_service_2_line,
            size: 64.r,
            color: bohibaTheme.dividerColor,
          ),
          Gap(ScreenUtils.height15),
          Text(
            'No Tickets Yet',
            style: bohibaTheme.textTheme.headlineSmall,
          ),
          Gap(ScreenUtils.height8),
          Text(
            'Tap the button below to report an issue',
            style: bohibaTheme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Remix.wifi_off_line,
              size: 56.r,
              color: bohibaTheme.dividerColor,
            ),
            Gap(ScreenUtils.height15),
            Text(
              message,
              style: bohibaTheme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Gap(ScreenUtils.height20),
            TextButton.icon(
              onPressed: onRetry,
              icon: Icon(Remix.refresh_line, size: 18.r),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/controllers/trip_controller.dart';
import '/dist/enums/enum_trip_status.dart';
import '/extensions/bohiba_extension.dart';
import '/extensions/ext_trip_status.dart';
import '/component/screen_utils.dart';
import '/pages/widget/linear_box_widget.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/status_box_widget.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicInfoSection extends StatefulWidget {
  final TripController controller;
  const BasicInfoSection({super.key, required this.controller});

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection> {
  // MenuController must be created once per widget lifetime — creating it
  // inline in build() causes a new instance each frame, breaking open/close state.
  final MenuController _menuController = MenuController();

  TripController get c => widget.controller;

  static const List<EnumTripStatus> _selectableStatuses = [
    EnumTripStatus.draft,
    EnumTripStatus.pending,
    EnumTripStatus.assigned,
    EnumTripStatus.scheduled,
    EnumTripStatus.inProgress,
    EnumTripStatus.completed,
    EnumTripStatus.delayed,
    EnumTripStatus.onHold,
    EnumTripStatus.cancelled,
    EnumTripStatus.aborted,
    EnumTripStatus.failed,
    EnumTripStatus.disputed,
    EnumTripStatus.closed,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtils.height15,
        right: ScreenUtils.height15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: ScreenUtils.height20),
            child: Text(
              'Basic Info',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          LinearBoxWidget(
            onClick: null,
            header: 'Trip Code',
            title: c.tripInfo.value?.tripCode,
          ),
          LinearBoxWidget(
            onClick: null,
            header: 'Transporter',
            widget: Expanded(
              child: Text(
                ' ${c.tripInfo.value?.transporter?.name} sjdfsdhkhkjh asjdhjkhdskj',
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                  color: bohibaTheme.textTheme.bodyLarge!.color,
                ),
              ),
            ),
          ),
          RoleWidget(
            truckOwnerWidget: LinearBoxWidget(
              onClick: null,
              header: 'TP No',
              title: c.tripInfo.value?.loadDetail?.tpNo?.toString() ?? '',
            ),
          ),
          RoleWidget(
            truckOwnerWidget: LinearBoxWidget(
              onClick: null,
              header: 'Driver',
              title: c.tripInfo.value?.driver?.name ?? 'No driver',
            ),
            driverWidget: LinearBoxWidget(
              onClick: null,
              header: 'Owner',
              title: c.tripInfo.value?.owner?.name,
            ),
          ),
          RoleWidget(
            driverWidget: StatusBoxWidget(
              header: 'Status',
              title: c.tripInfo.value?.tripStatus?.tripStatusName ?? '',
              statusColor: c.statusColor(),
            ),
            truckOwnerWidget: StatusBoxWidget(
              header: 'Status',
              title: c.tripInfo.value?.tripStatus?.tripStatusName ?? '',
              statusColor: c.statusColor(),
              widget: Obx(
                () => MenuAnchor(
                  controller: _menuController,
                  style: MenuStyle(
                    alignment: Alignment.bottomRight,
                    elevation: const WidgetStatePropertyAll(4),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtils.height10),
                      ),
                    ),
                    // Let the menu size to its content rather than fixed height.
                    maximumSize: WidgetStatePropertyAll(
                      Size(ScreenUtils.width * 0.55, 160.h),
                    ),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.zero,
                    ),
                  ),
                  menuChildren: _selectableStatuses.map((status) {
                    final bool isCurrent =
                        c.tripInfo.value?.tripStatus == status.value;
                    final Color dot = c.colorForStatus(status.value);
                    return MenuItemButton(
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
                        ),
                        minimumSize: WidgetStatePropertyAll(
                          Size(ScreenUtils.width * 0.36, 10.h),
                        ),
                        backgroundColor: isCurrent
                            ? WidgetStatePropertyAll(
                                dot.withValues(alpha: 0.12),
                              )
                            : null,
                      ),
                      leadingIcon: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: dot,
                          shape: BoxShape.circle,
                        ),
                      ),
                      trailingIcon: isCurrent
                          ? Icon(
                              Icons.check_rounded,
                              size: 14.sp,
                              color: dot,
                            )
                          : null,
                      onPressed: c.isUpdatingStatus.value
                          ? null
                          : () {
                              _menuController.close();
                              c.updateTripStatus(status);
                            },
                      child: Text(
                        status.name.toCapitalizedLabel(),
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                          fontWeight: isCurrent
                              ? bohibaTheme.textTheme.bodyLarge!.fontWeight
                              : bohibaTheme.textTheme.bodyMedium!.fontWeight,
                          color: bohibaTheme.textTheme.bodyLarge!.color,
                        ),
                      ),
                    );
                  }).toList(),
                  builder: (context, menuController, _) {
                    return Obx(
                      () => GestureDetector(
                        onTap: c.isUpdatingStatus.value
                            ? null
                            : () {
                                menuController.isOpen
                                    ? menuController.close()
                                    : menuController.open();
                              },
                        child: Container(
                          width: ScreenUtils.width * 0.32,
                          padding: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: c.isUpdatingStatus.value
                                ? c.statusColor().withValues(alpha: 0.45)
                                : c.statusColor(),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  c.tripInfo.value?.tripStatus
                                          ?.tripStatusName ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: bohibaTheme
                                        .textTheme.bodyMedium!.fontSize,
                                    fontWeight: bohibaTheme
                                        .textTheme.bodyLarge!.fontWeight,
                                    color: bohibaTheme
                                        .textTheme.displayLarge!.color,
                                  ),
                                ),
                              ),
                              c.isUpdatingStatus.value
                                  ? SizedBox(
                                      width: 14.w,
                                      height: 14.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: bohibaTheme
                                            .textTheme.displayLarge!.color,
                                      ),
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 18.sp,
                                      color: bohibaTheme
                                          .textTheme.displayLarge!.color,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

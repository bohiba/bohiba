import '/dist/app_enums.dart';
import '/services/global_service.dart';
import 'package:readmore/readmore.dart';

import '/extensions/bohiba_extension.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '/controllers/my_job_controller.dart';
import 'package:get/get.dart';
import '/routes/app_route.dart';

import '/component/screen_utils.dart';
import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/pages/widget/role_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MyJobDetailPage extends GetView<MyJobController> {
  const MyJobDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Manage Job',
        actions: [
          RoleWidget(
            truckOwnerWidget: AppBarIconBox(
              onTapDown: (p0) {
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        p0.globalPosition.dx, p0.globalPosition.dy + 20, 0, 0),
                    items: [
                      PopupMenuItem(
                        value: ActionType.edit,
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: ActionType.delete,
                        textStyle: TextStyle(
                          color: bohibaTheme.colorScheme.error,
                          fontStyle:
                              bohibaTheme.textTheme.titleMedium!.fontStyle,
                          fontWeight:
                              bohibaTheme.textTheme.titleMedium!.fontWeight,
                        ),
                        child: Text('Delete'),
                      ),
                    ]).then((onValue) {
                  switch (onValue) {
                    case ActionType.edit:
                      navigatorState.pushNamed(AppRoute.addJobs);
                      break;
                    case ActionType.delete:
                      GlobalService.showAlertDialog(
                        status: AlertStatus.warning,
                        title: 'Delete',
                        description: 'Do you want to delete the job post?',
                        discardBtnTxt: 'Delete',
                        saveBtnTxt: 'Cancel',
                        onSave: () {},
                      );
                      break;
                    default:
                      break;
                  }
                });
              },
              icon: const Icon(EvaIcons.moreVertical),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
              top: ScreenUtils.height10,
            ),
            child: Obx(() {
              if (controller.jobObj.isEmpty) {
                return SizedBox.shrink();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.jobObj['job_title'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: bohibaTheme.textTheme.headlineMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(EvaIcons.pin, size: 14.w),
                        Text(
                          " ${(controller.jobObj['location'] ?? '').toString().toUpperCase()}",
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.labelMedium!.fontWeight,
                            color: bohibaTheme.textTheme.titleLarge!.color,
                          ),
                        ),
                        Gap(10.w),
                        Icon(EvaIcons.briefcase, size: 14.w),
                        Text(
                          ' ${(controller.jobObj['job_type'] ?? '').toString().toUpperCase()}',
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.labelMedium!.fontWeight,
                            color: bohibaTheme.textTheme.titleLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    // Divider(),
                    LinearBoxWidget(
                      header: 'Status',
                      title: controller.jobObj['status']
                          .toString()
                          .toCapitalizedLabel(),
                    ),
                    LinearBoxWidget(
                      header: 'Truck Number',
                      title: controller.jobObj['regd_number']
                          .toString()
                          .toCapitalizedLabel(),
                    ),
                    LinearBoxWidget(
                      header: 'Last Updated',
                      title: controller.jobObj['updated_at'].toString(),
                    ),
                    LinearBoxWidget(
                      header: 'Created At',
                      title: controller.jobObj['created_at'].toString(),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: Text(
                        'Description',
                        style: bohibaTheme.textTheme.headlineMedium,
                      ),
                    ),
                    ReadMoreText(
                      controller.jobObj['description'].toString(),
                      trimLines: 5,
                      trimMode: TrimMode.Line,
                      style: bohibaTheme.textTheme.titleMedium,
                      moreStyle: TextStyle(color: bohibaTheme.primaryColor),
                      lessStyle: TextStyle(color: bohibaTheme.primaryColor),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Intreseted Drivers',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                          Text(
                            "See All",
                            style: TextStyle(
                              fontSize: bohibaTheme
                                  .textTheme.headlineMedium!.fontSize,
                              color: bohibaTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(EvaIcons.people),
                        Gap(10.w),
                        Text(
                            '${controller.arrIntDriver.length.toString()} Applicants')
                      ],
                    ),
                    Column(
                      children: List.generate(controller.arrIntDriver.length,
                          (index) {
                        Map intDriver = controller.arrIntDriver[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtils.height10),
                          margin: EdgeInsets.only(bottom: ScreenUtils.width5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: bohibaTheme.dividerColor,
                              ),
                              Gap(10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    intDriver['name'].toString(),
                                    style: TextStyle(
                                      fontSize: bohibaTheme
                                          .textTheme.bodyMedium!.fontSize,
                                      fontWeight: bohibaTheme
                                          .textTheme.bodySmall!.fontWeight,
                                      color: bohibaTheme
                                          .textTheme.titleMedium!.color,
                                    ),
                                  ),
                                  Text(
                                    intDriver['job_status']
                                        .toString()
                                        .toCapitalizedLabel(),
                                    style: TextStyle(
                                      fontSize: bohibaTheme
                                          .textTheme.titleMedium!.fontSize,
                                      fontWeight: bohibaTheme
                                          .textTheme.bodyMedium!.fontWeight,
                                      color: bohibaTheme
                                          .textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async =>
                                    await controller.makePhoneCall(
                                        intDriver['mobile_number'].toString()),
                                child: Container(
                                  height: 28.w,
                                  width: 28.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: bohibaTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.25),
                                  ),
                                  child: Icon(
                                    Icons.phone_sharp,
                                    size: 16.w,
                                    color: bohibaTheme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              Gap(10.w),
                              GestureDetector(
                                onTap: () {
                                  GlobalService.showAppToast(
                                      message: 'Mark as not interested');
                                },
                                child: Container(
                                  height: 28.w,
                                  width: 28.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: bohibaTheme.colorScheme.error
                                        .withValues(alpha: 0.25),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16.w,
                                    color: bohibaTheme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}

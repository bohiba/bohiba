import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/services/global_service.dart';
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
              return controller.jobObj.isEmpty
                  ? SizedBox.shrink()
                  : Column(
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
                                fontSize:
                                    bohibaTheme.textTheme.bodyLarge!.fontSize,
                                fontWeight: bohibaTheme
                                    .textTheme.labelMedium!.fontWeight,
                                color: bohibaTheme.textTheme.titleLarge!.color,
                              ),
                            ),
                            Gap(10.w),
                            Icon(EvaIcons.briefcase, size: 14.w),
                            Text(
                              ' ${(controller.jobObj['job_type'] ?? '').toString().toUpperCase()}',
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodyLarge!.fontSize,
                                fontWeight: bohibaTheme
                                    .textTheme.labelMedium!.fontWeight,
                                color: bohibaTheme.textTheme.titleLarge!.color,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
                          child: Row(
                            children: [
                              Icon(EvaIcons.people),
                              Gap(10.w),
                              Text(
                                  '${controller.arrIntDriver.length.toString()} Applicants')
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            height: ScreenUtils.height30,
                            decoration: BoxDecoration(
                              color: bohibaTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Applied Candidates',
                              style: TextStyle(
                                color:
                                    bohibaTheme.textTheme.displayLarge!.color,
                                fontSize:
                                    bohibaTheme.textTheme.titleMedium!.fontSize,
                                fontWeight: bohibaTheme
                                    .textTheme.labelLarge!.fontWeight,
                              ),
                            ),
                          ),
                        ),
                        Gap(25.h),
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
                        Gap(15.w),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize:
                                bohibaTheme.textTheme.headlineMedium!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.titleLarge!.fontWeight,
                            color: bohibaTheme.textTheme.titleMedium!.color,
                          ),
                        ),
                        ReadMoreText(
                          controller.jobObj['description'].toString(),
                          trimLines: 10,
                          trimMode: TrimMode.Line,
                        ),
                      ],
                    );
            }),
          ),
        ),
      ),
    );
  }
}

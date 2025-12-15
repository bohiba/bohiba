import '/component/bohiba_buttons/primary_button.dart';
import '/extensions/bohiba_extension.dart';
import '/model/job_detail_model.dart';
import '/services/launcher_service.dart';
import '/services/global_service.dart';
import '/dist/app_enums.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/job_controller.dart';
import '/routes/app_route.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/pages/widget/role_widget.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class JobDetailPage extends GetView<JobController> {
  const JobDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorState = Navigator.of(context);
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: 'Manage Job',
          popResult: controller.anyUpdate > 0 ? true : false,
          actions: [
            RoleWidget(
              truckOwnerWidget: AppBarIconBox(
                onTapDown: (p0) {
                  showMenu(context: context, position: RelativeRect.fromLTRB(p0.globalPosition.dx, p0.globalPosition.dy + 20, 0, 0), items: [
                    PopupMenuItem(
                      value: ActionType.edit,
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: ActionType.delete,
                      textStyle: TextStyle(
                        color: bohibaTheme.colorScheme.tertiary,
                        fontStyle: bohibaTheme.textTheme.titleMedium!.fontStyle,
                        fontWeight: bohibaTheme.textTheme.titleMedium!.fontWeight,
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
                          onSave: () {
                            navigatorState.pop();
                          },
                          onDiscard: () {
                            navigatorState.pop();
                            GlobalService.showAppToast(message: 'Under Development');
                          },
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
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
              top: ScreenUtils.height10,
            ),
            child: SmartRefresher(
              controller: controller.refreshController,
              onRefresh: () async {
                controller.ownerJobDetail();
                controller.refreshController.refreshCompleted();
              },
              child: SingleChildScrollView(
                child: (controller.jobDetailModel.value.id == null)
                    ? SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.jobDetailModel.value.jobTitle ?? '',
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
                                " ${(controller.jobDetailModel.value.location ?? '').toString().toUpperCase()}",
                                style: TextStyle(
                                  fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                                  fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                                  color: bohibaTheme.textTheme.titleLarge!.color,
                                ),
                              ),
                              Gap(10.w),
                              Icon(EvaIcons.briefcase, size: 14.w),
                              Text(
                                ' ${(controller.jobDetailModel.value.jobType ?? '').toString().toUpperCase()}',
                                style: TextStyle(
                                  fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                                  fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                                  color: bohibaTheme.textTheme.titleLarge!.color,
                                ),
                              ),
                            ],
                          ),
                          Gap(15.h),
                          RoleWidget(
                            driverWidget: PrimaryButton(
                              height: 40,
                              label: 'Apply',
                              onPressed: () async {
                                await controller.applyToJob();
                              },
                            ),
                          ),
                          RoleWidget(
                            driverWidget: LinearBoxWidget(
                              header: 'Status',
                              title: controller.jobDetailModel.value.status?.toCapitalizedLabel(),
                            ),
                            truckOwnerWidget: LinearBoxWidget(
                              header: 'Status',
                              widget: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: controller.statusItem.contains(controller.jobDetailModel.value.status) ? controller.jobDetailModel.value.status : null,
                                  isDense: true,
                                  borderRadius: BorderRadius.circular(8.0),
                                  items: controller.statusItem.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        e.toCapitalizedLabel(),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (status) async {
                                    if (status != null) {
                                      controller.jobStatus.value = status;
                                      await controller.updateJob();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          LinearBoxWidget(
                            header: 'Truck Number',
                            title: controller.jobDetailModel.value.regdNumber.toString().toUpperCase(),
                          ),
                          LinearBoxWidget(
                            header: 'Last Updated',
                            title: controller.jobDetailModel.value.updatedAt.toString(),
                          ),
                          LinearBoxWidget(
                            header: 'Created At',
                            title: controller.jobDetailModel.value.createdAt.toString(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: Text(
                              'Description',
                              style: bohibaTheme.textTheme.headlineMedium,
                            ),
                          ),
                          ReadMoreText(
                            controller.jobDetailModel.value.description.toString(),
                            trimLines: 5,
                            trimMode: TrimMode.Line,
                            style: bohibaTheme.textTheme.titleMedium,
                            moreStyle: TextStyle(color: bohibaTheme.primaryColor),
                            lessStyle: TextStyle(color: bohibaTheme.primaryColor),
                          ),
                          Gap(15.h),
                          RoleWidget(
                            truckOwnerWidget: Column(
                              children: [
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
                                      GestureDetector(
                                        onTap: () {
                                          navigatorState.pushNamed(
                                            AppRoute.allIntDriver,
                                            arguments: controller.jobDetailModel.value,
                                          );
                                        },
                                        child: Text(
                                          "See All",
                                          style: TextStyle(
                                            fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                                            color: bohibaTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [Icon(EvaIcons.people), Gap(10.w), Text('${controller.arrIntDriver.length.toString()} Applicants')],
                                ),
                              ],
                            ),
                          ),
                          RoleWidget(
                            truckOwnerWidget: (controller.arrIntDriver.isEmpty)
                                ? SizedBox.shrink()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.arrIntDriver.length,
                                    itemBuilder: (context, index) {
                                      InterestedDriver intDriver = controller.arrIntDriver[index];
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
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
                                                  intDriver.name.toString(),
                                                  style: TextStyle(
                                                    fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                                                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                                    color: bohibaTheme.textTheme.titleMedium!.color,
                                                  ),
                                                ),
                                                Text(
                                                  intDriver.jobStatus?.toString().toCapitalizedLabel() ?? '',
                                                  style: TextStyle(
                                                    fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                                                    fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                                                    color: bohibaTheme.textTheme.bodyMedium!.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () async => await LauncherService.makePhoneCall(intDriver.mobileNumber.toString()),
                                              child: Container(
                                                height: 28.w,
                                                width: 28.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.25),
                                                ),
                                                child: Icon(
                                                  Icons.phone_sharp,
                                                  size: 16.w,
                                                  color: bohibaTheme.colorScheme.onPrimary,
                                                ),
                                              ),
                                            ),
                                            /*Gap(10.w),
                                            GestureDetector(
                                              onTap: () {
                                                GlobalService.showAppToast(
                                                    message:
                                                        'Mark as not interested');
                                              },
                                              child: Container(
                                                height: 28.w,
                                                width: 28.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: bohibaTheme
                                                      .colorScheme.error
                                                      .withValues(alpha: 0.25),
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 16.w,
                                                  color: bohibaTheme
                                                      .colorScheme.error,
                                                ),
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

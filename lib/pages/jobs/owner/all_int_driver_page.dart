import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/controllers/all_int_driver_controller.dart';
import '/extensions/bohiba_extension.dart';
import '/model/job_detail_model.dart';
import '/services/launcher_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllIntDriverPage extends GetView<AllIntDriverController> {
  const AllIntDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: controller.jobDetail.value.jobTitle ?? '',
        ),
        body: SmartRefresher(
          controller: controller.refresPageController,
          onRefresh: () async {
            await controller.getAllApplicant();
            controller.refresPageController.refreshCompleted();
          },
          child: controller.arrIntDriver.isEmpty
              ? SizedBox(
                  width: ScreenUtils.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No applicant found',
                        style: bohibaTheme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.arrIntDriver.length,
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height10,
                    bottom: ScreenUtils.height5,
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                  ),
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
                                intDriver.name?.toString() ?? '',
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
      );
    });
  }
}

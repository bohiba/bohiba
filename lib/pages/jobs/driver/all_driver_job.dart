import '/component/app_skeleton_loader.dart';

import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/model/job_detail_model.dart';
import '/extensions/bohiba_extension.dart';

import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_appbar/title_appbar.dart';

import '/controllers/all_driver_job_controller.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllDriverJobPage extends GetView<AllDriverJobController> {
  const AllDriverJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        showLeading: false,
        title: 'Jobs',
        actions: [
          AppBarIconBox(
            icon: Icon(EvaIcons.personAddOutline),
            onTap: () {
              navigateState.pushNamed(AppRoute.allRcvdRequest);
            },
          )
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            InkWell(
              onTap: () {
                navigateState.pushNamed(AppRoute.allAppliedJob);
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: ScreenUtils.height10,
                  bottom: ScreenUtils.height10,
                ),
                margin: EdgeInsets.only(
                  top: ScreenUtils.height10,
                  left: ScreenUtils.height15,
                  right: ScreenUtils.height15,
                  bottom: ScreenUtils.height10,
                ),
                // color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Applied Jobs',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                        fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                        color: bohibaTheme.textTheme.bodyLarge!.color,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.w,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: (controller.arrJobDetail.value == null)
                  ? AppSkeletonLoader(skeletonLength: 3)
                  : SmartRefresher(
                      controller: controller.refreshController,
                      onRefresh: () {
                        controller.getAllJobs(refresh: true, showLoading: false);
                        controller.refreshController.refreshCompleted();
                      },
                      child: (controller.arrJobDetail.value!.isEmpty)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No Jobs Found',
                                  style: bohibaTheme.textTheme.displaySmall,
                                ),
                                Text(
                                  'Sorry for inconvience. We unable to find any job',
                                  textAlign: TextAlign.center,
                                  style: bohibaTheme.textTheme.titleMedium,
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(
                                left: ScreenUtils.height15,
                                right: ScreenUtils.height15,
                              ),
                              itemCount: (controller.arrJobDetail.value?.length ?? 0),
                              itemBuilder: (context, index) {
                                JobDetailModel? jobDetail = controller.arrJobDetail.value?[index];
                                return GestureDetector(
                                  onTap: () {
                                    navigateState.pushNamed(
                                      AppRoute.jobDetail,
                                      arguments: jobDetail,
                                    );
                                  },
                                  child: Container(
                                    width: ScreenUtils.width,
                                    padding: EdgeInsets.all(ScreenUtils.height15),
                                    margin: EdgeInsets.only(bottom: ScreenUtils.width5),
                                    decoration: TileDecorative(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: ScreenUtils.width * 0.7,
                                                  child: Text(
                                                    jobDetail?.jobTitle ?? '',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: bohibaTheme.textTheme.headlineMedium,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(EvaIcons.pin, size: 14.w),
                                                    Text(
                                                      ' ${jobDetail?.location?.toCapitalizedLabel() ?? ''} ',
                                                      style: TextStyle(
                                                        fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                                                        fontWeight: bohibaTheme.textTheme.titleLarge!.fontWeight,
                                                        color: bohibaTheme.textTheme.titleLarge!.color,
                                                      ),
                                                    ),
                                                    Gap(10.w),
                                                    Icon(EvaIcons.briefcase, size: 14.w),
                                                    Text(
                                                      ' ${jobDetail?.jobType?.toCapitalizedLabel() ?? ''}',
                                                      style: TextStyle(
                                                        fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                                                        fontWeight: bohibaTheme.textTheme.titleLarge!.fontWeight,
                                                        color: bohibaTheme.textTheme.titleLarge!.color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Text(
                                              jobDetail?.status?.toCapitalizedLabel() ?? '',
                                              style: TextStyle(
                                                fontFamily: bohibaTheme.textTheme.labelLarge!.fontFamily,
                                                fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(ScreenUtils.height5),
                                        Text(
                                          jobDetail?.createdAt ?? '',
                                          style: TextStyle(
                                            color: bohibaTheme.textTheme.titleMedium!.color,
                                            fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

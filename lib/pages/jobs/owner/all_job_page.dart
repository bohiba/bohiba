import '/model/job_detail_model.dart';
import '/controllers/all_job_controller.dart';
import '/dist/component_exports.dart';
import '/pages/widget/role_widget.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllJobPage extends GetView<AllJobController> {
  final bool showLeading;
  const AllJobPage({
    super.key,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final navigatorState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: 'All Jobs',
        showLeading: showLeading,
        actions: [
          RoleWidget(
            truckOwnerWidget: AppBarIconBox(
              onTap: () {
                navigatorState
                    .pushNamed(AppRoute.addJobs)
                    .then((onValue) async {
                  if (onValue != null && onValue != false) {
                    await controller.getAllJobs();
                  }
                });
              },
              icon: const Icon(EvaIcons.plus),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(
          () {
            return SmartRefresher(
              controller: controller.refreshController,
              onRefresh: () async => await controller.refreshPage(),
              child: controller.arrJobs.isEmpty
                  ? SizedBox(
                      width: ScreenUtils.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            controller.strTitle.value,
                            style: bohibaTheme.textTheme.displaySmall,
                          ),
                          Text(
                            controller.strSubTitle.value,
                            style: bohibaTheme.textTheme.titleLarge,
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: ScreenUtils.height15,
                        right: ScreenUtils.height15,
                        top: ScreenUtils.height10,
                      ),
                      itemCount: controller.arrJobs.length,
                      itemBuilder: (context, index) {
                        JobDetailModel job = controller.arrJobs[index];
                        return GestureDetector(
                          onTap: () {
                            navigatorState
                                .pushNamed(AppRoute.jobDetail, arguments: job)
                                .then((onValue) async {
                              if (onValue != null && onValue != false) {
                                await controller.getAllJobs();
                              }
                            });
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: ScreenUtils.width * 0.7,
                                          child: Text(
                                            job.jobTitle ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: bohibaTheme
                                                .textTheme.headlineMedium,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(EvaIcons.pin, size: 14.w),
                                            Text(
                                              " ${job.location?.toString().toUpperCase() ?? ''}",
                                              style: TextStyle(
                                                fontSize: bohibaTheme.textTheme
                                                    .bodyLarge!.fontSize,
                                                fontWeight: bohibaTheme
                                                    .textTheme
                                                    .labelMedium!
                                                    .fontWeight,
                                                color: bohibaTheme.textTheme
                                                    .titleLarge!.color,
                                              ),
                                            ),
                                            Gap(10.w),
                                            Icon(EvaIcons.briefcase,
                                                size: 14.w),
                                            Text(
                                              ' ${job.jobType?.toString().toUpperCase() ?? ''}',
                                              style: TextStyle(
                                                fontSize: bohibaTheme.textTheme
                                                    .bodyLarge!.fontSize,
                                                fontWeight: bohibaTheme
                                                    .textTheme
                                                    .labelMedium!
                                                    .fontWeight,
                                                color: bohibaTheme.textTheme
                                                    .titleLarge!.color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      job.status?.toString().capitalizeFirst ??
                                          '',
                                      style: TextStyle(
                                        fontFamily: bohibaTheme
                                            .textTheme.labelLarge!.fontFamily,
                                        fontSize: bohibaTheme
                                            .textTheme.labelLarge!.fontSize,
                                        color: controller.statusColor(
                                          status: job.status.toString(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Gap(ScreenUtils.height5),
                                Text(
                                  job.createdAt ?? '',
                                  style: TextStyle(
                                    color: bohibaTheme
                                        .textTheme.titleMedium!.color,
                                    fontSize: bohibaTheme
                                        .textTheme.labelMedium!.fontSize,
                                  ),
                                )
                                /*Gap(ScreenUtils.height10),
                                ReadMoreText(
                                  job['description'],
                                  trimLines: 1,
                                  style: TextStyle(
                                    fontSize: bohibaTheme
                                        .textTheme.labelLarge!.fontSize,
                                    fontWeight: bohibaTheme
                                        .textTheme.labelMedium!.fontWeight,
                                    color:
                                        bohibaTheme.textTheme.labelMedium!.color,
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}

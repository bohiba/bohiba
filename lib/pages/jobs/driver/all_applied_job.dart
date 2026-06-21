import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remixicon/remixicon.dart';

import '/extensions/bohiba_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/controllers/all_applied_job_controller.dart';
import '/model/job_detail_model.dart';
import '/theme/bohiba_theme.dart';

import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllAppliedJobPage extends GetView<AllAppliedJobController> {
  const AllAppliedJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Applied Jobs',
      ),
      body: Obx(
        () {
          RefreshController refreshController = RefreshController();
          return SmartRefresher(
            controller: refreshController,
            onRefresh: () {
              controller.getAppliedJobs(refresh: true);
              refreshController.refreshCompleted();
            },
            child: controller.arrAppliedJob.isEmpty
                ? SizedBox(
                    width: ScreenUtils.width * 0.65,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.strHeaderMsg.value,
                          style: bohibaTheme.textTheme.headlineLarge,
                        ),
                        Text(
                          controller.strDescription.value,
                          textAlign: TextAlign.center,
                          style: bohibaTheme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(
                      left: ScreenUtils.height15,
                      right: ScreenUtils.height15,
                      top: ScreenUtils.height10,
                    ),
                    itemCount: controller.arrAppliedJob.length,
                    itemBuilder: (context, index) {
                      JobDetailModel jobDetail =
                          controller.arrAppliedJob[index];
                      return GestureDetector(
                        onTap: () {},
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: ScreenUtils.width * 0.7,
                                        child: Text(
                                          jobDetail.jobTitle ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: bohibaTheme
                                              .textTheme.headlineMedium,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FaIcon(FontAwesomeIcons.plus,
                                              size: 14.w),
                                          Text(
                                            ' ${jobDetail.location?.toCapitalizedLabel() ?? ''} ',
                                            style: TextStyle(
                                              fontSize: bohibaTheme.textTheme
                                                  .labelLarge!.fontSize,
                                              fontWeight: bohibaTheme.textTheme
                                                  .titleLarge!.fontWeight,
                                              color: bohibaTheme
                                                  .textTheme.titleLarge!.color,
                                            ),
                                          ),
                                          Gap(10.w),
                                          Icon(Remix.briefcase_2_fill,
                                              size: 14.w),
                                          Text(
                                            ' ${jobDetail.jobType?.toCapitalizedLabel() ?? ''}',
                                            style: TextStyle(
                                              fontSize: bohibaTheme.textTheme
                                                  .labelLarge!.fontSize,
                                              fontWeight: bohibaTheme.textTheme
                                                  .titleLarge!.fontWeight,
                                              color: bohibaTheme
                                                  .textTheme.titleLarge!.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    jobDetail.status?.toCapitalizedLabel() ??
                                        '',
                                    style: TextStyle(
                                      fontFamily: bohibaTheme
                                          .textTheme.labelLarge!.fontFamily,
                                      fontSize: bohibaTheme
                                          .textTheme.labelLarge!.fontSize,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(ScreenUtils.height5),
                              Text(
                                jobDetail.createdAt ?? '',
                                style: TextStyle(
                                  color:
                                      bohibaTheme.textTheme.titleMedium!.color,
                                  fontSize: bohibaTheme
                                      .textTheme.labelMedium!.fontSize,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

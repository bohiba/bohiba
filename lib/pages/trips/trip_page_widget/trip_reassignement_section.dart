import 'package:bohiba/controllers/trip_controller.dart';
import 'package:bohiba/dist/enums/app_enums.dart';
import 'package:bohiba/routes/app_route.dart';

import '/component/screen_utils.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:remixicon/remixicon.dart';

class TripReassignmentSection extends StatelessWidget {
  final TripController controller;
  // final List<Reassignment>? reassignments;
  // final void Function(Reassignment reassignment)? onReassignTap;
  const TripReassignmentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    final List<Reassignment>? reassignments =
        controller.tripInfo.value?.reassignment;
    if (reassignments?.isEmpty ?? true) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
          ),
          child: Text(
            'Reassignment',
            style: bohibaTheme.textTheme.headlineMedium,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          itemCount: reassignments?.length ?? 0,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            final Reassignment reassignment = reassignments![index];
            return InkWell(
              onTap: () {
                navigatorState
                    .pushNamed(
                  AppRoute.addReassignment,
                  arguments: reassignment,
                )
                    .then(
                  (onValue) async {
                    if (onValue != null && (onValue != false)) {
                      await controller.getTripInfo(
                        methodType: MethodType.api,
                        id: controller.tripInfo.value!.id!,
                      );
                    }
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtils.height10,
                ),
                width: ScreenUtils.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: bohibaTheme.colorScheme.onSurface,
                      child: Icon(Remix.truck_line),
                    ),
                    Gap(ScreenUtils.height15),
                    SizedBox(
                      width: ScreenUtils.width * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reassignment.regdNumber ?? '',
                            maxLines: 1,
                            style: bohibaTheme.textTheme.bodyMedium,
                          ),
                          ReadMoreText(
                            reassignment.reason?.toCapitalizedLabel() ?? '',
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' Read more',
                            trimExpandedText: ' Show less',
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.labelMedium!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleMedium!.color,
                            ),
                            moreStyle: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.labelMedium!.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            lessStyle: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.labelMedium!.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

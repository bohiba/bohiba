import 'package:gap/gap.dart';

import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_progress_tracker/progress_tracker.dart';
import 'package:flutter/material.dart';

class CompanyQueueStatus extends StatelessWidget {
  final int currentIndex;
  const CompanyQueueStatus({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtils.height20,
          right: ScreenUtils.width15,
          left: ScreenUtils.width15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: bohibaTheme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: ScreenUtils.height15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR CURRENT STATUS',
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              ProgressTracker(currentIndex: 2, statusList: [
                Status(name: 'ARRIVED', active: true),
                Status(name: 'ENTERED', active: true),
                Status(name: 'LOADING', active: false),
                Status(name: 'LOADED', active: false),
                Status(name: 'EXIT', active: false),
              ]),
              Gap(ScreenUtils.height15),
              PrimaryButton(
                padding: EdgeInsets.symmetric(vertical: ScreenUtils.height15),
                onPressed: () async {},
                label: 'MARK AS ARRIVED',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

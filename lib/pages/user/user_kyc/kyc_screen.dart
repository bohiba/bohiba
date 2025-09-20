import '/component/screen_utils.dart';
import '/controllers/dashboard_controller.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/component/bohiba_appbar/title_appbar.dart';

class KYCScreen extends GetView<DashboardController> {
  const KYCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppbar(title: "Documents"),
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtils.height20,
          right: ScreenUtils.width15,
          left: ScreenUtils.width15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Basic Info",
              style: bohibaTheme.textTheme.headlineMedium,
            ),
            LinearBoxWidget(
              header: 'Aadhar Number',
              title:
                  controller.profileModel.value?.verification?.aadhaarNumber ??
                      'NA',
            ),
            LinearBoxWidget(
              header: 'Pan Number',
              title: controller.profileModel.value?.verification?.panNumber ??
                  'NA',
            ),
            LinearBoxWidget(
              header: 'DL Number',
              title:
                  controller.profileModel.value?.verification?.dlNumber ?? 'NA',
            ),
            LinearBoxWidget(
              header: 'Verification Status',
              title: controller
                      .profileModel.value?.verification?.verificationStatus!
                      .toUpperCase() ??
                  'NA',
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: Material(
        child: Container(
            height: height * 0.1,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            alignment: Alignment.center,
            child: BottomNavButton(
              label: "Update Document",
              onPressed: () {},
            )),
      ),*/
    );
  }
}

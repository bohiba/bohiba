import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

import '/controllers/all_sent_connection_controller.dart';
import '/model/driver_model.dart';
import 'package:get/get.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/pages/driver/open_driver_tile.dart';
import 'package:flutter/material.dart';

class AllSentRequestPage extends GetView<AllSentRequestController> {
  const AllSentRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(title: 'Sent Request'),
      body: Obx(() {
        if (controller.arrSentReq.isEmpty) {
          return SizedBox(
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
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.only(
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
              top: ScreenUtils.height10,
            ),
            itemCount: controller.arrSentReq.length,
            itemBuilder: (context, index) {
              DriverModel openDriver = controller.arrSentReq[index];
              return OpenDriverTile(
                openDriver: openDriver,
                onTap: () {
                  navigateState
                      .pushNamed(AppRoute.openDriver, arguments: openDriver)
                      .then((onValue) async {
                    if (onValue != null && onValue != false) {
                      await controller.getAllOpenDriver();
                    }
                  });
                },
              );
            },
          );
        }
      }),
    );
  }
}

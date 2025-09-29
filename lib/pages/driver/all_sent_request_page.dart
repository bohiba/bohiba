import 'package:bohiba/theme/bohiba_theme.dart';

import '/controllers/all_sent_connection_controller.dart';
import '/model/open_driver_model.dart';
import 'package:get/get.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/pages/driver/open_driver_tile.dart';
import 'package:flutter/material.dart';

class AllSentRequestPage extends GetView<AllSentRequestController> {
  const AllSentRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Sent Connection'),
      body: Obx(() {
        if (controller.arrSentReq.isEmpty) {
          return SizedBox(
            width: ScreenUtils.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Request Found',
                  style: bohibaTheme.textTheme.headlineLarge,
                ),
                Text(
                  'Start sending connection request and connect with driver to boost you business',
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
              OpenDriverModel openDriver = controller.arrSentReq[index];
              return OpenDriverTile(
                openDriver: openDriver,
              );
            },
          );
        }
      }),
    );
  }
}

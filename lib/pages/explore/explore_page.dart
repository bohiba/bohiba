import '/pages/driver/open_driver_tile.dart';

import '/model/open_driver_model.dart';
import '/controllers/open_driver_list_controller.dart';
import 'package:get/get.dart';

import '/dist/component_exports.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '/component/bohiba_appbar/explore_appbar.dart';

class ExplorePage extends GetView<OpenDriverListController> {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExploreAppBar(
        title: 'Explore',
        actions: [
          AppBarIconBox(
            onTap: () {
              // showSearch(
              //   context: context,
              //   delegate: BohibaSearchDelegate(),
              // );
            },
            icon: Icon(EvaIcons.searchOutline),
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.only(
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
            top: ScreenUtils.height10,
          ),
          itemCount: controller.arrOpenDriver.length,
          itemBuilder: (context, index) {
            OpenDriverModel openDriver = controller.arrOpenDriver[index];
            return OpenDriverTile(
              openDriver: openDriver,
              onPressConnect: () async =>
                  await controller.expressIntrest(driverUuid: openDriver.uuid!),
            );
          },
        );
      }),
    );
  }
}

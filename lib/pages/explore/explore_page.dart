import '/pages/driver/open_driver_tile.dart';
import '/model/open_driver_model.dart';
import '/controllers/open_driver_controller.dart';
import 'package:get/get.dart';

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '/component/bohiba_appbar/explore_appbar.dart';

class ExplorePage extends GetView<OpenDriverController> {
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
            return OpenDriverTile(openDriver: openDriver);
          },
        );
      }),
    );
  }
}

class JobTypeTile extends StatelessWidget {
  final String header;
  const JobTypeTile({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                header,
                style: headerTextStyle(),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(ScreenUtils.width5),
                child: Text("See All", style: linkTextStyle()),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: ScreenUtils.height25),
            alignment: Alignment.center,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  height: 57,
                  width: ScreenUtils.width,
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(color: BohibaColors.tileColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle headerTextStyle() {
  return bohibaTheme.textTheme.titleLarge ?? TextStyle();
}

TextStyle linkTextStyle() {
  return TextStyle(
    fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
    color: BohibaColors.primaryColor,
  );
}

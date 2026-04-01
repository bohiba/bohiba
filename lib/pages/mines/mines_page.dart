import '/controllers/mines_controller.dart';
import '/dist/component_exports.dart';
import '/extensions/ext_mines_status.dart';

import '/component/bohiba_appbar/company_appbar.dart';
import '/component/bohiba_buttons/primary_floating_button.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'mines_status_grid.dart';
import 'mines_queue_status.dart';
import 'mines_header.dart';
import 'mines_live_queue_status.dart';
import 'mines_location.dart';

class MinesPage extends GetView<MinesController> {
  const MinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: CompanyAppBar(
          title: controller.minesModel.value.nameCode ?? 'NA',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: PrimaryFloatingButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              shape: BottomModalShape(),
              context: context,
              builder: (context) {
                return MinesQueueStatus();
              },
            );
          },
          heroTag: 'set_your_queue',
          label: 'SET YOUR QUEUE',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height20,
                right: ScreenUtils.width15,
                left: ScreenUtils.width15,
                bottom: ScreenUtils.height * 0.1,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MinesHeader(minesModel: controller.minesModel.value),
                  MinesStatusGrid(
                    mineOutsideInfo: [
                      StatusModel(name: "TOTAL TRUCKS", value: "42"),
                      StatusModel(name: "AVG WAITING", value: "32m"),
                      StatusModel(name: "STATUS", value: controller.minesModel.value.status?.minesStatusName ?? ''),
                    ],
                  ),
                  MinesLocation(),
                  MinesLiveQueueStatus(
                    header: [
                      QueueHeader(flex: 1, name: "#", textAlign: TextAlign.start),
                      QueueHeader(flex: 3, name: "VEHICLE ID", textAlign: TextAlign.start),
                      QueueHeader(flex: 3, name: "STATUS", textAlign: TextAlign.center),
                      QueueHeader(flex: 2, name: "WAIT", textAlign: TextAlign.center),
                    ],
                    queueList: [
                      QueueStatusList(
                        id: 1,
                        vechileId: 'OD14AC5857',
                        status: 4,
                        watingTime: '43',
                      ),
                      QueueStatusList(
                        id: 2,
                        vechileId: 'OD14X7724',
                        status: 1,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 3,
                        vechileId: 'OD14X7724',
                        status: 3,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 4,
                        vechileId: 'OD14X7724',
                        status: 2,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 5,
                        vechileId: 'OD14X7724',
                        status: 1,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 6,
                        vechileId: 'OD14X7724',
                        status: 1,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 7,
                        vechileId: 'OD14X7724',
                        status: 3,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 8,
                        vechileId: 'OD14X7724',
                        status: 2,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 9,
                        vechileId: 'OD14X7724',
                        status: 1,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 10,
                        vechileId: 'OD14X7724',
                        status: 2,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 11,
                        vechileId: 'OD14X7724',
                        status: 3,
                        watingTime: '42',
                      ),
                      QueueStatusList(
                        id: 12,
                        vechileId: 'OD14X7724',
                        status: 3,
                        watingTime: '42',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class StatusModel {
  String? name;
  String? value;

  StatusModel({this.name, this.value});
}

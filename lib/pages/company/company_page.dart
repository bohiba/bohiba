import '/controllers/mines_controller.dart';
import '/dist/component_exports.dart';
import '/extensions/ext_mines_status.dart';

import '/component/bohiba_appbar/company_appbar.dart';
import '/component/bohiba_buttons/primary_floating_button.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'company_queue_status.dart';
import 'company_status_grid.dart';
import 'company_header.dart';
import 'company_live_queue_status.dart';
import 'company_location.dart';

class CompanyPage extends GetView<MinesController> {
  const CompanyPage({super.key});

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
            // SELECT VEHICLE AND SET QUEUE STATUS
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              shape: BottomModalShape(),
              context: context,
              builder: (context) {
                return CompanyQueueStatus(currentIndex: 2);
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
                  CompanyHeader(
                    minesModel: controller.minesModel.value,
                  ),
                  CompanyStatusGrid(
                    mineOutsideInfo: [
                      StatusModel(
                        name: "TOTAL TRUCKS",
                        value: "42",
                      ),
                      StatusModel(
                        name: "AVG WAITING",
                        value: "32m",
                      ),
                      StatusModel(
                        name: "STATUS",
                        value: controller.minesModel.value.status ?? '',
                        color: controller
                            .minesModel.value.status?.minesStatusColor,
                      ),
                    ],
                  ),
                  CompanyLocation(),
                  CompanyLiveQueueStatus(
                    header: [
                      QueueHeader(
                          flex: 1, name: "#", textAlign: TextAlign.start),
                      QueueHeader(
                          flex: 3,
                          name: "VEHICLE ID",
                          textAlign: TextAlign.start),
                      QueueHeader(
                          flex: 3, name: "STATUS", textAlign: TextAlign.center),
                      QueueHeader(
                          flex: 2, name: "WAIT", textAlign: TextAlign.center),
                    ],
                    queueList: controller.arrQueue,
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
  Color? color;
  StatusModel({this.name, this.value, this.color});
}

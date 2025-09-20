import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import '/pages/status/tabs/tab_widget/row_text.dart';

import '../../../../../challan/component/load_details_component/load_details_component.dart';
import '../../../../../challan/component/transporter_detail_component/transporter_detail_component.dart';
import '../../../../../challan/component/vehicle_detail_component/vehicle_detail_component.dart';
import '../../../../../../component/bohiba_appbar/tab_appbar.dart';

class ChallanScreen extends StatelessWidget {
  const ChallanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height10,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VehicleDetailComponent(),
              DateTimeComponent(),
              Divider(),
              TransporterDetail(),
              Divider(),
              LoadDetailsComponent(),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimeComponent extends StatelessWidget {
  const DateTimeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding:
          EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowText(
                  mainLabel: "Date: ",
                  subLabel: "12-06-2023",
                ),
                RowText(
                  mainLabel: "Time: ",
                  subLabel: "12:05:00 PM",
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowText(mainLabel: "Dio Number: ", subLabel: "128"),
                RowText(mainLabel: "Challan Number: ", subLabel: "128"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:bohiba/pages/challan/component/load_details_component/load_details_component.dart';
import 'package:bohiba/pages/challan/component/transporter_detail_component/transporter_detail_component.dart';
import 'package:bohiba/pages/challan/component/vehicle_detail_component/vehicle_detail_component.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/pages/status/tabs/tab_widget/row_text.dart';

import '../../../utils/bohiba_appbar/tab_appbar.dart';

class ChallanScreen extends StatelessWidget {
  const ChallanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TabAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.0),
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
  const DateTimeComponent({Key? key}) : super(key: key);

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

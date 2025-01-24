import 'package:flutter/material.dart';
import 'package:bohiba/pages/status/tabs/tab_widget/row_text.dart';

class DriverDetailTile extends StatelessWidget {
  const DriverDetailTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 75,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "driverName",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const RowText(
            mainLabel: "DL Number: ",
            subLabel: "9876-9809-09-9022",
          ),
          const RowText(
            mainLabel: "Mobile Number: ",
            subLabel: "+91- 000 000 0000",
          ),
        ],
      ),
    );
  }
}

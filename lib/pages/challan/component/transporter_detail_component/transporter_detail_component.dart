import 'package:flutter/material.dart';
import 'package:bohiba/pages/status/tabs/tab_widget/column_text.dart';
import 'package:bohiba/pages/status/tabs/tab_widget/row_text.dart';

class TransporterDetail extends StatelessWidget {
  const TransporterDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transporter Detail",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RowText(
                        mainLabel: "Transporter Name",
                      ),
                      RowText(
                        subLabel: "Bohiba",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RowText(
                        mainLabel: "License Name",
                      ),
                      RowText(subLabel: "Shyam Metallics and Energy Ltd"),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ColumnText(
                    mainLabel: "Transporter Number",
                    subLabel: "L12202105/167",
                  ),
                ),
                Expanded(
                  child: ColumnText(
                      mainLabel: "License Number", subLabel: "L12202105/167"),
                )
              ],
            ),
          ),
          const ColumnText(
            mainLabel: "GSTIN",
            subLabel: "AA21TRV213MSKTY",
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:bohiba/pages/status/tabs/tab_widget/column_text.dart';
import 'package:bohiba/pages/status/tabs/tab_widget/row_text.dart';

class LoadDetailsComponent extends StatelessWidget {
  const LoadDetailsComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Load Details",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ColumnText(
                  mainLabel: "Mineral Type: ",
                  subLabel: "Iron",
                )),
                Expanded(
                    child: ColumnText(
                  mainLabel: "Mineral Grade: ",
                  subLabel: "42.50",
                ))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ColumnText(
                  mainLabel: "Source",
                  subLabel: "O.M.C. Ltd, Kurmitar Pahar",
                )),
                Expanded(
                    child: ColumnText(
                  mainLabel: "Destination",
                  subLabel:
                      "Shyam Metalics and Energy Ltd,PANDOLI,LAPANGA,SAMBALPUR,ODISHA.  ROUTE:BARSUAN-KOLAIPOSH-RAJAMUNDA-R",
                ))
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
                  mainLabel: "Gross Weight",
                  subLabel: "35.00 Tonne",
                )),
                Expanded(
                    child: ColumnText(
                  mainLabel: "Tar Weight",
                  subLabel: "11.520 Tonne",
                )),
                Expanded(
                    child: ColumnText(
                  mainLabel: "Net Weight",
                  subLabel: "23.480 Tonne",
                ))
              ],
            ),
          ),
          const RowText(
            mainLabel: "Weight Shortage:  ",
            subLabel: "01.00 Tonne",
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:bohiba/pages/status/tabs/tab_widget/row_text.dart';

class VehicleDetailComponent extends StatelessWidget {
  const VehicleDetailComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "OD 14X 7224",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RowText(
                      mainLabel: "Driver Name ",
                    ),
                    RowText(
                      subLabel: "Rama Govinda Shyam",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RowText(
                      mainLabel: "DL Number",
                    ),
                    RowText(
                      subLabel: "RPM762FD",
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

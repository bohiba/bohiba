import 'package:flutter/material.dart';

import '../../../component/bohiba_inputfield/text_inputfield.dart';
import '../../../component/bohiba_colors.dart';

class VehicleDetailsComponent extends StatelessWidget {
  const VehicleDetailsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vehicle Details",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const TextInputField(
            hintText: "Vehicle Number",
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Only vehicle nearby to destination and available can be booked*",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: BohibaColors.warningColor,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const TextInputField(
            hintText: "Mangal Kishore Mahanta",
            readOnly: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.45,
                child: const TextInputField(
                  readOnly: true,
                  hintText: "16 wheeler",
                ),
              ),
              SizedBox(
                width: width * 0.45,
                child: const TextInputField(
                  hintText: "000 000 0000",
                  readOnly: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

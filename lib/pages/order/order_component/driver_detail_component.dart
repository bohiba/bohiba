import 'package:flutter/material.dart';

import '../../../component/bohiba_inputfield/text_inputfield.dart';
import '../../../component/bohiba_colors.dart';

class DriverDetailComponent extends StatelessWidget {
  const DriverDetailComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Driver Details",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const TextInputField(
            hintText: "DL",
          ),
          const TextInputField(
            hintText: "Sanjay Kumar Iftab Raj Kishore",
          ),
          const TextInputField(
            hintText: "000 000 0000",
            keyboardType: TextInputType.number,
          ),
          Container(
            color: bohibaColors.primaryVariantColor,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Text(
                'Once we confirm your order, we will send an OTP (One-Time Password) to your registered number and your driver\'s mobile number.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    color: bohibaColors.white)),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../component/bohiba_dropdown/bohiba_dropdown.dart';
import '../../../component/bohiba_inputfield/text_inputfield.dart';

class FromToDetailsComponent extends StatelessWidget {
  final bool fromReadOnly;

  const FromToDetailsComponent({super.key, this.fromReadOnly = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Details",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.45,
              child: TextInputField(
                readOnly: fromReadOnly,
                hintText: "OMC, Rungta",
              ),
            ),
            SizedBox(
              width: width * 0.45,
              child: const TextInputField(
                hintText: "To",
              ),
            ),
          ],
        ),
        BohibaDropDown(
          hint: "Material Type",
          items: const [
            "Material Type-1",
            "Material Type-2",
            "Material Type-3",
            "Material Type-4",
            "Material Type-5"
          ],
        ),
      ],
    );
  }
}

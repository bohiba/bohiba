import 'package:flutter/material.dart';

class ColumnText extends StatelessWidget {
  final String mainLabel;
  final String subLabel;
  const ColumnText({
    Key? key,
    this.mainLabel = "",
    this.subLabel = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(mainLabel,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400
            )
        ),
        Text(subLabel,
            style: Theme.of(context).textTheme.labelMedium
        )
      ],
    );
  }
}

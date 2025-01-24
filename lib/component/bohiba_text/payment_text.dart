import 'package:flutter/material.dart';

class PaymentText extends StatelessWidget {
  final String leading;
  final String trailing;
  final Color? trailingColor;
  const PaymentText({
    super.key,
    this.leading = "",
    this.trailing = "",
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(leading, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            trailing,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                letterSpacing:
                    Theme.of(context).textTheme.labelSmall!.letterSpacing,
                fontWeight:
                    Theme.of(context).textTheme.displaySmall!.fontWeight,
                color: trailingColor),
          ),
        ],
      ),
    );
  }
}

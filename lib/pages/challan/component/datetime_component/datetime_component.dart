import 'package:flutter/material.dart';

class DateTimeComponent extends StatelessWidget {
  const DateTimeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '06:17 AM',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            '26-11-2022',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}

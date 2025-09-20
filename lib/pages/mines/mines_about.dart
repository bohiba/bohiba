import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class CompanyAboutSection extends StatelessWidget {
  const CompanyAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'About Company',
          style: bohibaTheme.textTheme.labelMedium,
        ),
      ],
    );
  }
}

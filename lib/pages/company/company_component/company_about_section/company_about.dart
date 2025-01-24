import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';

import '../../company_string/company_string.dart';

class CompanyAboutSection extends StatelessWidget {
  const CompanyAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          CompanyScreenString.aboutCompany,
          style: bohibaTheme.textTheme.labelMedium,
        ),
      ],
    );
  }
}

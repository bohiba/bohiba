import 'package:flutter/material.dart';

import '../../company_string/company_string.dart';

class CompanyAboutSection extends StatelessWidget {
  const CompanyAboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          CompanyScreenString.aboutCompany,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

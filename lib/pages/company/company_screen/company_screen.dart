import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_appbar/company_appbar.dart';
import 'package:bohiba/pages/company/company_component/company_trip_price/consignee_detail.dart';
import 'package:gap/gap.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _Companypagestate();
}

class _Companypagestate extends State<CompanyScreen> {
  bool favorite = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CompanyAppBar(title: "Consignee Name"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: BohibaResponsiveScreen.width20),
            child: Text(
              "Vehicle Entry Point",
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                fontWeight: bohibaTheme.textTheme.headlineMedium!.fontWeight,
                // color: bohibaTheme.textTheme.bodySmall!.color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: BohibaResponsiveScreen.width20),
            child: Text(
              "Plot No. 25, Gate no: 2, Industrial Area, Sundergarh, Odisha, 770001, +91 1234567890",
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                color: bohibaTheme.textTheme.titleLarge!.color,
              ),
            ),
          ),
          Gap(BohibaResponsiveScreen.height20),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: BohibaResponsiveScreen.width20),
            child: Text(
              "Available Load",
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                fontWeight: bohibaTheme.textTheme.headlineMedium!.fontWeight,
                // color: bohibaTheme.textTheme.bodySmall!.color,
              ),
            ),
          ),
          const ConsigneeDetails(consigneeDetails: [])
        ],
      ),
    );
  }
}

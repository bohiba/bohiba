import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_appbar/company_appbar.dart';
import 'package:bohiba/pages/company/company_component/company_trip_price/consignee_detail.dart';
import 'package:gap/gap.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

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
            padding: EdgeInsets.only(
              left: BohibaResponsiveScreen.width15,
              right: BohibaResponsiveScreen.width15,
              top: BohibaResponsiveScreen.height10,
            ),
            child: Text(
              "Vehicle Entry Point",
              style: bohibaTheme.textTheme.headlineLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: BohibaResponsiveScreen.width15),
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
                horizontal: BohibaResponsiveScreen.width15),
            child: Text(
              "Available Load",
              style: bohibaTheme.textTheme.headlineLarge,
            ),
          ),
          const ConsigneeDetails(consigneeDetails: [])
        ],
      ),
    );
  }
}

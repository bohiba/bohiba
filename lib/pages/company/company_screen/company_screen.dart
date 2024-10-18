import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_appbar/company_appbar.dart';
import 'package:bohiba/pages/company/company_component/company_bottombar/company_bottom_bar.dart';
import 'package:bohiba/pages/company/company_component/company_trip_price/consignee_detail.dart';
import 'package:bohiba/pages/load_history/load_history_screen/load_history_screen.dart';
import 'package:get/get.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _Companypagestate();
}

class _Companypagestate extends State<CompanyScreen> {
  bool favorite = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CompanyAppBar(title: "Consignee Name"),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: BohibaResponsiveScreen.width20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(top: BohibaResponsiveScreen.height10),
            child: Text(
              "Company Name",
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                color: bohibaTheme.textTheme.bodySmall!.color,
              ),
            ),
          ),
          Text(
            "Rungta Mines Private Limited",
            style: TextStyle(
              fontSize: bohibaTheme.textTheme.headlineSmall!.fontSize,
              fontWeight: bohibaTheme.textTheme.headlineMedium!.fontWeight,
              color: bohibaTheme.textTheme.headlineMedium!.color,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: BohibaResponsiveScreen.height20),
            child: Text(
              "Location",
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                color: bohibaTheme.textTheme.bodySmall!.color,
              ),
            ),
          ),
          Text(
            "Plot No. 25, Gate no: 2, Industrial Area, Sundergarh, Odisha, 770001, +91 1234567890",
            style: TextStyle(
              fontSize: bohibaTheme.textTheme.headlineSmall!.fontSize,
              fontWeight: bohibaTheme.textTheme.headlineMedium!.fontWeight,
              color: bohibaTheme.textTheme.headlineMedium!.color,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: BohibaResponsiveScreen.height20),
            child: Text(
              "Available Load",
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                color: bohibaTheme.textTheme.bodySmall!.color,
              ),
            ),
          ),
          const ConsigneeDetails(
            consigneeDetails: [],
          ),
        ]),
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        type: MaterialType.card,
        color: Colors.white,
        child: Container(
          height: height * 0.10,
          width: width,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CompanyBookLoadButton(
                onTap: () {
                  Get.toNamed(
                    BohibaRoute.orderScreen,
                    arguments: {
                      "from_read_only": false,
                    },
                  );
                },
                label: "Book Load",
              ),
              CompanyHistoryButton(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoadHistoryScreen(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

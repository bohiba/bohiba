import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_colors.dart';
import '/pages/order/order_component/driver_detail_component.dart';
import '/pages/order/order_component/from_to_details_component.dart';
import '/pages/order/order_component/vehicle_details_component.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    bool fromReadOnly = args["from_read_only"];
    return Scaffold(
      appBar: const TitleAppbar(
        title: "Book Load",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              children: [
                FromToDetailsComponent(
                  fromReadOnly: fromReadOnly,
                ),
                const VehicleDetailsComponent(),
                const DriverDetailComponent(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25.0),
        color: BohibaColors.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Amount:",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                  color: BohibaColors.white),
            ),
            Icon(
              EvaIcons.arrowheadRightOutline,
              color: BohibaColors.white,
            ),
            Text(
              "₹599.00",
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineMedium!.fontSize,
                  fontWeight:
                      Theme.of(context).textTheme.labelMedium!.fontWeight,
                  color: BohibaColors.white),
            )
          ],
        ),
      ),
    );
  }
}

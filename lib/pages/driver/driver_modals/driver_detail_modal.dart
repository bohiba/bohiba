import '/routes/app_route.dart';
import '/model/driver_model.dart';
import 'package:get/get.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/component/bohiba_modal/modal_sub_info_tile.dart';
import '../../../controllers/driver_controller.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/theme/bohiba_theme.dart';

class DriverDetialsModalSheet extends GetView<DriverController> {
  final DriverModel driver;
  const DriverDetialsModalSheet({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5.0,
              width: ScreenUtils.width * 0.25,
              margin: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
              decoration: TileDecorative(),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtils.width15,
                right: ScreenUtils.width15,
              ),
              child: Text(
                driver.profile?.name ?? 'NA',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bohibaTheme.textTheme.headlineLarge,
              ),
            ),
            // Divider(),
            Gap(ScreenUtils.height10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
              child: Column(
                children: [
                  SubInfoTile(
                    title: "Vehicle Number:",
                    data: 'NA',
                  ),
                  SubInfoTile(
                    title: "Mobile Number:",
                    data: driver.profile?.mobileNumber ?? 'NA',
                  ),
                  SubInfoTile(
                    title: "License Number:",
                    data: driver.licenseDetail?.licenseNumber ?? 'NA',
                  ),
                  SubInfoTile(
                    title: "Valid Till:",
                    data: driver.licenseDetail?.validityTill ?? 'NA',
                  ),
                  SubInfoTile(
                    title: "Valid Form:",
                    data: driver.licenseDetail?.validityFrom ?? 'NA',
                  ),
                  SubInfoTile(
                    title: "RTO:",
                    data: driver.licenseDetail?.rto,
                  ),
                  Gap(ScreenUtils.height15),
                  PrimaryButton(
                    width: ScreenUtils.width,
                    label: 'DETAIL VIEW',
                    onPressed: () {
                      Navigator.pop(context);
                      Get.toNamed(AppRoute.driver, arguments: driver);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

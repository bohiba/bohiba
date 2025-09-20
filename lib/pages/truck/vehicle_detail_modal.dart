import '../../controllers/truck_all_controller.dart';
import '/routes/app_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/model/truck_model.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_modal/modal_sub_info_tile.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleDetailModal extends GetView<TruckAllController> {
  final TruckModel vehicleDetails;
  const VehicleDetailModal({super.key, required this.vehicleDetails});

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
                vehicleDetails.regdNumber ?? 'NA',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bohibaTheme.textTheme.headlineLarge,
              ),
            ),
            // Divider(),
            Gap(ScreenUtils.height10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
              child: Form(
                child: Column(
                  children: [
                    SubInfoTile(
                      title: "Driver:",
                      data: vehicleDetails.driver?.name ?? 'NA',
                    ),
                    SubInfoTile(
                      title: "Unladen Weight:",
                      data: vehicleDetails.specs?.unladenWeight.toString() ??
                          'NA',
                    ),
                    SubInfoTile(
                      title: "Insurance Upto:",
                      data: vehicleDetails.validity?.insuranceUpto ?? 'NA',
                    ),
                    SubInfoTile(
                      title: "Fitness Upto:",
                      data: vehicleDetails.validity?.fitnessUpto ?? 'NA',
                    ),
                    SubInfoTile(
                      title: "Tax Upto:",
                      data: vehicleDetails.validity?.taxUpto ?? 'NA',
                    ),
                    SubInfoTile(
                      title: "PUCC Upto:",
                      data: vehicleDetails.validity?.puccUpto ?? 'NA',
                      enableBorder: false,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtils.height20.h,
                        bottom: ScreenUtils.height10.h,
                      ),
                      child: PrimaryButton(
                        width: ScreenUtils.width,
                        label: 'Detail View',
                        onPressed: () {
                          Get.close(1);
                          Get.toNamed(AppRoute.truck,
                                  arguments: vehicleDetails)!
                              .then((onValue) async {
                            if (onValue != null) {
                              await controller.getTruckList();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

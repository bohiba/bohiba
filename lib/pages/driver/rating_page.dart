import '/controllers/driver_controller.dart';
import '/dist/component_exports.dart';
import '/model/driver_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingPage extends GetView<DriverController> {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    DriverModel driver = controller.driverModel.value;
    return Scaffold(
      appBar: TitleAppbar(
        title: driver.profile?.name ?? 'NA',
      ),
    );
  }
}

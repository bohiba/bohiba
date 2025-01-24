import 'package:bohiba/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddVehicleController extends GetxController {
  final GlobalController _globalController = Get.put(GlobalController());

  bool isVerfyingVehicle = false;
  bool isfetchingVehicleDetails = false;
  bool isfetchingDLDetails = false;
  bool agree = false;
  String noOfWheel = "6";

  TextInputType regdNoInputType = TextInputType.text;
  final TextEditingController rcController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController driverLicenseController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final GlobalKey formKey = GlobalKey<FormState>();

  Future<void> addVehicle(VehicleRegdForm data) async {}

  Future<void> fetchDLData(String dlNo, String dob) async {}

  Future<void> fetchVehicleData(String vehicleNumber) async {}

  Future<void> datePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1850),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text =
          DateFormat("dd-MM-yyyy").format(pickedDate).toString();
    }
  }

  void vehicleKeyPad(int length) {
    if (length == 2 && regdNoInputType == TextInputType.text) {
      _globalController.closeKeyboard();
      regdNoInputType = TextInputType.number;
      update();
      Future.delayed(const Duration(milliseconds: 150), () {
        _globalController.openKeyBoard();
      });
    } else if (length == 4 && regdNoInputType == TextInputType.number) {
      _globalController.closeKeyboard();
      regdNoInputType = TextInputType.text;
      update();
      Future.delayed(const Duration(milliseconds: 150), () {
        _globalController.openKeyBoard();
      });
    }
  }
}

class VehicleRegdForm {
  String vehicleNo;
  String noOfWheel;
  String dlNumber;
  String driverPhoneNumber;
  String driverDob;

  VehicleRegdForm({
    required this.driverDob,
    required this.driverPhoneNumber,
    required this.dlNumber,
    required this.noOfWheel,
    required this.vehicleNo,
  });
}

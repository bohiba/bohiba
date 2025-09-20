import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/global_service.dart';

class TruckAddController {
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

  void vehicleKeyPad(int length, BuildContext context) {
    if (length == 2 && regdNoInputType == TextInputType.text) {
      GlobalService.closeKeyboard();
      regdNoInputType = TextInputType.number;

      Future.delayed(const Duration(milliseconds: 150), () {
        if (!context.mounted) return;
        GlobalService.openKeyBoard();
      });
    } else if (length == 4 && regdNoInputType == TextInputType.number) {
      GlobalService.closeKeyboard();
      regdNoInputType = TextInputType.text;

      Future.delayed(const Duration(milliseconds: 150), () {
        if (!context.mounted) return;
        GlobalService.openKeyBoard();
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

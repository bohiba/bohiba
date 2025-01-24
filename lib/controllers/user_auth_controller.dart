import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/services/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserAuthController extends GetxController {
  // Controller
  // final GlobalController _globalController = Get.put(GlobalController());

  // Models

  // Main Datatype
  PrefUtils prefUtils = PrefUtils();

  // Datatype for basicInfo
  XFile? imageFile;
  bool isUploadingImage = false;
  bool isFetchingImage = false;
  String? selectedDate;
  String imgUrl = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  // Variable for DocumentInfo
  bool isFetchingAadhar = false;
  bool isFetchingPan = false;
  bool isFetchingPinCode = false;
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextInputType keyboardType = TextInputType.text;

  // Variable for Address
  bool isAllFieldFetched = false;

  TextEditingController flatNoController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  // Variable for Bank
  TextEditingController chooseBankController = TextEditingController();
  TextEditingController acNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  Future<void> saveUserDetails(SaveUserDetails userDetails) async {
    Get.toNamed(
      AppRoute.navBar,
    );
  }

  Future<void> getPinCodeDetails(String pinCode) async {}

  Future<void> getPanDetails(String panNumber) async {}

  Future<void> getAadharDetails(String aadharNumber) async {}

  Future<void> getUserImage() async {}

  Future<void> uploadImage(XFile imageFile) async {}

  Future<void> pickImage() async {
    try {
      XFile? selected =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (selected != null) {
        imageFile = selected;
        update();
        await uploadImage(selected);
      } else {
        debugPrint("\n============\n| Pick an image. |\n============\n");
      }
    } catch (e) {
      debugPrint(
          "\n===========\n|Error while picking image: $e|\n===========\n");
    }
  }

  Future<void> datePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(1850),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dateController.text = DateFormat("dd-MM-yyyy").format(pickedDate);
      update();
    }
  }
}

class SaveUserDetails {
  final String name;
  final String dob;
  final String aadhaarNumber;
  final String panNumber;
  final String house;
  final String landmark;
  final String village;
  final String pin;
  final String district;
  final String state;
  final String country;

  SaveUserDetails({
    required this.name,
    required this.dob,
    required this.aadhaarNumber,
    required this.panNumber,
    required this.house,
    required this.landmark,
    required this.village,
    required this.pin,
    required this.district,
    required this.state,
    required this.country,
  });
}

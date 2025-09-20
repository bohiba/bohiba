import 'dart:convert';
import 'dart:io';
import '/dist/app_enums.dart';
import '/pages/widget/app_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/component/bohiba_buttons/primary_button.dart';
import '/component/image_path.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

bool isProgressOpen = false;

class GlobalService {
  static XFile? imageFile;
  // DateTime eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);

  static getAlertDialog({
    required AlertStatus status,
    required String title,
    required String description,
    String? buttonTxt,
    VoidCallback? onExit,
  }) {
    Color? textColor = bohibaTheme.textTheme.bodySmall!.color;
    switch (status) {
      case AlertStatus.warning:
        textColor = BohibaColors.warningColor;
        break;
      case AlertStatus.success:
        textColor = BohibaColors.successColor;
        break;
      case AlertStatus.info:
        textColor = BohibaColors.primaryColor;
        break;
      default:
    }
    return Get.dialog(
      barrierDismissible: false,
      useSafeArea: true,
      PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actionsPadding: EdgeInsets.all(ScreenUtils.height15),
          title: Text(
            title,
          ),
          titleTextStyle: TextStyle(
            fontSize: bohibaTheme.textTheme.displayMedium!.fontSize,
            color: textColor,
            fontFamily: bohibaTheme.textTheme.titleLarge!.fontFamily,
            fontWeight: bohibaTheme.textTheme.displayMedium!.fontWeight,
          ),
          content: Text(description),
          contentTextStyle: TextStyle(
            fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
            fontFamily: bohibaTheme.textTheme.titleLarge!.fontFamily,
            fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
            color: bohibaTheme.textTheme.titleLarge!.color,
          ),
          actions: [
            TextButton(
              onPressed: onExit ?? () => Get.back(result: true),
              child: Text(
                buttonTxt ?? 'Go Back',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<T?> showAlertDialog<T>({
    required AlertStatus status,
    required String title,
    required String description,
    String saveBtnTxt = 'Save',
    required VoidCallback onSave,
    String discardBtnTxt = 'Discard',
    VoidCallback? onDiscard,
  }) {
    Color? textColor = bohibaTheme.textTheme.bodySmall!.color;
    switch (status) {
      case AlertStatus.warning:
        textColor = BohibaColors.warningColor;
        break;
      case AlertStatus.success:
        textColor = BohibaColors.successColor;
        break;
      case AlertStatus.info:
        textColor = BohibaColors.primaryColor;
        break;
      default:
    }
    return Get.dialog(
      barrierDismissible: false,
      useSafeArea: true,
      PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actionsPadding: EdgeInsets.all(ScreenUtils.height15),
          title: Text(title.toUpperCase()),
          titleTextStyle: TextStyle(
            fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
            color: textColor,
            fontFamily: bohibaTheme.textTheme.displayMedium!.fontFamily,
            fontWeight: bohibaTheme.textTheme.displayMedium!.fontWeight,
          ),
          content: Text(description),
          contentTextStyle: TextStyle(
            fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
            fontFamily: bohibaTheme.textTheme.titleLarge!.fontFamily,
            fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
            color: bohibaTheme.textTheme.titleLarge!.color,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtils.width25),
          actions: [
            TextButton(
              onPressed: onDiscard ?? () => Get.back(),
              child: Text(
                discardBtnTxt,
                style: TextStyle(
                  color: BohibaColors.warningColor,
                ),
              ),
            ),
            PrimaryButton(
              height: ScreenUtils.height * 0.047,
              width: 80,
              label: saveBtnTxt,
              onPressed: onSave,
            )
          ],
        ),
      ),
    );
  }

  static Future<DateTime> datePickerModal(
      {required BuildContext context, String title = 'Select date'}) async {
    final result = await showModalBottomSheet(
      context: context,
      shape: BottomModalShape(),
      backgroundColor: bohibaTheme.bottomSheetTheme.backgroundColor,
      // isDismissible: false,
      isScrollControlled: false,
      // enableDrag: false,
      builder: (context) {
        return AppDatePicker(
          title: title,
        );
      },
    );
    return result ?? DateTime.now();
  }

  static Future<String> pickDate({
    required String dateFormatter,
    required String hintText,
    required BuildContext context,
  }) async {
    DateTime? chooseDate = DateTime.now();
    DateFormat dateFormat = DateFormat(dateFormatter);

    chooseDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1820),
        lastDate: DateTime.now(),
        helpText: hintText,
        fieldHintText: 'DD-MM-YYYY',
        fieldLabelText: '',
        keyboardType: TextInputType.numberWithOptions());
    if (chooseDate != null) {
      return dateFormat.format(chooseDate);
    } else {
      chooseDate = DateTime.now();
      return dateFormat.format(chooseDate);
    }
  }

  static Future<String> decodeBase64ToImage(String imagePath) async {
    File imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception("Image file not found");
    }
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  static Future<void> pickImage() async {
    XFile? selected =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selected != null) {
      imageFile = selected;
      decodeBase64ToImage(imageFile!.path);
    } else {
      debugPrint("\n============\n| Pick an image. |\n============\n");
    }
  }

  static String removeBlankSpace(String value) {
    String stringWithoutSpaces = value.replaceAll(' ', '');
    return stringWithoutSpaces;
  }

  static double removeCurrencySymbol({required String value}) {
    String cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(cleaned) ?? 0.0;
  }

  static void closeKeyboard() {
    bool getFocus = Get.focusScope?.hasFocus ?? false;
    if (getFocus == false) {
      return;
    }
    Get.focusScope?.unfocus();
  }

  static void openKeyBoard() {
    Get.focusScope?.requestFocus();
  }

  static Future<bool?> showAppToast({
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
    ToastGravity? gravity,
  }) async {
    if (Platform.isMacOS) {
      printHandler(message);
      return false;
    }
    return Fluttertoast.showToast(
      msg: message,
      fontAsset: ImagePath.companyLogo,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: BohibaColors.greyColor,
      textColor: BohibaColors.white,
      fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
    );
  }

  static String getAvatarUrl(String fullName,
      {bool rounded = true, bool isTruck = false}) {
    String username = 'UN';

    if (isTruck) {
      if (fullName.isNotEmpty) {
        username = fullName.substring(0, 2);
      }
      return 'https://ui-avatars.com/api/?name=$username&font-size=0.4&size=1080&rounded=$rounded&color=047BFC&background=FFFFFF';
    } else {
      if (fullName.isNotEmpty) {
        username = fullName.trim().split(' ').join('+');
      }
      return 'https://ui-avatars.com/api/?name=$username&font-size=0.4&size=1080&rounded=$rounded&color=047BFC&background=FFFFFF';
    }
  }

  static bool isEmail(String em) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(em);

    return emailValid;
  }

  static void showProgress([String? msg, Function()? onCancel]) {
    if (isProgressOpen) {
      return;
    }
    try {
      isProgressOpen = true;
      Get.dialog(
        Material(
          color: Colors.transparent,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (canPop, value) {
              if (canPop) {
                return;
              }
              return;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (onCancel != null)
                    ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.cancel_sharp),
                          onPressed: onCancel,
                          color: Colors.white,
                        ),
                      )
                    : Container(),
                Container(
                  width: 25.h,
                  height: 25.h,
                  margin: EdgeInsets.only(left: 24.h, right: 24.h),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5.w,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                (msg != null)
                    ? SizedBox(
                        width: ScreenUtil.defaultSize.width / 2,
                        child: Text(msg, textAlign: TextAlign.center),
                      )
                    : Container(height: 0),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      ).then((value) {
        isProgressOpen = false;
      });
    } catch (e) {
      isProgressOpen = false;
    }

    Future.delayed(const Duration(seconds: 60), () {
      if (isProgressOpen) {
        dismissProgress();
      }
    });
  }

  static void dismissProgress() {
    if (isProgressOpen) {
      Get.back();
    }
  }

  static printHandler(String log) {
    debugPrint("\n=================\n$log\n================\n");
  }
}

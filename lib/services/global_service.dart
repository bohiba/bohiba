import 'dart:convert';
import 'dart:io';
import 'package:logger/web.dart';
import 'package:remixicon/remixicon.dart';

import '../dist/enums/app_enums.dart';
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
  static OverlayEntry? _activeTooltip;

  /// Shows a speech-bubble tooltip anchored to [tapPosition] — the exact
  /// global coordinates of the user's tap (from [TapDownDetails.globalPosition]
  /// or [LongPressStartDetails.globalPosition]).
  ///
  /// Direction is chosen automatically:
  ///   • enough space below the tap → tooltip appears **below**, arrow points ↑
  ///   • cramped below               → tooltip appears **above**, arrow points ↓
  ///
  /// Usage:
  /// ```dart
  /// GestureDetector(
  ///   onTapDown: (d) => GlobalService.showTooltip(
  ///     context: context,
  ///     tapPosition: d.globalPosition,
  ///     message: 'Coming Soon',
  ///   ),
  ///   child: myWidget,
  /// )
  /// ```
  static void showTooltip({
    required BuildContext context,
    required Offset tapPosition,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _dismissActiveTooltip();

    final Size screen = MediaQuery.sizeOf(context);

    const double arrowH = 9.0;
    const double hPad = 14.0;
    const double vPad = 8.0;
    const double gap = 8.0;
    const double estimatedHeight = arrowH + vPad * 2 + 25.0;

    // ── Direction based on available space at the tap point ─────────────────
    final bool showBelow =
        (screen.height - tapPosition.dy) >= estimatedHeight + gap;

    // ── Vertical: just below or above the tap point ──────────────────────────
    final double top = showBelow
        ? tapPosition.dy + gap + 10
        : tapPosition.dy + estimatedHeight + gap;

    _activeTooltip = OverlayEntry(
      builder: (_) => Positioned(
        left: 0,
        right: 0,
        top: top,
        child: Align(
          alignment: Alignment(
            ((tapPosition.dx / screen.width) * 2 - 1).clamp(-1.0, 1.0),
            10,
          ),
          child: Material(
            color: Colors.transparent,
            child: IntrinsicWidth(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screen.width - 48),
                child: CustomPaint(
                  painter: _TooltipBubblePainter(
                    color: bohibaTheme.cardColor,
                    shadowColor: bohibaTheme.dividerColor,
                    arrowHeight: arrowH,
                    borderRadius: 8.r,
                    arrowAtTop: showBelow,
                  ),
                  child: Padding(
                    padding: showBelow
                        ? const EdgeInsets.fromLTRB(
                            hPad, arrowH + vPad, hPad, vPad)
                        : const EdgeInsets.fromLTRB(
                            hPad, vPad, hPad, arrowH + vPad),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: bohibaTheme.textTheme.labelSmall?.copyWith(
                          color: bohibaTheme.textTheme.bodySmall!.color),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_activeTooltip!);
    Future.delayed(duration, _dismissActiveTooltip);
  }

  static void _dismissActiveTooltip() {
    _activeTooltip?.remove();
    _activeTooltip = null;
  }

  static XFile? imageFile;
  // DateTime eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);

  static showDialog({
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
          title: Text(title),
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
          contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtils.width25),
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
    double? width,
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
        textColor = bohibaTheme.colorScheme.tertiary;
        break;
      case AlertStatus.success:
        textColor = bohibaTheme.colorScheme.onPrimary;
        break;
      case AlertStatus.info:
        textColor = bohibaTheme.primaryColor;
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
                discardBtnTxt.toUpperCase(),
                style: TextStyle(
                  color: textColor,
                  fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                ),
              ),
            ),
            PrimaryButton(
              height: ScreenUtils.height * 0.047,
              width: width ?? ScreenUtils.width * 0.25,
              label: saveBtnTxt,
              onPressed: onSave,
            )
          ],
        ),
      ),
    );
  }

  static Future<DateTime?> datePickerModal({
    required BuildContext context,
    String title = 'Select date',
    DateTime? endTime,
    DateTime? startTime,
  }) async {
    return await showModalBottomSheet(
      context: context,
      shape: BottomModalShape(),
      useSafeArea: false,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) {
        return AppDatePicker(
          title: title,
          lastDateTime: endTime,
          startDateTime: startTime,
        );
      },
    );
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

  static SnackbarController? showLocalNotification({
    String title = 'Bohiba',
    String message = '',
  }) {
    return Get.snackbar(
      title,
      message,
      duration: Duration(seconds: 2),
      backgroundColor: bohibaTheme.scaffoldBackgroundColor,
    );
  }

  // ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  static SnackbarController? showSnackBar({
    required AlertStatus status,
    String title = 'Bohiba',
    String desc = 'Something went wrong',
    Widget? actionButton,
    int? showTimer,
  }) {
    Color color = bohibaTheme.primaryColor;
    IconData iconData = Icons.error;
    switch (status) {
      case AlertStatus.success:
        color = bohibaTheme.colorScheme.onPrimary;
        iconData = Remix.checkbox_circle_fill;
        break;
      case AlertStatus.info:
        color = bohibaTheme.colorScheme.primary;
        iconData = Icons.info;
        break;
      case AlertStatus.warning:
        color = bohibaTheme.colorScheme.error;
        iconData = Icons.warning;
        break;
      case AlertStatus.failure:
        color = bohibaTheme.colorScheme.tertiary;
        iconData = Icons.error;
        break;
      case AlertStatus.noInternet:
        color = bohibaTheme.colorScheme.error;
        iconData = Icons.wifi_off_rounded;
        break;
    }
    if (Get.isSnackbarOpen) {
      return null;
    }
    return Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          desc,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
            fontWeight: bohibaTheme.textTheme.labelLarge!.fontWeight,
            color: bohibaTheme.textTheme.displayLarge!.color,
          ),
        ),
        isDismissible: false,
        backgroundColor: color,
        shouldIconPulse: false,
        icon: Icon(
          iconData,
          color: bohibaTheme.colorScheme.surface,
        ),
        borderRadius: 8.0,
        borderWidth: 0.0,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        duration: Duration(seconds: showTimer ?? 3),
        mainButton: actionButton ??
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'CLOSE',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodyMedium!.fontWeight,
                  color: bohibaTheme.textTheme.displayLarge!.color,
                ),
              ),
            ),
      ),
    );
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
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: bohibaTheme.colorScheme.secondary,
      textColor: bohibaTheme.textTheme.displayLarge!.color,
      fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
      fontAsset: ImagePath.bohibaIcon,
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

  static Future<void> showProgress([String? msg, Function()? onCancel]) async {
    bool isSnackOpen = Get.isSnackbarOpen;
    if (isSnackOpen) {
      Get.back();
    }

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
                if (msg != null)
                  Container(
                    padding: EdgeInsets.only(top: 20.h),
                    width: ScreenUtil.defaultSize.width / 2,
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  SizedBox.shrink(),
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

    Future.delayed(const Duration(seconds: 35), () {
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

  static final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  static printHandler(String log) {
    debugPrint("\n=================\n$log\n================\n");
  }
}

/// Draws a speech-bubble shape with an arrow that points toward the widget.
/// [arrowAtTop] = true  → arrow at top,    tooltip is **below** the widget.
/// [arrowAtTop] = false → arrow at bottom, tooltip is **above** the widget.
class _TooltipBubblePainter extends CustomPainter {
  final Color color;
  final Color shadowColor;
  final double arrowHeight;
  final double borderRadius;
  final bool arrowAtTop;

  const _TooltipBubblePainter({
    required this.color,
    required this.shadowColor,
    this.arrowHeight = 9.0,
    this.borderRadius = 10.0,
    this.arrowAtTop = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = borderRadius;
    final double ah = arrowHeight;
    const double aw = 14.0;
    final double mid = w / 2;

    final Path path;

    if (arrowAtTop) {
      // Arrow points UP — tooltip sits below the widget
      path = Path()
        ..moveTo(mid, 0) // arrow tip
        ..lineTo(mid - aw / 2, ah) // arrow left foot
        ..lineTo(r, ah)
        ..quadraticBezierTo(0, ah, 0, ah + r) // top-left corner
        ..lineTo(0, h - r)
        ..quadraticBezierTo(0, h, r, h) // bottom-left corner
        ..lineTo(w - r, h)
        ..quadraticBezierTo(w, h, w, h - r) // bottom-right corner
        ..lineTo(w, ah + r)
        ..quadraticBezierTo(w, ah, w - r, ah) // top-right corner
        ..lineTo(mid + aw / 2, ah) // arrow right foot
        ..close();
    } else {
      // Arrow points DOWN — tooltip sits above the widget
      final double bodyH = h - ah;
      path = Path()
        ..moveTo(r, 0)
        ..quadraticBezierTo(0, 0, 0, r) // top-left corner
        ..lineTo(0, bodyH - r)
        ..quadraticBezierTo(0, bodyH, r, bodyH) // bottom-left corner
        ..lineTo(mid - aw / 2, bodyH) // arrow left foot
        ..lineTo(mid, h) // arrow tip
        ..lineTo(mid + aw / 2, bodyH) // arrow right foot
        ..lineTo(w - r, bodyH)
        ..quadraticBezierTo(w, bodyH, w, bodyH - r) // bottom-right corner
        ..lineTo(w, r)
        ..quadraticBezierTo(w, 0, w - r, 0) // top-right corner
        ..close();
    }

    canvas.drawShadow(path, shadowColor, 4, false);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TooltipBubblePainter old) =>
      old.color != color ||
      old.shadowColor != shadowColor ||
      old.arrowAtTop != arrowAtTop;
}

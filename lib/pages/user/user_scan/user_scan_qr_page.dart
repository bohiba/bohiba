import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/dist/component_exports.dart';
import '/controllers/user_scan_qr_controller.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class UserScanQrPage extends GetView<UserScanQrController> {
  const UserScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(title: 'Scanner'),
      body: QRView(
        key: controller.qrKey,
        onQRViewCreated: (qr) {
          controller.qrController = qr;
          qr.scannedDataStream.listen((scanData) {
            controller.result = scanData;
            String data = (controller.result != null && controller.result?.code != null) ? (controller.result?.code ?? '') : '';

            if (data.isNotEmpty) {
              controller.qrController?.stopCamera();
              navigateState.popAndPushNamed(AppRoute.userScanAction);
            }
          });
        },
        overlay: QrScannerOverlayShape(
          borderColor: bohibaTheme.dividerColor,
          borderWidth: 4.0.w,
        ),
      ),
    );
  }
}

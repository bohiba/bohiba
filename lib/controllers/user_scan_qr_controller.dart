import '/services/encryption_service.dart';
import '/services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class UserScanQrController extends GetxController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      if (qrController!.hasPermissions) {
        PermissionService.requestCamPermission();
      }
    });
  }

  String uuidDecrypt() {
    return _decryptString();
  }

  String _decryptString() {
    if (result != null && result!.code != null && result!.code!.isNotEmpty) {
      return EncryptionService.decryptText(result!.code!);
    }
    return '';
  }

  @override
  void onClose() {
    qrController?.disposed;
    super.onClose();
  }
}

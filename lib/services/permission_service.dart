import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final Map<Permission, PermissionStatus> _permissionsStatus = {};
  Map<Permission, PermissionStatus> get permissionsStatus => _permissionsStatus;

  static Future<void> checkAndRequestPermissions() async {
    try {
      PermissionStatus locStatus = await Permission.location.request();
      if (locStatus != PermissionStatus.granted) {
        await Permission.location.request();
      }
      debugPrint(
          "\n================\n| Location Status: $locStatus |\n================\n");
      // if (!(await Geolocator.isLocationServiceEnabled())) {
      //   Geolocator.requestPermission();
      // }

      PermissionStatus cameraStatus = await Permission.camera.request();
      if (cameraStatus != PermissionStatus.granted) {
        cameraStatus = await Permission.camera.request();
      }
      debugPrint(
          "\n================\n| Camera Status: $cameraStatus |\n================\n");

      PermissionStatus permissionStorage = await Permission.storage.request();
      if (permissionStorage != PermissionStatus.granted) {
        permissionStorage = await Permission.storage.request();
      }
      debugPrint(
          "\n================\n| Permission Status: $permissionStorage |\n================\n");

      PermissionStatus mediLibraryPermission =
          await Permission.mediaLibrary.request();
      if (mediLibraryPermission != PermissionStatus.granted) {
        mediLibraryPermission = await Permission.mediaLibrary.request();
      }
      debugPrint(
          "\n================\n| Permission Folder: $mediLibraryPermission |\n================\n");

      PermissionStatus manageExternalPermission =
          await Permission.manageExternalStorage.request();
      if (manageExternalPermission != PermissionStatus.granted) {
        manageExternalPermission =
            await Permission.manageExternalStorage.request();
      }
      debugPrint(
          "\n================\n| Manage External Permission: $manageExternalPermission |\n================\n");
    } catch (e) {
      debugPrint(
          "\n================\n| Permission Status: $e |\n================\n");
    }
  }

  bool isPermissionGranted(Permission permission) {
    return _permissionsStatus[permission]?.isGranted ?? false;
  }
}

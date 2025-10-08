import '/services/global_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final Map<Permission, PermissionStatus> _permissionsStatus = {};
  Map<Permission, PermissionStatus> get permissionsStatus => _permissionsStatus;

  static Future<void> reqMediaLibrary() async {
    PermissionStatus permissionStorage = await Permission.storage.request();
    if (permissionStorage != PermissionStatus.granted) {
      permissionStorage = await Permission.storage.request();
    }
    GlobalService.printHandler(
        "\n================\n| Permission Status: $permissionStorage |\n================\n");

    PermissionStatus mediLibraryPermission =
        await Permission.mediaLibrary.request();
    if (mediLibraryPermission != PermissionStatus.granted) {
      mediLibraryPermission = await Permission.mediaLibrary.request();
    }
    GlobalService.printHandler(
        "\n================\n| Permission Folder: $mediLibraryPermission |\n================\n");

    PermissionStatus manageExternalPermission =
        await Permission.manageExternalStorage.request();
    if (manageExternalPermission != PermissionStatus.granted) {
      manageExternalPermission =
          await Permission.manageExternalStorage.request();
    }
    GlobalService.printHandler(
        "\n================\n| Manage External Permission: $manageExternalPermission |\n================\n");
  }

  static Future<bool> requestCamPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    PermissionStatus cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }
    GlobalService.printHandler(
        "\n================\n| Camera Status: ${cameraStatus.isGranted} |\n================\n");
    return cameraStatus.isGranted;
  }

  static Future<void> reqLocPermission() async {
    PermissionStatus locStatus = await Permission.location.request();
    if (locStatus != PermissionStatus.granted) {
      await Permission.location.request();
    }
    GlobalService.printHandler(
        "\n================\n| Location Status: $locStatus |\n================\n");
    // if (!(await Geolocator.isLocationServiceEnabled())) {
    //   Geolocator.requestPermission();
    // }
  }

  static Future<bool> requestOpenAppSetting() async {
    return await openAppSettings();
  }

  bool isPermissionGranted(Permission permission) {
    return _permissionsStatus[permission]?.isGranted ?? false;
  }
}

import '../dist/app_enums.dart';

String getUserRoleName(int value) {
  switch (value) {
    case 1:
      return "Truck Owner";
    case 2:
      return "Manager";
    case 3:
      return "Driver";
    default:
      return "Unknown";
  }
}

UserRoleType getUserRoleType(int value) {
  switch (value) {
    case 1:
      return UserRoleType.truckowner;
    case 2:
      return UserRoleType.manager;
    case 3:
      return UserRoleType.driver;
    default:
      return UserRoleType.unknown;
  }
}

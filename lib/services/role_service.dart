import '/model/profile_model.dart';
import '/services/role_permission_service.dart';
import '/services/user_role_type.dart';

class RolePermissionManager {
  final ProfileModel user;

  RolePermissionManager(this.user);

  /// Base permissions per role
  Map<int, List<String>> get rolePermissions => {
        UserRoles.truckOwner: [
          RolePermissionService.viewTrips,
          RolePermissionService.addTrips,
          RolePermissionService.viewTrucks,
          RolePermissionService.addTrucks,
          RolePermissionService.editTrucks,
          RolePermissionService.deleteTrucks,
          RolePermissionService.viewDriver,
          RolePermissionService.addDrivers,
          RolePermissionService.editTrips,
          RolePermissionService.viewMaintainance,
        ],
        UserRoles.manager: [
          RolePermissionService.manageTrucks,
          RolePermissionService.manageDrivers,
          RolePermissionService.manageTrips,
        ],
        UserRoles.driver: [
          RolePermissionService.viewTrips,
          RolePermissionService.viewTrucks,
          RolePermissionService.viewMaintainance
        ],
      };

  bool hasPermission(String permission) {
    if (user.roleId == null) return false;

    // Start with base role permissions
    final basePermissions = rolePermissions[user.roleId!] ?? [];

    // TODO: in future — merge with truckOwner custom permissions stored in Hive
    // Example: basePermissions.addAll(user.customPermissions ?? []);

    return basePermissions.contains(permission);
  }

  int roleId() {
    return user.roleId ?? 9;
  }
}

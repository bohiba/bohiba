import '/services/global_service.dart';

import '/model/profile_model.dart';
import '/services/role_service.dart';

class RoleService {
  static final RoleService _instance = RoleService._internal();
  factory RoleService() => _instance;
  RoleService._internal();

  static ProfileModel? _profile;
  static late RolePermissionManager _rolePermissionManager;

  static ProfileModel? get profile => _profile;

  /// Initialize role by loading profile
  static int initRole(ProfileModel? profileModel) {
    _profile = profileModel;
    _loadProfile(profileModel);

    return _profile?.roleId ?? 9;
  }

  static void _loadProfile(ProfileModel? userInfo) {
    if (_profile != null) {
      _rolePermissionManager = RolePermissionManager(_profile!);

      GlobalService.printHandler(
          'Role Id: ${_rolePermissionManager.user.roleId.toString()}');
    }
  }

  static bool hasPermission(String permission) {
    return _rolePermissionManager.hasPermission(permission);
  }

  static int roleId() {
    return _rolePermissionManager.roleId();
  }
}

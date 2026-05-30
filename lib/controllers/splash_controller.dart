import 'dart:async';
import 'role_controller.dart';
import '/extensions/bohiba_extension.dart';
import '/services/auth_service.dart';
import '/dist/enums/enum_role_validation.dart';
import '/dist/enums/app_enums.dart';
import '/routes/app_route.dart';
import '/model/profile_model.dart';
import '/services/db2_service.dart';
import '/services/device_info_service.dart';
import '/services/firebase_app_service.dart';
import '/services/global_service.dart';
import '/services/main_service.dart';
import '/services/pref_utils.dart';
import '/core/network/dio_serivce.dart';
import '/services/user_role_type.dart';
import '/services/profile_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final DioService _dio = DioService();
  final PrefUtils _prefUtils = PrefUtils();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, _initApp);
  }

  Future<void> _initApp() async {
    try {
      await Future.wait([
        PrefUtils.init(),
        DatabaseService().initDB(),
      ]);

      final String token = _prefUtils.getString(PrefUtils.token);

      if (token.isEmpty) {
        await AuthService.clearApp();
        return Get.offAllNamed(AppRoute.signIn);
      }

      final bool online = await DeviceInfoService.hasInternet();
      final MethodType method = online ? MethodType.api : MethodType.local;

      _dio.setToken(token);

      // If user is online wipe LocalDB and fetch fresh data from Server
      if (online) {
        await DatabaseService().clearDBData();
      }

      final ProfileModel? profile = await ProfileService.getProfile(
        type: method,
        showProgress: false,
      );

      // Broken session: missing profile or phone number → force re-login.
      if (profile == null) {
        await AuthService.clearApp();
        return Get.offAllNamed(AppRoute.signIn);
      }

      final int userRole = RoleService.initRole(profile);

      if (userRole.isGuest) {
        return Get.offAllNamed(AppRoute.roleType, arguments: {
          'validationType': EnumRoleValidation.whileSignIn,
        });
      }

      // Kick off background sync without blocking navigation.
      unawaited(Future.wait([
        MainService.mainApi(type: method, showProgress: false),
        FirebaseAppService.registerToken(),
      ]));

      await _navigateAuthenticated(role: userRole, profile: profile);
    } catch (e, stack) {
      GlobalService.printHandler('SplashController._initApp error: $e\n$stack');
      // Any unhandled failure falls back to sign-in — never leave user on a frozen splash.
      await AuthService.clearApp();
      Get.offAllNamed(AppRoute.signIn);
    }
  }

  Future<void> _navigateAuthenticated({
    required int role,
    required ProfileModel profile,
  }) async {
    final String target = _routeForRole(role);

    if (target.isEmpty) {
      // Unrecognised role — treat as unauthenticated to avoid a dead screen.
      await AuthService.clearApp();
      return Get.offAllNamed(AppRoute.signIn);
    }

    if (!DeviceInfoService.isBioMetricEnabled()) {
      return Get.offAllNamed(target);
    }

    final bool passed = await DeviceInfoService.authenticateUser();
    if (!passed) {
      return Get.offAllNamed(AppRoute.biometricAuth, arguments: profile);
    }

    Get.offAllNamed(target);
  }

  /// Maps a role ID to its home route.
  ///
  /// Manager shares the owner nav bar (no dedicated manager nav exists).
  String _routeForRole(int role) {
    switch (role) {
      case UserRoles.truckOwner:
        return AppRoute.truckOwnerNavBar;
      case UserRoles.manager:
        return AppRoute.truckOwnerNavBar;
      case UserRoles.driver:
        return AppRoute.truckDriverNavBar;
      default:
        return '';
    }
  }
}

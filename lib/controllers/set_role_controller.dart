import 'package:bohiba/dist/enums/enum_role_validation.dart';

import '../dist/enums/app_enums.dart';
import '/services/global_service.dart';
import '/services/user_role_type.dart';

import '/services/profile_service.dart';
import 'package:get/get.dart';

class SetRoleController extends GetxController {
  Rxn<AccountType> roleObj = Rxn<AccountType>();

  RxString token = "".obs;
  Rx<EnumRoleValidation> enumRoleValidation = EnumRoleValidation.none.obs;
  RxBool canPop = true.obs;

  @override
  void onInit() {
    super.onInit();
    Map? argsObj = Get.arguments;
    if (argsObj != null) {
      if (argsObj.containsKey('token')) {
        token.value = argsObj['token'];
      }
      if (argsObj.containsKey('canPop')) {
        canPop.value = argsObj['canPop'];
      }
      if (argsObj.containsKey('validationType')) {
        enumRoleValidation.value = argsObj['validationType'];
      }
    }
  }

  final List<AccountType> userRoleList = [
    const AccountType(
      roleId: 6,
      label: 'Truck Owner',
      subTitle:
          'Truck Owner will able to manage truck, driver, manager, trip with powerful analytics',
    ),
    const AccountType(
      roleId: 8,
      label: 'Driver',
      subTitle:
          'Driver will able to manage their profile with find jobs opportunity.',
    ),
  ];

  RxInt selectedIndex = (-1).obs;

  AccountType selectRole(int index) {
    selectedIndex.value = index;
    return userRoleList[index];
  }

  Future<int> setRole() async {
    if (selectedIndex.value == -1 || roleObj.value?.roleId == UserRoles.guest) {
      GlobalService.showSnackBar(
        status: AlertStatus.info,
        desc: 'Please select role type.',
      );
    }
    Map<String, dynamic> bodyObj = {
      'role_id': roleObj.value?.roleId,
    };
    int updateRole = await ProfileService.setRole(
      bodyMap: bodyObj,
      initRole: true,
      token: token.value,
    );
    return updateRole;
  }
}

class AccountType {
  final int? roleId;
  final String? label;
  final String? subTitle;

  const AccountType({
    this.roleId,
    this.label,
    this.subTitle,
  });
}

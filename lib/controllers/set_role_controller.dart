import '/dist/app_enums.dart';
import '/services/global_service.dart';
import '/services/user_role_type.dart';

import '/services/profile_service.dart';
import 'package:get/get.dart';

class SetRoleController extends GetxController {
  RxMap<String, dynamic> roleObj = <String, dynamic>{}.obs;

  final List<Map<String, dynamic>> userRoleList = [
    {
      "role_id": 6,
      "label": "Truck Owner",
      "subTitle":
          "Truck Owner will able to manage truck, driver, manager, trip with powerful analytics",
    },
    {
      "role_id": 8,
      "label": "Driver",
      "subTitle":
          "Driver will able to manage their profile with find jobs opportunity.",
    },
  ];

  RxInt selectedIndex = (-1).obs;

  Map<String, dynamic> selectAddress(int index) {
    selectedIndex.value = index;
    return userRoleList[index];
  }

  Future<int> setRole() async {
    if (selectedIndex.value == -1 || roleObj['role_id'] == UserRoles.guest) {
      GlobalService.showSnackBar(
        status: AlertStatus.info,
        desc: 'Please select role type.',
      );
    }
    Map<String, dynamic> bodyObj = {
      'role_id': roleObj['role_id'],
    };
    int updateRole =
        await ProfileService.setRole(bodyMap: bodyObj, initRole: true);
    return updateRole;
  }
}

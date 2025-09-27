import '/services/user_role_type.dart';

import '../../controllers/role_controller.dart';
import 'package:flutter/material.dart';

class RoleWidget extends StatelessWidget {
  final Widget? truckOwnerWidget;
  // final Widget? managerWidget;
  final Widget? driverWidget;
  final Widget? fallbackWidget;

  const RoleWidget({
    super.key,
    this.truckOwnerWidget,
    // this.managerWidget,
    this.driverWidget,
    this.fallbackWidget,
  });

  @override
  Widget build(BuildContext context) {
    final int roleId = RoleService.profile?.roleId ?? UserRoles.guest;

    Widget child;
    switch (roleId) {
      case UserRoles.truckOwner:
        child = truckOwnerWidget ?? fallbackWidget ?? SizedBox.shrink();
        break;
      // case UserRoles.manager:
      //   child = managerWidget ?? fallbackText ?? SizedBox.shrink();
      //   break;
      case UserRoles.driver:
        child = driverWidget ?? fallbackWidget ?? SizedBox.shrink();
        break;
      default:
        child = fallbackWidget ?? SizedBox.shrink();
    }

    return child;
  }
}

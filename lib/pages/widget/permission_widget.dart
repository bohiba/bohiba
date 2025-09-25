import '/controllers/role_controller.dart';
import 'package:flutter/material.dart';

class PermissionWidget extends StatelessWidget {
  final String permission;
  final Widget child;

  const PermissionWidget({
    super.key,
    required this.permission,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RoleService.hasPermission(permission)
        ? child
        : const SizedBox.shrink();
  }
}

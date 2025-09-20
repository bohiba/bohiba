import 'package:flutter/material.dart';

class DashAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const DashAppBar({super.key, this.title = "Dashboard"});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
    );
  }
}

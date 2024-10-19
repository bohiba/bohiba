import 'package:flutter/material.dart';

class DashAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const DashAppBar({
    Key? key,
    this.title = "Dashboard",
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
    );
  }
}

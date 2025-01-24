import 'package:flutter/material.dart';

class NotifyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int? notifyLength;

  const NotifyAppBar(
      {super.key, this.notifyLength, this.title = "Notification Title"});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
          title: Text(title),
        ));
  }
}

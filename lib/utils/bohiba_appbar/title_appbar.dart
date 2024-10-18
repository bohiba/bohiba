import 'package:flutter/material.dart';

class TitleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TitleAppbar({
    Key? key,
    this.title = "Title",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: true,
        title: Text(title),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

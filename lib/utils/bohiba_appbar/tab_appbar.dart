import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        title: const Text('Challan'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Remix.question_line)),
          IconButton(onPressed: () {}, icon: const Icon(Remix.printer_line))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Challan'),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
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

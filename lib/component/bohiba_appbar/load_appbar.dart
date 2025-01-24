import 'package:bohiba/routes/bohiba_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const LoadAppBar({
    super.key,
    this.title = "Title",
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Add Load',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoute.addLoadScreen);
            },
            icon: const Icon(EvaIcons.plus),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

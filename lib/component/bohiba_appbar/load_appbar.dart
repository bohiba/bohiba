import 'package:bohiba/routes/bohiba_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class LoadAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const LoadAppBar({
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
        actions: [
          IconButton(
            tooltip: 'Add Load',
            onPressed: () {
              Navigator.of(context).pushNamed(BohibaRoute.addLoadScreen);
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

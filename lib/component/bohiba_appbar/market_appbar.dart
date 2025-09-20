import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class MinesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MinesAppBar({super.key, this.title = "Title"});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Search Company',
            onPressed: () {
              // showSearch(
              //   context: context,
              //   delegate: BohibaCompanySearchDelegate(),
              // );
            },
            icon: const Icon(EvaIcons.searchOutline),
          ),
        ],
      ),
    );
  }
}

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../bohiba_search_delegate.dart';

class MarketAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MarketAppBar({Key? key, this.title = "Title"}) : super(key: key);

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
        actions: [
          IconButton(
            tooltip: 'Search Company',
            onPressed: () {
              showSearch(
                context: context,
                delegate: BohibaCompanySearchDelegate(),
              );
            },
            icon: const Icon(EvaIcons.searchOutline),
          ),
        ],
      ),
    );
  }
}

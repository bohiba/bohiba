import 'package:flutter/material.dart';

class FavouriteAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const FavouriteAppbar({
    super.key,
    this.title = "Title",
    this.actions,
  });

  @override
  State<FavouriteAppbar> createState() => _FavouriteAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _FavouriteAppbarState extends State<FavouriteAppbar> {
  @override
  Widget build(BuildContext context) {
    final navigate = Navigator.of(context);
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: widget.actions,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new_rounded),
          onTap: () {
            navigate.pop(true);
          },
        ),
      ),
    );
  }
}

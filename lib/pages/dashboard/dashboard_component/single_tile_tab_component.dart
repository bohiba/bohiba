import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class SingleTileTabComponent extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Widget trailing;

  const SingleTileTabComponent(
      {super.key,
      required this.onTap,
      this.icon = Icons.add,
      this.trailing = const SizedBox(),
      this.iconColor,
      this.title = "Title"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        // iconColor: iconColor ?? bohibaTheme.primaryColor,
        title: Text(title),
        titleTextStyle: TextStyle(
          fontFamily: bohibaTheme.textTheme.titleLarge!.fontFamily,
          fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
          fontWeight: bohibaTheme.textTheme.titleLarge!.fontWeight,
          color: bohibaTheme.listTileTheme.titleTextStyle!.color,
        ),
        trailing: trailing,
      ),
    );
  }
}

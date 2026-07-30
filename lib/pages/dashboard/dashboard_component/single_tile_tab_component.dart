import 'package:flutter/material.dart';

class SingleTileTabComponent extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Widget trailing;

  const SingleTileTabComponent({
    super.key,
    this.onTap,
    this.icon = Icons.add,
    this.trailing = const SizedBox(),
    this.iconColor,
    this.title = "Title",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(title),
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.listTileTheme.titleTextStyle?.color,
        ),
        trailing: trailing,
      ),
    );
  }
}

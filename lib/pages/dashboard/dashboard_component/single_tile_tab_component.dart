import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:flutter/material.dart';

class SingleTileTabComponent extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final Color iconColor;
  final Widget trailing;

  const SingleTileTabComponent(
      {Key? key,
      required this.onTap,
      this.icon = Icons.add,
      this.trailing = const SizedBox(),
      this.iconColor = Colors.black,
      this.title = "Title"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
          onTap: onTap,
          leading: Icon(icon),
          iconColor: iconColor,
          title: Text(title),
          titleTextStyle: TextStyle(
              fontFamily: "Poppins",
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              fontWeight: Theme.of(context).textTheme.titleLarge!.fontWeight,
              color: bohibaColors.black),
          trailing: trailing),
    );
  }
}

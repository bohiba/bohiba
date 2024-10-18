import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class BlueBoxComponent extends StatelessWidget {
  final String label1;
  final String label2;
  final Widget child;

  const BlueBoxComponent({
    Key? key,
    this.label1 = "Header",
    this.label2 = "Sub Header",
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BohibaResponsiveScreen.width,
      height: 219,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bohibaColors.primaryVariantColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 25),
            child: Text(
              label1,
              style: TextStyle(
                  fontSize: bohibaTheme.textTheme.headlineLarge!.fontSize,
                  fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                  color: bohibaColors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              label2,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                color: bohibaColors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.white,
            height: 45,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: BohibaResponsiveScreen.width,
            height: 70,
            child: child,
          ),
        ],
      ),
    );
  }
}

import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';

class BlueBoxComponent extends StatelessWidget {
  final String label1;
  final String label2;
  final Widget child;

  const BlueBoxComponent({
    super.key,
    this.label1 = "Header",
    this.label2 = "Sub Header",
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BohibaResponsiveScreen.width,
      height: BohibaResponsiveScreen.height * 0.233,
      margin: EdgeInsets.only(bottom: BohibaResponsiveScreen.height15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bohibaColors.primaryVariantColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: BohibaResponsiveScreen.width10,
              top: BohibaResponsiveScreen.width25,
            ),
            child: Text(
              label1,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.headlineLarge!.fontSize,
                fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                color: bohibaColors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: BohibaResponsiveScreen.width10),
            child: Text(
              label2,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                color: bohibaColors.white,
              ),
            ),
          ),
          Spacer(),
          Divider(
            color: bohibaColors.white,
            // height: 45,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Container(
            padding: EdgeInsets.only(left: BohibaResponsiveScreen.width10),
            width: BohibaResponsiveScreen.width,
            height: 70,
            child: child,
          ),
        ],
      ),
    );
  }
}

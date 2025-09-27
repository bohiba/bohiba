import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import 'package:flutter/material.dart';

class BlueBoxComponent extends StatelessWidget {
  final String label1;
  final String? label2;
  final String? label3;
  final Widget child;

  const BlueBoxComponent({
    super.key,
    this.label1 = "Header",
    this.label2,
    this.label3,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtils.width,
      height: ScreenUtils.height * 0.233,
      margin: EdgeInsets.only(bottom: ScreenUtils.height15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bohibaTheme.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtils.width10,
              top: ScreenUtils.width25,
            ),
            child: Text(
              label1,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.headlineLarge!.fontSize,
                fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                color: bohibaTheme.textTheme.displayLarge!.color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtils.width10),
            child: Text(
              label2 ?? 'NA',
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                color: bohibaTheme.textTheme.displayLarge!.color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtils.width10),
            child: Text(
              label3 ?? 'NA',
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                color: bohibaTheme.textTheme.displayLarge!.color,
              ),
            ),
          ),
          Spacer(),
          Divider(
            // height: 45,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenUtils.width10),
            width: ScreenUtils.width,
            height: 70,
            child: child,
          ),
        ],
      ),
    );
  }
}

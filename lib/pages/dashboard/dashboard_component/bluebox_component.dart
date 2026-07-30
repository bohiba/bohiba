import '/component/ui/tile_decorative.dart';
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
    final theme = Theme.of(context);
    return Container(
      width: ScreenUtils.width,
      height: ScreenUtils.height * 0.233,
      margin: EdgeInsets.only(bottom: ScreenUtils.height15),
      decoration: TileDecorative(color: theme.primaryColor),
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
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.textTheme.displayLarge?.color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtils.width10),
            child: Text(
              label2 ?? 'NA',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.textTheme.displayLarge?.color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtils.width10),
            child: Text(
              label3 ?? 'NA',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.displayLarge?.color,
              ),
            ),
          ),
          const Spacer(),
          const Divider(),
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

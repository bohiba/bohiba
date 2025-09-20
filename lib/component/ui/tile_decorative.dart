import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bohiba_colors.dart';

// class TileGradientDecoration extends BoxDecoration {
//   TileGradientDecoration()
//       : super(
//           color: bohibaTheme.cardColor,
//           borderRadius: BorderRadius.circular(12.0),
//         );
// }

class TileDecorative extends BoxDecoration {
  TileDecorative({Color? color})
      : super(
          // color: BohibaColors.lightGreyColor,
          color: color ?? bohibaTheme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
        );
}

class BottomModalShape extends RoundedRectangleBorder {
  BottomModalShape()
      : super(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.0.r),
            topLeft: Radius.circular(12.0.r),
          ),
        );
}

class AppMenuShape extends RoundedRectangleBorder {
  AppMenuShape()
      : super(
          borderRadius: BorderRadius.circular(12),
        );
}

class TileDecorativeWithBorder extends BoxDecoration {
  TileDecorativeWithBorder()
      : super(
          color: BohibaColors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: BohibaColors.primaryVariantColor,
            width: 1,
          ),
        );
}

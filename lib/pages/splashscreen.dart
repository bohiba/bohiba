import '/controllers/splash_controller.dart';
import 'package:get/get.dart';
import '/component/image_path.dart';
import 'package:flutter/material.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   'Bohiba',
                  //   style: TextStyle(
                  //     fontSize: 48,
                  //     fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                  //     color: bohibaTheme.textTheme.bodySmall!.color,
                  //   ),
                  // )

                  Image.asset(
                    ImagePath.bohibaIcon,
                    width: ScreenUtils.width * 0.5,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: ScreenUtils.height30),
                child: Text(
                  'Aspiring mine transportation',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

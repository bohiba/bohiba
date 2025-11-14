import '/theme/bohiba_theme.dart';

import '/dist/component_exports.dart';
import 'package:flutter/material.dart';

class HomeTopTipper extends StatelessWidget {
  const HomeTopTipper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.width15,
          ),
          child: Row(
            children: [
              Text(
                'Your Top Tipper\'s',
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(ScreenUtils.width5),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtils.height8,
                      horizontal: ScreenUtils.width10),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                      color: bohibaTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Top Tipper's List
        // Padding(
        //   padding: EdgeInsets.only(
        //     left: ScreenUtils.width15,
        //     right: ScreenUtils.width15,
        //     bottom: ScreenUtils.height25,
        //   ),
        //   child: Container(
        //     alignment: Alignment.center,
        //     child: ListView.builder(
        //         physics: const NeverScrollableScrollPhysics(),
        //         shrinkWrap: true,
        //         itemCount: 3,
        //         itemBuilder: (context, index) {
        //           return TopVehicleTile();
        //         }),
        //   ),
        // )
      ],
    );
  }
}


/*

*/
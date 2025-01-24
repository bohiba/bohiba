import '../../../../dist/component_exports.dart';
import '/pages/vehicle/top_vehicle_tile.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';

class HomeTopTipper extends StatelessWidget {
  const HomeTopTipper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: BohibaResponsiveScreen.width15,
          ),
          child: Row(
            children: [
              Text(
                'Your Top Tipper\'s',
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              const Spacer(),
              InkWell(
                borderRadius:
                    BorderRadius.circular(BohibaResponsiveScreen.width5),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: BohibaResponsiveScreen.height8,
                      horizontal: BohibaResponsiveScreen.width10),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                      color: bohibaColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Top Tipper's List
        Padding(
          padding: EdgeInsets.only(
            left: BohibaResponsiveScreen.width15,
            right: BohibaResponsiveScreen.width15,
            bottom: BohibaResponsiveScreen.height25,
          ),
          child: Container(
            alignment: Alignment.center,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return TopVehicleTile();
                }),
          ),
        )
      ],
    );
  }
}


/*

*/
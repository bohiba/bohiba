import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marquee_text/marquee_text.dart';

class HomePopularSection extends StatefulWidget {
  const HomePopularSection({super.key});

  @override
  State<HomePopularSection> createState() => _HomePopularSectionState();
}

class _HomePopularSectionState extends State<HomePopularSection> {
  @override
  Widget build(BuildContext context) {
    List materialType = [
      MaterialType(
        material: "Bauxite",
        arguments: {
          "current_index": 1,
          "market_screen_index": 7,
        },
      ),
      MaterialType(
        material: "Chromite",
        arguments: {
          "current_index": 1,
          "market_screen_index": 6,
        },
      ),
      MaterialType(
        material: "Coal",
        arguments: {
          "current_index": 1,
          "market_screen_index": 3,
        },
      ),
      MaterialType(
        material: "Gold",
        arguments: {
          "current_index": 1,
          "market_screen_index": 9,
        },
      ),
      MaterialType(
        material: "Graphite",
        arguments: {
          "current_index": 1,
          "market_screen_index": 4,
        },
      ),
      MaterialType(
        material: "Iron",
        arguments: {
          "current_index": 1,
          "market_screen_index": 2,
        },
      ),
      MaterialType(
        material: "Lead",
        arguments: {
          "current_index": 1,
          "market_screen_index": 5,
        },
      ),
      MaterialType(
        material: "Limestone",
        arguments: {
          "current_index": 1,
          "market_screen_index": 8,
        },
      ),
      MaterialType(
        material: "Manganese",
        arguments: {
          "current_index": 1,
          "market_screen_index": 9,
        },
      ),
      MaterialType(
        material: "Zinc",
        arguments: {
          "current_index": 1,
          "market_screen_index": 9,
        },
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtils.width15,
        bottom: ScreenUtils.height30,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Popular', style: bohibaTheme.textTheme.headlineLarge),
          ),
          Gap(ScreenUtils.height * 0.005),
          SizedBox(
            width: ScreenUtils.width,
            height: ScreenUtils.height * 0.45,
            child: GridView.builder(
              itemCount: materialType.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.5,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0),
              itemBuilder: (context, index) {
                MaterialType materialTypes = materialType[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoute.navBar,
                    arguments: {
                      "current_index": 2,
                      "market_screen_index": index + 2
                    },
                  ),
                  child: Container(
                    height: ScreenUtils.height * 0.14,
                    width: ScreenUtils.width * 0.45,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtils.width10,
                        vertical: ScreenUtils.height10),
                    decoration: BoxDecoration(
                      color: BohibaColors.tileColor,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        width: 0.0,
                        color: BohibaColors.tileColor,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtils.width10,
                            vertical: ScreenUtils.height5,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: ScreenUtils.width * 0.30,
                                child: AutoSizeText(
                                  materialTypes.material,
                                  maxLines: 1,
                                  minFontSize: 24,
                                  style: TextStyle(
                                    fontWeight: bohibaTheme
                                        .textTheme.displaySmall!.fontWeight,
                                    fontFamily: bohibaTheme
                                        .textTheme.displaySmall!.fontFamily,
                                  ),
                                  overflowReplacement: MarqueeText(
                                    speed: 10,
                                    alwaysScroll: false,
                                    text: TextSpan(
                                      text: materialTypes.material,
                                      style: TextStyle(
                                        fontSize: bohibaTheme
                                            .textTheme.displaySmall!.fontSize,
                                        fontWeight: bohibaTheme
                                            .textTheme.displaySmall!.fontWeight,
                                        fontFamily: bohibaTheme
                                            .textTheme.displaySmall!.fontFamily,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Gap(ScreenUtils.width10),
                              Text(
                                Random().nextInt(10).toString(),
                                style: bohibaTheme.textTheme.headlineSmall,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class MaterialType {
  final String material;
  final dynamic arguments;

  MaterialType({required this.material, this.arguments});
}

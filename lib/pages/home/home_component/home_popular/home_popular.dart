import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:bohiba/routes/bohiba_route.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/pages/home/home_string/home_strings.dart';
import 'package:gap/gap.dart';
import 'package:marquee_text/marquee_text.dart';

class HomePopularSection extends StatefulWidget {
  const HomePopularSection({Key? key}) : super(key: key);

  @override
  State<HomePopularSection> createState() => _HomePopularSectionState();
}

class _HomePopularSectionState extends State<HomePopularSection> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
        material: "Manganesessssss",
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
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            child: Text(HomePopularString.popular,
                style: Theme.of(context).textTheme.headlineLarge),
          ),
          SizedBox(height: height * 0.005),
          SizedBox(
            width: width,
            height: height * 0.45,
            child: GridView.builder(
              itemCount: materialType.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2.5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 1.0),
              itemBuilder: (context, index) {
                MaterialType materialTypes = materialType[index];
                return InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                    BohibaRoute.navBar,
                    arguments: {
                      "current_index": 1,
                      "market_screen_index": index + 2
                    },
                  ),
                  child: Container(
                    height: height * 0.14,
                    width: width * 0.45,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: bohibaColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5.0,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 120,
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
                              Gap(BohibaResponsiveScreen.width10),
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

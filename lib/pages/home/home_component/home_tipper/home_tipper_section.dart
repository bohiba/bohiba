import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/utils/bohiba_text/bohiba_marquee_text.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeBestTipper extends StatelessWidget {
  const HomeBestTipper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(BohibaResponsiveScreen.height * 0.01),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: BohibaResponsiveScreen.width8,
          ),
          child: Row(
            children: [
              Text(
                'Top Tipper\'s',
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
        Column(
          children: List.generate(
            3,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    width: MediaQuery.sizeOf(context).width,
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(colors: [
                        bohibaColors.primaryVariantColor.withOpacity(0.04),
                        Colors.grey.shade100
                      ], radius: 0.8, center: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 55,
                                height: 55,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      bohibaColors.primaryVariantColor,
                                  // child: Image(
                                  //   image: NetworkImage(com),
                                  //   fit: BoxFit.cover,
                                  //   errorBuilder: (context, object, stackTrace) {
                                  //     return CircleAvatar(
                                  //       radius: 25,
                                  //       backgroundColor: Colors.grey.shade200,
                                  //     );
                                  //   },
                                  // ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BohibaMarqueeText(
                                    width: 170,
                                    text: 'Odisha Minning',
                                    overflowText: 'OMC',
                                    style: TextStyle(
                                      fontSize: 14.fontSize,
                                      fontWeight: FontWeight.w500,
                                      color: bohibaColors.greyColor,
                                    ),
                                    marqueeTextStyle: TextStyle(
                                      fontSize: 14.fontSize,
                                      fontWeight: FontWeight.w500,
                                      color: bohibaColors.greyColor,
                                    ),
                                  ),
                                  const Gap(2),
                                  BohibaMarqueeText(
                                    width: 170,
                                    text: 'Odisha Minning Corporation Ltd.',
                                    overflowText: 'OMC',
                                    style: TextStyle(
                                      fontSize: 12.fontSize,
                                      fontWeight: FontWeight.w500,
                                      color: bohibaColors.black,
                                    ),
                                    marqueeTextStyle: TextStyle(
                                      fontSize: 12.fontSize,
                                      fontWeight: FontWeight.w500,
                                      color: bohibaColors.black,
                                    ),
                                  ),
                                ],
                              ),
                              /*const Spacer(),*/
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (tapDownDetails) {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                tapDownDetails.globalPosition.dx,
                                tapDownDetails.globalPosition.dy,
                                0,
                                0,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              items: const [
                                PopupMenuItem(
                                  value: 'add_driver',
                                  child: Text('Add Load'),
                                ),
                                PopupMenuItem(
                                  value: 'add_load',
                                  child: Text('Edit Tipper'),
                                ),
                                PopupMenuItem(
                                  value: 'add_driver',
                                  child: Text('Edit Driver'),
                                ),
                              ],
                            );
                          },
                          child: const Icon(EvaIcons.moreVertical),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Gap(BohibaResponsiveScreen.height * 0.01),
      ],
    );
  }
}

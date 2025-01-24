import 'package:auto_size_text/auto_size_text.dart';
import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marquee_text/marquee_text.dart';
import '../../../../model/company_details_model.dart';
import '../../../company/company_screen/company_screen.dart';

class MarketHorizonCard extends StatefulWidget {
  final VoidCallback? onTap;

  const MarketHorizonCard({
    super.key,
    this.onTap,
  });

  @override
  State<MarketHorizonCard> createState() => _MarketHorizonCardState();
}

class _MarketHorizonCardState extends State<MarketHorizonCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(
          // left: BohibaResponsiveScreen.width15,
          // right: BohibaResponsiveScreen.width15,
          bottom: BohibaResponsiveScreen.height5,
        ),
        padding: EdgeInsets.symmetric(
          vertical: BohibaResponsiveScreen.height5,
          horizontal: BohibaResponsiveScreen.width15,
        ),
        width: BohibaResponsiveScreen.width,
        height: 65,
        decoration: TileDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: bohibaColors.primaryVariantColor,
                  ),
                  Gap(BohibaResponsiveScreen.width20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BohibaMarqueeText(
                        width: BohibaResponsiveScreen.width * 0.5,
                        text: 'Odisha Minning',
                        overflowText: 'OMC',
                        style: TextStyle(
                          fontSize: 14.adaptSize,
                          fontWeight: FontWeight.w500,
                          color: bohibaColors.greyColor,
                        ),
                        marqueeTextStyle: TextStyle(
                          fontSize: 14.adaptSize,
                          fontWeight: FontWeight.w500,
                          color: bohibaColors.greyColor,
                        ),
                      ),
                      BohibaMarqueeText(
                        width: BohibaResponsiveScreen.width * 0.19,
                        text: 'Odisha Minning Corporation Ltd.',
                        overflowText: 'OMC',
                        style: TextStyle(
                          fontSize: 12.adaptSize,
                          fontWeight: FontWeight.w500,
                          color: bohibaColors.black,
                        ),
                        marqueeTextStyle: TextStyle(
                          fontSize: 12.adaptSize,
                          fontWeight: FontWeight.w500,
                          color: bohibaColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails tapDownDetails) => showMenu(
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
                items: [
                  PopupMenuItem(
                    value: 'add_driver',
                    child: Text(
                      'Book',
                      style: bohibaTheme.textTheme.labelMedium,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'add_load',
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.labelMedium!.fontWeight,
                        color: bohibaColors.warningColor,
                      ),
                    ),
                  ),
                ],
              ),
              child: const Icon(EvaIcons.moreVertical),
            )
          ],
        ),
      ),
    );
  }
}

class MarketVerticalCard extends StatefulWidget {
  final CompanyDetailModel company;

  const MarketVerticalCard({super.key, required this.company});

  @override
  State<MarketVerticalCard> createState() => _MarketVerticalCardState();
}

class _MarketVerticalCardState extends State<MarketVerticalCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CompanyScreen()));
      },
      child: Container(
        width: BohibaResponsiveScreen.width * 0.35,
        height: BohibaResponsiveScreen.height20,
        margin: EdgeInsets.only(
          right: BohibaResponsiveScreen.width10,
        ),
        decoration: BoxDecoration(
          color: bohibaColors.tileColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            width: 0.0,
            color: bohibaColors.tileColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: bohibaColors.white,
                backgroundImage: NetworkImage(widget.company.consigneeLogo!),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: BohibaResponsiveScreen.width10,
                  right: BohibaResponsiveScreen.width10,
                  top: BohibaResponsiveScreen.height10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    widget.company.consignerName ?? "",
                    style: bohibaTheme.textTheme.labelMedium,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflowReplacement: MarqueeText(
                      alwaysScroll: true,
                      speed: 5,
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        style: bohibaTheme.textTheme.labelMedium,
                        text: widget.company.consignerName ?? "",
                      ),
                    ),
                  ),
                  Text(
                    widget.company.loc!,
                    style: TextStyle(
                        fontSize: 10, color: bohibaColors.secoundaryColor),
                  ),
                  const Text(
                    '₹/Ton',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

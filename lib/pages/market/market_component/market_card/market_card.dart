import 'package:auto_size_text/auto_size_text.dart';
import 'package:bohiba/utils/bohiba_text/bohiba_marquee_text.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marquee_text/marquee_text.dart';
import '../../../../utils/bohiba_colors.dart';
import '../../../../data/models/company_details_model.dart';
import '../../../company/company_screen/company_screen.dart';

class MarketHorizonCard extends StatefulWidget {
  final VoidCallback? onTap;

  const MarketHorizonCard({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<MarketHorizonCard> createState() => _MarketHorizonCardState();
}

class _MarketHorizonCardState extends State<MarketHorizonCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: bohibaColors.primaryVariantColor,
                    ),
                    const Gap(10),
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
      ),
    );
  }
}

class MarketVerticalCard extends StatefulWidget {
  final CompanyDetailModel company;

  const MarketVerticalCard({Key? key, required this.company}) : super(key: key);

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
    return SizedBox(
      width: BohibaResponsiveScreen.width * 0.35,
      height: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CompanyScreen()));
        },
        child: Card(
          elevation: 0.5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(widget.company.consigneeLogo!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
      ),
    );
  }
}

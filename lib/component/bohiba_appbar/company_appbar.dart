import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/component/bohiba_text/bohiba_marquee_text.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/company/company_component/company_create_alert/company_create_alert.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:bohiba/services/company_option_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class CompanyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CompanyAppBar({
    Key? key,
    this.title = 'Title',
  }) : super(key: key);

  @override
  State<CompanyAppBar> createState() => _CompanyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}

class _CompanyAppBarState extends State<CompanyAppBar> {
  bool favorite = true;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: AppBar(
        centerTitle: false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Remix.arrow_left_line,
          ),
        ),
        title: const CompanyNameLogo(
          companyName: 'OMC',
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                favorite = !favorite;
              });
            },
            child: SizedBox.fromSize(
              size: Size(
                BohibaResponsiveScreen.height47,
                BohibaResponsiveScreen.height47,
              ),
              child: favorite
                  ? const Icon(
                      Remix.heart_3_line,
                    )
                  : const Icon(
                      Remix.heart_3_fill,
                      color: Colors.redAccent,
                    ),
            ),
          ),
          GestureDetector(
            onTapDown: (TapDownDetails tapDownDetails) {
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
                    Radius.circular(10),
                  ),
                ),
                items: _buildPopMenuItemList(),
              ).then((value) {
                switch (value) {
                  case CompanyOptionService.alert:
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight:
                                Radius.circular(BohibaResponsiveScreen.width15),
                            topLeft:
                                Radius.circular(BohibaResponsiveScreen.width15),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return const CompanyCreateAlert();
                        });
                    break;
                  case CompanyOptionService.raiseQuery:
                    break;
                  case CompanyOptionService.report:
                    break;
                  default:
                }
              });
            },
            child: SizedBox.fromSize(
              size: Size(
                BohibaResponsiveScreen.height47,
                BohibaResponsiveScreen.height47,
              ),
              child: const Icon(
                Remix.more_2_fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyNameLogo extends StatelessWidget {
  final ImageProvider? imageProvider;
  final String companyName;
  const CompanyNameLogo({
    super.key,
    this.imageProvider,
    this.companyName = 'company_name',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: bohibaColors.lightGreyColor,
          backgroundImage: imageProvider,
        ),
        Gap(BohibaResponsiveScreen.width5),
        BohibaMarqueeText(
          width: BohibaResponsiveScreen.width * 0.5,
          text: 'company_name',
          overflowText: 'OMC',
        )
      ],
    );
  }
}

List<PopupMenuItem<String>> _buildPopMenuItemList() {
  return [
    PopupMenuItem(
      value: CompanyOptionService.alert,
      child: Text(
        'Alert',
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
          fontWeight: bohibaTheme.textTheme.titleSmall!.fontWeight,
        ),
      ),
    ),
    PopupMenuItem(
      value: CompanyOptionService.report,
      child: Text(
        'Report',
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
          fontWeight: bohibaTheme.textTheme.titleSmall!.fontWeight,
        ),
      ),
    ),
    PopupMenuItem(
      value: CompanyOptionService.raiseQuery,
      child: Text(
        'Raise Query',
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
          fontWeight: bohibaTheme.textTheme.titleSmall!.fontWeight,
        ),
      ),
    ),
  ];
}

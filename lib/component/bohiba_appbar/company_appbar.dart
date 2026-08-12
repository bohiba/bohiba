import 'package:auto_size_text/auto_size_text.dart';
import 'package:bohiba/controllers/companies_controller.dart';
import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';

import '/theme/bohiba_theme.dart';

import '/component/bohiba_text/bohiba_marquee_text.dart';
import '/component/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

import 'appbar_icon.dart';

class CompanyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CompaniesController controller;

  const CompanyAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        // centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: AutoSizeText(
          controller.minesModel.value?.name ?? 'NA',
          maxLines: 1,
          style: bohibaTheme.appBarTheme.titleTextStyle,
          overflowReplacement: MarqueeText(
            speed: 10,
            alwaysScroll: true,
            style: bohibaTheme.appBarTheme.titleTextStyle,
            text: TextSpan(
              text: controller.minesModel.value?.nameCode ?? '',
            ),
          ),
        ),
        titleSpacing: 0,
        actions: [
          Obx(
            () {
              return AppBarIconBox(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width5),
                onTap: () async => controller.syncFavourite(),
                icon: (controller.minesModel.value?.isFav ?? false)
                    ? Icon(
                        Icons.favorite_rounded,
                        color: bohibaTheme.colorScheme.tertiary,
                      )
                    : Icon(Icons.favorite_border_rounded),
              );
            },
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
                constraints: BoxConstraints(
                  minWidth: ScreenUtils.width * 0.3,
                  maxWidth: ScreenUtils.width * 0.3,
                ),
                items: _buildPopMenuItemList(),
              ).then((value) {
                switch (value) {
                  case 0:
                    break;
                  case 1:
                    break;
                  default:
                }
              });
            },
            child: SizedBox.fromSize(
              size: Size(
                ScreenUtils.height47,
                ScreenUtils.height47,
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

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
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
          backgroundColor: bohibaTheme.dividerColor,
          backgroundImage: imageProvider,
        ),
        Gap(ScreenUtils.width20),
        BohibaMarqueeText(
          width: ScreenUtils.width * 0.35,
          text: companyName,
          overflowText: companyName,
        )
      ],
    );
  }
}

List<PopupMenuItem<int>> _buildPopMenuItemList() {
  return [
    PopupMenuItem(
      value: 0,
      child: Text(
        'Report',
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
          fontWeight: bohibaTheme.textTheme.titleSmall!.fontWeight,
        ),
      ),
    ),
    PopupMenuItem(
      value: 1,
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

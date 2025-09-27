import '/theme/bohiba_theme.dart';

import '/component/bohiba_text/bohiba_marquee_text.dart';
import '/component/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class CompanyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CompanyAppBar({super.key, this.title = 'NA'});

  @override
  State<CompanyAppBar> createState() => _CompanyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}

class _CompanyAppBarState extends State<CompanyAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: AppBar(
        // centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(widget.title),
        titleSpacing: 0,
        actions: [
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

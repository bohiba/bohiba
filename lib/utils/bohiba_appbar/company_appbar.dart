import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/company/company_component/company_create_alert/company_create_alert.dart';
import 'package:flutter/material.dart';
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
        leadingWidth: BohibaResponsiveScreen.width10 * 5.5,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Remix.arrow_left_line,
          ),
        ),
        title: const CircleAvatar(
          radius: 15,
        ),
        actions: [
          // GestureDetector(
          //   onTap: () {},
          //   child: SizedBox.fromSize(
          //     size: Size(
          //       BohibaResponsiveScreen.width50 + 10,
          //       BohibaResponsiveScreen.height55,
          //     ),
          //     child: const Icon(
          //       Remix.history_line,
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(BohibaResponsiveScreen.width15),
                      topLeft: Radius.circular(BohibaResponsiveScreen.width15),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return const CompanyCreateAlert();
                  });
            },
            child: SizedBox.fromSize(
              size: Size(
                BohibaResponsiveScreen.width20 * 2,
                BohibaResponsiveScreen.height55,
              ),
              child: const Icon(
                Icons.access_alarm,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                favorite = !favorite;
              });
            },
            child: SizedBox.fromSize(
              size: Size(
                BohibaResponsiveScreen.width50 + 10,
                BohibaResponsiveScreen.height55,
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
        ],
      ),
    );
  }
}

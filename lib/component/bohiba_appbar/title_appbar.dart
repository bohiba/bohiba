import 'package:auto_size_text/auto_size_text.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';

class TitleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool popResult;
  final bool showLeading;
  const TitleAppbar({
    super.key,
    this.title = "",
    this.actions,
    this.popResult = false,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final navigate = Navigator.of(context);
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: showLeading ? 0 : null,
        leadingWidth: showLeading ? null : 0,
        title: AutoSizeText(
          title,
          maxLines: 1,
          style: bohibaTheme.appBarTheme.titleTextStyle,
          overflowReplacement: MarqueeText(
            speed: 10,
            alwaysScroll: true,
            style: bohibaTheme.appBarTheme.titleTextStyle,
            text: TextSpan(
              text: title,
            ),
          ),
        ),
        leading: showLeading
            ? InkWell(
                child: const Icon(Icons.arrow_back_ios_new_rounded),
                onTap: () {
                  navigate.pop(popResult);
                },
              )
            : SizedBox.shrink(),
        actionsPadding: EdgeInsets.only(right: ScreenUtils.width15),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

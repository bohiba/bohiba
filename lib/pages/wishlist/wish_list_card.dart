import '/pages/wishlist/wishlist_component/stack_wishlist_company_avatar.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../../dist/component_exports.dart';

class HomeWishListCard extends StatelessWidget {
  const HomeWishListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: BohibaResponsiveScreen.height10),
      padding: EdgeInsets.symmetric(
        horizontal: BohibaResponsiveScreen.width15,
        vertical: BohibaResponsiveScreen.height10,
      ),
      width: BohibaResponsiveScreen.width,
      height: BohibaResponsiveScreen.height * 0.075,
      decoration: TileDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const StackCompanyAvatar(),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16.adaptSize,
                color: bohibaColors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              children: const [
                TextSpan(text: 'OMC'),
                TextSpan(
                  text: '  -  ',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    // color: bohibaColors.greyColor,
                  ),
                ),
                TextSpan(text: 'Adhunik'),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onPanDown: (details) => showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                ),
                elevation: 0.2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                items: [
                  PopupMenuItem(
                    child: Text(
                      'Book',
                      style: bohibaTheme.textTheme.titleMedium,
                    ),
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        color: bohibaColors.warningColor,
                        fontStyle: bohibaTheme.textTheme.titleMedium!.fontStyle,
                        fontWeight:
                            bohibaTheme.textTheme.titleMedium!.fontWeight,
                      ),
                    ),
                  ),
                ]),
            child: Icon(EvaIcons.moreVertical),
          )
        ],
      ),
    );
  }
}

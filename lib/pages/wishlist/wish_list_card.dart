import 'package:bohiba/component/bohiba_buttons/small_tile_button.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/wishlist/wishlist_component/stack_wishlist_company_avatar.dart';
import 'package:flutter/material.dart';

class HomeWishListCard extends StatelessWidget {
  const HomeWishListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0, left: 10.0, right: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: BohibaResponsiveScreen.width,
      height: BohibaResponsiveScreen.height * 0.085,
      decoration: BoxDecoration(
        gradient: RadialGradient(colors: [
          bohibaColors.primaryVariantColor.withOpacity(0.04),
          Colors.grey.shade100
        ], radius: 0.8, center: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const StackCompanyAvatar(),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16.fontSize,
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
                    )),
                TextSpan(text: 'Adhunik'),
              ],
            ),
          ),
          const Spacer(),
          SmallTileButton(
            onTap: () {},
            label: 'Book',
          )
        ],
      ),
    );
  }
}

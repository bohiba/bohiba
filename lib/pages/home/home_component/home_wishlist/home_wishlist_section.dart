import 'package:bohiba/pages/wishlist/wish_list_card.dart';
import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/pages/home/home_string/home_strings.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomeWishListSection extends StatefulWidget {
  const HomeWishListSection({Key? key}) : super(key: key);

  @override
  State<HomeWishListSection> createState() => _HomeWishListSectionState();
}

class _HomeWishListSectionState extends State<HomeWishListSection> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      // visible: CompanyModel.companyList.isEmpty ? false : true,
      child: Column(
        children: [
          // Home WishList Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: BohibaResponsiveScreen.width8,
            ),
            child: Row(
              children: [
                Text(
                  HomeWishListString.wishList,
                  style: bohibaTheme.textTheme.headlineLarge,
                ),
                const Spacer(),
                InkWell(
                  borderRadius:
                      BorderRadius.circular(BohibaResponsiveScreen.width5),
                  onTap: () => Get.offNamedUntil(
                      BohibaRoute.navBar,
                      arguments: {
                        "current_index": 1,
                        "market_screen_index": 1,
                      },
                      (route) => false),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: BohibaResponsiveScreen.height8,
                        horizontal: BohibaResponsiveScreen.width10),
                    child: Text(
                      HomeWishListString.seeAll,
                      style: TextStyle(
                        fontSize:
                            bohibaTheme.textTheme.headlineMedium!.fontSize,
                        color: bohibaColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(BohibaResponsiveScreen.height5),

          // Home WishList Section
          Container(
            alignment: Alignment.center,
            child:
                /*CompanyModel.companyList.isEmpty
                ? Center(
                    child: TextButton(
                      onPressed: () => Get.offNamedUntil(
                        BohibaRoute.navBar,
                        arguments: {
                          "current_index": 1,
                          "market_screen_index": 1,
                        },
                        (route) => false,
                      ),
                      child: const Text('Add Company'),
                    ),
                  )
                : */

                ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return const HomeWishListCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

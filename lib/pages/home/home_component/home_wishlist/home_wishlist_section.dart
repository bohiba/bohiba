import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/pages/home/home_string/home_strings.dart';
import 'package:get/get.dart';

import '../../../../data/models/company_details_model.dart';
import '../../../market/market_component/market_card/market_card.dart';

class HomeWishListSection extends StatefulWidget {
  const HomeWishListSection({Key? key}) : super(key: key);

  @override
  State<HomeWishListSection> createState() => _HomeWishListSectionState();
}

class _HomeWishListSectionState extends State<HomeWishListSection> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: CompanyModel.companyList.isEmpty ? false : true,
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
          SizedBox(height: BohibaResponsiveScreen.height5),

          // Home WishList Section
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 0.087 * BohibaResponsiveScreen.width50,
            ),
            child: CompanyModel.companyList.isEmpty
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
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return MarketHorizonCard(
                        onTap: () {
                          Get.toNamed(
                            BohibaRoute.companyScreen,
                            arguments: {
                              "id": CompanyModel.companyList[index].id,
                              "consigner_name":
                                  CompanyModel.companyList[index].consignerName,
                              "consigner_Logo":
                                  CompanyModel.companyList[index].consigneeLogo,
                              "loc": CompanyModel.companyList[index].loc,
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

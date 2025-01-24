import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_buttons/secoundary_button.dart';
import '/component/bohiba_buttons/primary_icon_button.dart';
import '/component/bohiba_colors.dart';
import '../../home_string/home_strings.dart';
import '/routes/bohiba_route.dart';
import '/theme/light_theme.dart';

class HomeAccountSection extends StatefulWidget {
  const HomeAccountSection({super.key});

  @override
  State<HomeAccountSection> createState() => _HomeAccountSectionState();
}

class _HomeAccountSectionState extends State<HomeAccountSection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoute.walletScreen),
      child: Padding(
        padding: EdgeInsets.only(
          top: BohibaResponsiveScreen.height20,
          left: BohibaResponsiveScreen.width15,
          right: BohibaResponsiveScreen.width15,
          bottom: BohibaResponsiveScreen.height30,
        ),
        child: Column(
          children: [
            Container(
              width: BohibaResponsiveScreen.width,
              height: BohibaResponsiveScreen.height * 0.135,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  BohibaResponsiveScreen.width15,
                ),
                border: Border.all(
                  width: 0.0,
                ),
                color: bohibaColors.primaryColor,
              ),
              child: Stack(
                children: [
                  Container(
                    width: BohibaResponsiveScreen.width * 0.85,
                    height: BohibaResponsiveScreen.height * 0.135,
                    padding: EdgeInsets.symmetric(
                      vertical: BohibaResponsiveScreen.height15,
                      horizontal: BohibaResponsiveScreen.width20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      border: Border.all(
                        width: 0.0,
                        color: bohibaColors.tileColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        BohibaResponsiveScreen.width15,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Available Money
                        Text(
                          HomeAccountString.currentBalance,
                          style: bohibaTheme.textTheme.titleMedium,
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: BohibaResponsiveScreen.height15,
                              ),
                              child: Text(
                                '₹1249.89',
                                style: bohibaTheme.textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: BohibaResponsiveScreen.width25),
                      child: Container(
                        height: BohibaResponsiveScreen.height50,
                        width: BohibaResponsiveScreen.width50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            BohibaResponsiveScreen.width8,
                          ),
                        ),
                        child: const Icon(
                          Icons.keyboard_double_arrow_right_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Gap(BohibaResponsiveScreen.height5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryIconButton(
                  onPressed: () => Get.toNamed(
                    AppRoute.orderScreen,
                    arguments: {
                      "from_read_only": true,
                    },
                  ),
                  label: 'Book Load',
                  icon: const Icon(
                    Remix.ticket_2_fill,
                  ),
                  fixedSize: Size(
                    BohibaResponsiveScreen.width * 0.45,
                    BohibaResponsiveScreen.height * 0.043,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      BohibaResponsiveScreen.width10,
                    ),
                  ),
                  backgroundColor: bohibaColors.primaryColor,
                ),
                SecoundaryButton(
                  onPressed: () => Get.toNamed(AppRoute.walletDepositScreen),
                  label: 'Deposit INR',
                  fixedSize: Size(
                    BohibaResponsiveScreen.width * 0.45,
                    BohibaResponsiveScreen.height * 0.043,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      BohibaResponsiveScreen.width10,
                    ),
                    side: BorderSide(
                      color: bohibaColors.primaryVariantColor,
                      width: 1,
                    ),
                  ),
                  backgroundColor: bohibaColors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

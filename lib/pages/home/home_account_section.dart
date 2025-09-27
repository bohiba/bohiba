import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_buttons/secoundary_button.dart';
import '/component/bohiba_buttons/primary_icon_button.dart';
import '/component/bohiba_colors.dart';
import '/routes/app_route.dart';

class HomeAccountSection extends StatefulWidget {
  const HomeAccountSection({super.key});

  @override
  State<HomeAccountSection> createState() => _HomeAccountSectionState();
}

class _HomeAccountSectionState extends State<HomeAccountSection> {
  @override
  Widget build(BuildContext context) {
    NavigatorState navigate = Navigator.of(context);
    return GestureDetector(
      onTap: () {
        navigate.pushNamed(AppRoute.walletScreen);
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtils.width15,
          right: ScreenUtils.width15,
          bottom: ScreenUtils.height30,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryTextIconButton(
                  onPressed: () {
                    navigate.pushNamed(AppRoute.analytics);
                  },
                  label: 'Analytic',
                  widget: const Icon(
                    EvaIcons.pieChart,
                  ),
                  width: ScreenUtils.width * 0.45,
                  height: ScreenUtils.height * 0.043,
                ),
                SecoundaryButton(
                  onPressed: () {
                    navigate.pushNamed(AppRoute.addTrip);
                  },
                  // label: 'Deposit INR',
                  label: 'Add Trip',
                  textColor: BohibaColors.primaryColor,
                  width: ScreenUtils.width * 0.45,
                  height: ScreenUtils.height * 0.043,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

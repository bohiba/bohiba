import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:remixicon/remixicon.dart';
import '/pages/wallet/wallet_string/wallet_string.dart';
import '/dist/component_exports.dart';
import '/dist/widget_exports.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_buttons/utility_action_button.dart';
import '../wallet_deposit/wallet_deposit_component/current_balance/current_balance.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _Walletpagestate();
}

class _Walletpagestate extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: WalletString.title),
      body: Container(
        height: ScreenUtils.height,
        width: ScreenUtils.width,
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width15,
          vertical: ScreenUtils.height5,
        ),
        alignment: Alignment.center,
        color: BohibaColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BankDepositCurrentBalance(currentBalance: "₹1249.89"),
            Padding(
              padding: EdgeInsets.only(
                // left: BohibaResponsiveScreen.width15,
                // right: BohibaResponsiveScreen.width15,
                top: ScreenUtils.height20,
              ),
              child: Row(
                children: [
                  Text(
                    "Transactions History",
                    style: bohibaTheme.textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  UtilityActionButton(
                    onPanDown: (tapDownDetails) => showMenu(
                      context: context,
                      menuPadding: EdgeInsets.zero,
                      elevation: 4,
                      position: RelativeRect.fromLTRB(
                        tapDownDetails.localPosition.dx,
                        tapDownDetails.localPosition.dy +
                            ScreenUtils.height * 0.3,
                        0,
                        tapDownDetails.localPosition.dy,
                      ),
                      items: [
                        PopupMenuItem(
                          padding: EdgeInsets.zero,
                          enabled: false,
                          child: SortMenu(
                            dateSort: true,
                          ),
                        )
                      ],
                    ),
                    icon: Remix.arrow_up_down_line,
                    buttonName: 'Sort',
                  ),
                  UtilityActionButton(
                    onPanDown: (tapDownDetails) => showMenu(
                      context: context,
                      menuPadding: EdgeInsets.zero,
                      position: RelativeRect.fromLTRB(
                        tapDownDetails.localPosition.dx,
                        tapDownDetails.localPosition.dy +
                            ScreenUtils.height * 0.3,
                        0,
                        tapDownDetails.localPosition.dy,
                      ),
                      items: [
                        PopupMenuItem(
                          padding: EdgeInsets.zero,
                          enabled: false,
                          child: FilterMenu(
                            dateRange: true,
                          ),
                        )
                      ],
                    ),
                    icon: Remix.equalizer_2_line,
                    buttonName: 'Filter',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: BohibaColors.white,
                        child: Icon(
                          index % 2 == 0
                              ? EvaIcons.arrowUp
                              : EvaIcons.arrowDown,
                          color: index % 2 == 0
                              ? BohibaColors.successColor
                              : BohibaColors.warningColor,
                        ),
                      ),
                      title: Text(
                        index % 2 == 0 ? "Credited" : "Debited",
                        style: TextStyle(
                          fontStyle:
                              bohibaTheme.textTheme.labelLarge!.fontStyle,
                          fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                        ),
                      ),
                      subtitle: Text(
                        index % 2 == 0 ? "22/10/2024" : "02/12/2024",
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.headlineMedium!.fontWeight,
                        ),
                      ),
                      trailing: Text(
                        index % 2 == 0 ? "+ ₹5000" : "- ₹1000",
                        style: TextStyle(
                            fontSize:
                                bohibaTheme.textTheme.labelLarge!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.labelLarge!.fontWeight,
                            color: index % 2 == 0
                                ? BohibaColors.successColor
                                : BohibaColors.warningColor),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );

    /*return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                '₹1249.89',
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              background: Center(
                child: Text(
                  WalletString.title,
                  style: TextStyle(
                      fontSize: bohibaTheme.textTheme.displayLarge!.fontSize,
                      fontWeight:
                          bohibaTheme.textTheme.displayLarge!.fontWeight,
                      color: BohibaColors.primaryColor),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                height: 80,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PrimaryIconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WalletWithdrawScreen()));
                            },
                            label: WalletWithdrawString.withdraw,
                            icon: const Icon(EvaIcons.diagonalArrowRightUp),
                            fixedSize: Size(width * 0.45, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: BohibaColors.primaryColor),
                        SecoundaryButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WalletDepositScreen()));
                          },
                          label: WalletDepositString.depositINR,
                          fixedSize: Size(width * 0.45, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.black,
                              )),
                          backgroundColor: Colors.white,
                        )
                      ],
                    )
                  ],
                )),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return 
            }, childCount: 5),
          ),
        ],
      ),
    );*/
  }
}
/*
Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: BohibaResponsiveScreen.width15, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: BohibaColors.white,
                    child: Icon(
                      index % 2 == 0 ? EvaIcons.arrowUp : EvaIcons.arrowDown,
                      color: index % 2 == 0
                          ? BohibaColors.successColor
                          : BohibaColors.warningColor,
                    ),
                  ),
                  title: Text(
                    index % 2 == 0 ? "Credited" : "Debited",
                    style: TextStyle(
                      fontStyle: bohibaTheme.textTheme.labelLarge!.fontStyle,
                      fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                    ),
                  ),
                  subtitle: Text(
                    index % 2 == 0 ? "22/10/2024" : "02/12/2024",
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                      fontWeight:
                          bohibaTheme.textTheme.headlineMedium!.fontWeight,
                    ),
                  ),
                  trailing: Text(
                    index % 2 == 0 ? "+ ₹5000" : "- ₹1000",
                    style: TextStyle(
                        fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.labelLarge!.fontWeight,
                        color: index % 2 == 0
                            ? BohibaColors.successColor
                            : BohibaColors.warningColor),
                  ),
                ),
              );
*/

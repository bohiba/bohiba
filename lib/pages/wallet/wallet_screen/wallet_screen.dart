import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_buttons/secoundary_button.dart';
import 'package:bohiba/pages/wallet/wallet_string/wallet_string.dart';
import 'package:bohiba/pages/wallet/wallet_withdraw/wallet_withdraw_screen/wallet_withdraw_screen.dart';

import '../../../component/bohiba_buttons/primary_icon_button.dart';
import '../../../component/bohiba_colors.dart';
import '../wallet_deposit/wallet_deposit_screen/wallet_deposit_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _Walletpagestate();
}

class _Walletpagestate extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              background: Center(
                child: Text(
                  WalletString.title,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.displayLarge!.fontSize,
                      fontWeight:
                          Theme.of(context).textTheme.displayLarge!.fontWeight,
                      color: bohibaColors.primaryColor),
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
                            backgroundColor: bohibaColors.primaryColor),
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 2.5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white54,
                      child: Icon(
                        index % 2 == 0 ? EvaIcons.arrowDown : EvaIcons.arrowUp,
                        color: index % 2 == 0
                            ? bohibaColors.successColor
                            : bohibaColors.primaryColor,
                      ),
                    ),
                    title: Text(
                      index % 2 == 0 ? "INR Withdraw" : "INR Deposit",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    subtitle: Text(
                      index % 2 == 0 ? "Credited" : "Debited",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium!.fontSize,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontWeight,
                          color: index % 2 == 0
                              ? bohibaColors.successColor
                              : bohibaColors.primaryColor),
                    ),
                    trailing: Text(
                      index % 2 == 0 ? "+₹5000" : "-₹1000",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelLarge!.fontSize,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .fontWeight,
                          color: index % 2 == 0
                              ? bohibaColors.successColor
                              : bohibaColors.warningColor),
                    ),
                  ),
                ),
              );
            }, childCount: 20),
          ),
        ],
      ),
    );
  }
}

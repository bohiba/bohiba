import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_colors.dart';
import '/pages/wallet/wallet_string/wallet_string.dart';
import 'wallet_transaction_component/wallet_transaction_balance_card/wallet_transaction_balance_card.dart';

class WalletTransactionHistoryScreen extends StatelessWidget {
  const WalletTransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TitleAppbar(title: WalletString.titleTransac),
      body: Column(children: [
        const BankTransactionBalanceCard(),
        SizedBox(
          height: height * 0.02,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 2.5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white54,
                        child: Icon(
                          index % 2 == 0
                              ? EvaIcons.arrowUp
                              : EvaIcons.arrowDown,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      title: Text(
                        index % 2 == 0 ? "INR Withdraw" : "INR Deposit",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      subtitle: Text(
                        index % 2 == 0 ? "Completed" : "Initiated",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .fontSize,
                            fontWeight: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .fontWeight,
                            color: index % 2 == 0
                                ? Colors.green
                                : BohibaColors.primaryColor),
                      ),
                      trailing: Text(
                        index % 2 == 0 ? "₹1000" : "₹5000",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  );
                }))
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:bohiba/component/bohiba_inputfield/currency_inputfield.dart';

import '../../../../component/bohiba_appbar/title_appbar.dart';
import '../../../../component/bohiba_buttons/bottom_button.dart';
import '../../wallet_string/wallet_string.dart';
import '../wallet_deposit_component/current_balance/current_balance.dart';

class WalletDepositScreen extends StatefulWidget {
  const WalletDepositScreen({super.key});

  @override
  State<WalletDepositScreen> createState() => _WalletDepositScreenState();
}

class _WalletDepositScreenState extends State<WalletDepositScreen> {
  String depositAmount = "₹100.00";
  final MoneyMaskedTextController depositController = MoneyMaskedTextController(
    initialValue: 100,
    precision: 2,
    leftSymbol: "₹",
    decimalSeparator: ".",
    thousandSeparator: ",",
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    depositController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TitleAppbar(title: WalletDepositString.deposit),
      body: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: Column(
          children: [
            const BankDepositCurrentBalance(currentBalance: "₹1249.89"),
            SizedBox(height: height * 0.07),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                WalletString.enterAmount,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            CurrencyInputField(
              autoFocus: true,
              currencyController: depositController,
              onChanged: (value) {
                setState(() {
                  depositAmount = depositController.text;
                });
                debugPrint(depositAmount);
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              alignment: Alignment.centerLeft,
              child: Text(
                WalletDepositString.minMax,
                style: TextStyle(
                    fontWeight:
                        Theme.of(context).textTheme.labelMedium!.fontWeight,
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).textTheme.titleMedium!.color),
              ),
            ),
            /* BankDepositBalanceOption(controller: amountTEC,)*/
          ],
        ),
      ),
      bottomNavigationBar: depositController.numberValue >= 100.00 &&
              depositController.numberValue <= 10000.00
          ? BottomButton(
              width: width,
              onTap: () {
                debugPrint("Value: ${depositController.numberValue}");
              },
              labelPrice: "Deposit $depositAmount",
            )
          : BottomButton(
              width: width,
              onTap: null,
              labelPrice: "Deposit $depositAmount",
            ),
    );
  }
}

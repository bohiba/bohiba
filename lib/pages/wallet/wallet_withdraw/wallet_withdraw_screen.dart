import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_inputfield/currency_inputfield.dart';
import '/pages/wallet/wallet_string/wallet_string.dart';

import '../../../component/bohiba_buttons/bottom_button.dart';
import '../../../component/bohiba_colors.dart';

class WalletWithdrawScreen extends StatefulWidget {
  const WalletWithdrawScreen({super.key});

  @override
  State<WalletWithdrawScreen> createState() => _WalletWithdrawpagestate();
}

class _WalletWithdrawpagestate extends State<WalletWithdrawScreen> {
  String withdrawAmount = "₹500.00";
  final MoneyMaskedTextController withdrawController =
      MoneyMaskedTextController(
    initialValue: 500,
    precision: 2,
    leftSymbol: "₹",
    decimalSeparator: ".",
    thousandSeparator: ",",
  );

  @override
  void dispose() {
    withdrawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: TitleAppbar(
        title: WalletString.withdraw,
      ),
      body: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              WalletString.currentBalance,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text("₹1249.89",
                style: TextStyle(
                    fontWeight:
                        Theme.of(context).textTheme.headlineMedium!.fontWeight,
                    fontSize:
                        Theme.of(context).textTheme.headlineLarge!.fontSize,
                    color: Theme.of(context).textTheme.headlineMedium!.color)),
            const Spacer(),
            Text(
              WalletString.enterAmount,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            CurrencyInputField(
              autoFocus: true,
              maxLength: 12,
              currencyController: withdrawController,
              onChanged: (v) {
                setState(() {
                  withdrawAmount = v;
                });
              },
              decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: BohibaColors.primaryColor),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: BohibaColors.primaryColor),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                WalletString.minMax,
                style: TextStyle(
                    fontWeight:
                        Theme.of(context).textTheme.labelMedium!.fontWeight,
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).textTheme.titleMedium!.color),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
      bottomNavigationBar: withdrawController.numberValue >= 100.00 &&
              withdrawController.numberValue <= 200000.00
          ? BottomButton(
              width: width,
              onTap: () {
                debugPrint(withdrawController.numberValue.toString());
              },
              labelPrice: "Withdraw $withdrawAmount",
            )
          : BottomButton(
              width: width,
              onTap: null,
              labelPrice: "Withdraw $withdrawAmount",
            ),
    );
  }
}

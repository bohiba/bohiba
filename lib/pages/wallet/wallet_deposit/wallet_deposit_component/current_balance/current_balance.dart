import 'package:flutter/material.dart';

import '../../../wallet_string/wallet_string.dart';

class BankDepositCurrentBalance extends StatelessWidget {
  final String currentBalance;

  const BankDepositCurrentBalance({Key? key, this.currentBalance = '₹00.00'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 120,
      width: width * 0.95,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentBalance,
              style: TextStyle(
                  fontWeight:
                      Theme.of(context).textTheme.headlineMedium!.fontWeight,
                  fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                  color: Theme.of(context).textTheme.headlineMedium!.color)),
          Text(
            WalletString.currentBalance,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

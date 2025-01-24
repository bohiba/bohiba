import 'package:flutter/material.dart';

import '../../../../../component/bohiba_colors.dart';

class BankTransactionBalanceCard extends StatelessWidget {
  const BankTransactionBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: width,
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.0),
            color: bohibaColors.primaryVariantColor),
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('₹1000.00'),
                        Text('Current Balance'),
                      ],
                    ))),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
            ),
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Locked Balance'),
                        Text('₹0.00'),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}

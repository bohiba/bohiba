import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_text/payment_text.dart';
import 'package:remixicon/remixicon.dart';

import '../../component/bohiba_colors.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppbar(
        title: "Payment Screen",
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: bohibaTheme.dividerColor,
                child: Icon(
                  Remix.time_line,
                  size: 32,
                  color: BohibaColors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: Text(
                "Pending Status",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                "Transaction will be made within few minutes. If it takes too long please try connecting with us.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Column(
                  children: [
                    PaymentText(
                      leading: "Payment Status",
                      trailing: "Pending",
                      trailingColor: BohibaColors.warningColor,
                    ),
                    PaymentText(
                      leading: "Amount",
                      trailing: "₹408764.00",
                      trailingColor: BohibaColors.black,
                    ),
                    PaymentText(
                      leading: "Fuel Cost",
                      trailing: "- ₹7564.00",
                      trailingColor: BohibaColors.warningColor,
                    ),
                    const Divider(),
                    PaymentText(
                      leading: "Payable Amount",
                      trailing: "₹401200.00",
                      trailingColor: BohibaColors.successColor,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

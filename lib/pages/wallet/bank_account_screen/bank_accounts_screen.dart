import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';
import 'package:bohiba/component/bottom_nav_button/bottom_nav_button.dart';
import 'package:bohiba/component/bohiba_colors.dart';

class BankAccountsScreen extends StatelessWidget {
  const BankAccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int itemCount = 1;

    return Scaffold(
      //AppBar
      appBar: const TitleAppbar(
        title: "Bank Details",
      ),
      body: Container(
        constraints: const BoxConstraints.tightFor(height: 185),
        width: double.maxFinite,
        color: Colors.grey.shade50,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Bank Details",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Container(
              height: height * 0.7,
              constraints: const BoxConstraints.tightFor(height: 140),
              child: ListView.builder(
                itemCount: itemCount,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "*********7654",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            "PUNJAB NATIONAL BANK",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            "PNB",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          index == 0 ? const Divider() : Container(),
                        ],
                      ),
                      index % 2 == 1
                          ? TextButton(
                              onPressed: () {},
                              child: Text(
                                "Primary Account",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .fontSize,
                                    fontWeight: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .fontWeight,
                                    color: bohibaColors.primaryColor),
                              ),
                            )
                          : Container()
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        child: Container(
            height: height * 0.1,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.center,
            child: itemCount <= 1
                ? BottomNavButton(
                    width: width * 0.65,
                    label: "Add Account",
                    onPressed: () {},
                  )
                : BottomNavButton(
                    width: width * 0.65,
                    label: "Reached maximum limit",
                  )),
      ),
    );
  }
}

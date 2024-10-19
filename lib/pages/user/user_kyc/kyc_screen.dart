import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppbar(
        title: "KYC",
      ),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.grey.shade50,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "DOCUMENT",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(
                  "PAN",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  "DPEPM7651M",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                Text(
                  "Aadhar Card",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  "896599548745",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                Text(
                  "Signature",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  "img667534.img",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
      /*bottomNavigationBar: Material(
        child: Container(
            height: height * 0.1,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            alignment: Alignment.center,
            child: BottomNavButton(
              label: "Update Document",
              onPressed: () {},
            )),
      ),*/
    );
  }
}

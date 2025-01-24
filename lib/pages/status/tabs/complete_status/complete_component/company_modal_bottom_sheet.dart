import 'package:flutter/material.dart';
import 'package:bohiba/pages/payment/payment_screen/payment_screen.dart';
import 'package:remixicon/remixicon.dart';

import '../screen/challan_screen/challan_screen.dart';

class CompanyModalBottomSheet extends StatefulWidget {
  const CompanyModalBottomSheet({super.key});

  @override
  State<CompanyModalBottomSheet> createState() =>
      _CompanyModalBottomSheetState();
}

class _CompanyModalBottomSheetState extends State<CompanyModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: double.maxFinite,
      height: height * 0.25,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Container(
            width: width * 0.20,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          CompanyModalListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChallanScreen(),
                ),
              );
            },
            title: "View Challan",
            leadingIcon: Remix.file_paper_line,
          ),
          CompanyModalListTile(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentScreen(),
                ),
              );
            },
            title: "Payment Status",
            leadingIcon: Remix.funds_line,
          ),
          CompanyModalListTile(
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const ChallanScreen(),
              //   ),
              // );
            },
            title: "Raise Ticket",
            leadingIcon: Remix.hand_heart_line,
          ),
        ],
      ),
    );
  }
}

class CompanyModalListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final String title;

  const CompanyModalListTile(
      {super.key,
      this.onTap,
      this.leadingIcon,
      this.title = "Company Modal List Tile"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.grey.shade200,
        leading: Icon(leadingIcon),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

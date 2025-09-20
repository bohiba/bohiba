import 'package:flutter/material.dart';

class BankDepositBalanceOption extends StatefulWidget {
  final TextEditingController controller;

  const BankDepositBalanceOption({super.key, required this.controller});

  @override
  State<BankDepositBalanceOption> createState() =>
      _BankDepositBalanceOptionState();
}

class _BankDepositBalanceOptionState extends State<BankDepositBalanceOption> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 40,
      alignment: Alignment.center,
      child: ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            bool selected = false;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.5),
              child: Material(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      widget.controller.text = "₹${(index + 1) * 500}";
                      selected = !selected;
                    });
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: 75,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text("₹ ${(index + 1) * 500}"),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

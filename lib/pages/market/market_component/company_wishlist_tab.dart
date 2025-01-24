import 'package:flutter/material.dart';

import '../../../model/company_details_model.dart';
import 'market_card/market_card.dart';

class CompanyWishListTab extends StatefulWidget {
  const CompanyWishListTab({super.key});

  @override
  State<CompanyWishListTab> createState() => _CompanyWishListTabState();
}

class _CompanyWishListTabState extends State<CompanyWishListTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: CompanyModel.companyList.isEmpty ? 75 : 255,
      constraints: const BoxConstraints(minHeight: 75, maxHeight: 255),
      child: CompanyModel.companyList.isEmpty
          ? Center(
              child: TextButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => BohibaNavBar(
                //       currentIndex: 2,
                //     )));
              },
              child: const Text('Add Company'),
            ))
          : ListView.builder(
              itemCount: CompanyModel.companyList.length,
              itemBuilder: (context, index) {
                return const MarketHorizonCard();
              }),
    );
  }
}

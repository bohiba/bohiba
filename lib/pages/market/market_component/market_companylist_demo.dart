import 'package:flutter/material.dart';

import '../../../data/models/company_details_model.dart';
import 'market_card/market_card.dart';

class CompanyListDemo extends StatefulWidget {
  const CompanyListDemo({Key? key}) : super(key: key);

  @override
  State<CompanyListDemo> createState() => _CompanyListDemoState();
}

class _CompanyListDemoState extends State<CompanyListDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: CompanyModel.companyList.isEmpty ? 75 : 255,
      constraints: const BoxConstraints(minHeight: 75, maxHeight: 255),
      child: CompanyModel.companyList.isEmpty
          ? const Center(child: Text('No Available Company'))
          : ListView.builder(
              itemCount: CompanyModel.companyList.length,
              itemBuilder: (context, index) {
                return const MarketHorizonCard();
              }),
    );
  }
}

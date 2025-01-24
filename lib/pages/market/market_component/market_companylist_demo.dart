import 'package:flutter/material.dart';

import '../../../component/screen_utils.dart';
import '../../../model/company_details_model.dart';
import 'market_card/market_card.dart';

class CompanyListDemo extends StatefulWidget {
  const CompanyListDemo({super.key});

  @override
  State<CompanyListDemo> createState() => _CompanyListDemoState();
}

class _CompanyListDemoState extends State<CompanyListDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: CompanyModel.companyList.isEmpty ? 75 : 255,
      constraints: const BoxConstraints(minHeight: 75, maxHeight: 255),
      padding: EdgeInsets.only(
        top: BohibaResponsiveScreen.height10,
        left: BohibaResponsiveScreen.width15,
        right: BohibaResponsiveScreen.width15,
      ),
      child: CompanyModel.companyList.isEmpty
          ? const Center(
              child: Text('No Available Company'),
            )
          : ListView.builder(
              itemCount: CompanyModel.companyList.length,
              itemBuilder: (context, index) {
                return const MarketHorizonCard();
              },
            ),
    );
  }
}

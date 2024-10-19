import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_appbar/market_appbar.dart';
import 'package:bohiba/component/bohiba_strings/market_strings.dart';
import 'package:bohiba/pages/market/market_component/market_companylist_demo.dart';

import '../../../component/bohiba_colors.dart';
import '../../../models/company_details_model.dart';

class MarketPage extends StatefulWidget {
  final int moveToTab;

  const MarketPage({
    Key? key,
    this.moveToTab = 0,
  }) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  List tabs = [
    MarketTabs(text: "All"),
    MarketTabs(text: "WishList"),
    MarketTabs(text: "Bauxite"),
    MarketTabs(text: "Chromite"),
    MarketTabs(text: "Coal"),
    MarketTabs(text: "Graphite"),
    MarketTabs(text: "Iron"),
    MarketTabs(text: "Lead"),
    MarketTabs(text: "Limestone"),
    MarketTabs(text: "Manganese"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        initialIndex: widget.moveToTab,
        child: Scaffold(
          appBar: MarketAppBar(
            title: MarketStrings.appBarTitle,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                    isScrollable: true,
                    labelColor: bohibaColors.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: bohibaColors.primaryColor,
                    tabs: List.generate(tabs.length, (index) {
                      return Tab(text: tabs[index].text);
                    })),
                Expanded(
                  child: TabBarView(
                      children: List.generate(tabs.length, (index) {
                    return index % 2 == 0
                        ? const CompanyListDemo()
                        : Container(
                            height: CompanyModel.companyList.isEmpty ? 75 : 255,
                            constraints: const BoxConstraints(
                                minHeight: 75, maxHeight: 255),
                            child: const Center(
                                child: Text('No Available Company')),
                          );
                  })),
                ),
              ],
            ),
          ),
        ));
  }
}

class MarketTabs {
  final String text;
  MarketTabs({required this.text});
}

import 'dart:convert';

import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../model/company_details_model.dart';
import '../../../market/market_component/market_card/market_card.dart';
import '../../home_string/home_strings.dart';

class HomeMarketSection extends StatefulWidget {
  const HomeMarketSection({super.key});

  @override
  State<HomeMarketSection> createState() => _HomeMarketSectionState();
}

class _HomeMarketSectionState extends State<HomeMarketSection> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var catalogJSON = await rootBundle.loadString("assets/files/catalog.json");
    var decodeData = jsonDecode(catalogJSON);
    var companyDetail = decodeData["companyList"];
    // print(decodeData);
    CompanyModel.companyList = List.from(companyDetail)
        .map<CompanyDetailModel>(
            (company) => CompanyDetailModel.fromMap(company))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: BohibaResponsiveScreen.width15,
            left: BohibaResponsiveScreen.width15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                HomeMarketString.market,
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              Visibility(
                visible: CompanyModel.companyList.isEmpty ? false : true,
                child: GestureDetector(
                    onTap: () => Get.offNamedUntil(
                        AppRoute.navBar,
                        arguments: {
                          "current_index": 1,
                          "market_screen_index": 0,
                        },
                        (route) => false),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                      child: Text(
                        HomeMarketString.seeAll,
                        style: TextStyle(
                          fontSize:
                              bohibaTheme.textTheme.headlineMedium!.fontSize,
                          color: bohibaColors.primaryColor,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),

        // Home Market Section
        Container(
          height: BohibaResponsiveScreen.height * 0.195,
          margin: EdgeInsets.only(
              bottom: BohibaResponsiveScreen.height25,
              left: BohibaResponsiveScreen.width15),
          constraints: BoxConstraints(
            minHeight: 0.05 * BohibaResponsiveScreen.width50,
          ),
          child: CompanyModel.companyList.isEmpty
              ? const Center(
                  child: Text('No Load Available'),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CompanyModel.companyList.length,
                  itemBuilder: (context, index) {
                    return MarketVerticalCard(
                        company: CompanyModel.companyList[index]);
                  },
                ),
        ),
      ],
    );
  }
}

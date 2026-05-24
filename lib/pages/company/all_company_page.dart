import '/component/screen_utils.dart';
import '../../controllers/all_company_controller.dart';
import '../../model/company_model.dart';
import 'package:get/get.dart';
import '/component/bohiba_appbar/market_appbar.dart';
import 'company_card.dart';
import 'package:flutter/material.dart';

class AllCompanyPage extends GetView<AllCompanyController> {
  const AllCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinesAppBar(title: 'Mines'),
      body: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.only(
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
            top: ScreenUtils.height10,
          ),
          itemCount: controller.arrMines.length,
          itemBuilder: (context, index) {
            CompanyModel minesModel = controller.arrMines[index];
            return CompanyHorizontalCard(minesInfo: minesModel);
          },
        );
      }),
    );
  }
}

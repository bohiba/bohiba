
import '/component/screen_utils.dart';
import '/controllers/mines_controller.dart';
import '/model/mines_model.dart';
import 'package:get/get.dart';
import '/component/bohiba_appbar/market_appbar.dart';
import '/pages/mines/mines_card.dart';
import 'package:flutter/material.dart';

class AllMinesPage extends GetView<MinesController> {
  const AllMinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MinesAppBar(
        title: 'Mines',
      ),
      body: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.only(
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
            top: ScreenUtils.height10,
          ),
          itemCount: controller.arrMines.length,
          itemBuilder: (context, index) {
            MinesModel minesModel = controller.arrMines[index];
            return MinesHorizontalCard(minesInfo: minesModel);
          },
        );
      }),
    );
  }
}

import 'package:get/get.dart';
import '/model/mines_model.dart';
import '/services/mines_service.dart';

class AllMinesController extends GetxController {
  Rx<MinesModel> minesModel = MinesModel().obs;
  RxList<MinesModel> arrMines = <MinesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await _getMinesList();
    });
  }

  Future<List<MinesModel>?> _getMinesList() async {
    List<MinesModel>? minesList = await MinesService.getMinesList();
    if (minesList != null) {
      arrMines.clear();
      arrMines.addAll(minesList);
      return minesList;
    }

    return null;
  }
}

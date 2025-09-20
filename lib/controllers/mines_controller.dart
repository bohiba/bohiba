import '/model/mines_model.dart';
import '/services/db_service.dart';
import 'package:get/get.dart';

class MinesController extends GetxController {
  DBService dBService = DBService();
  Rx<MinesModel> minesModel = MinesModel().obs;
  RxList<MinesModel> arrMines = <MinesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await _getMinesList();
    });
  }

  Future<List<MinesModel>> _getMinesList() async {
    List<MinesModel> minesList = await dBService.getAllData(tblMines);
    arrMines.clear();
    arrMines.addAll(minesList);
    return minesList;
  }
}

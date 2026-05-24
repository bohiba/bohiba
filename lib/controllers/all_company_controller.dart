import 'package:get/get.dart';
import '../model/company_model.dart';
import '/services/company_service.dart';

class AllCompanyController extends GetxController {
  Rx<CompanyModel> minesModel = CompanyModel().obs;
  RxList<CompanyModel> arrMines = <CompanyModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await _getMinesList();
    });
  }

  Future<List<CompanyModel>?> _getMinesList() async {
    List<CompanyModel>? minesList = await CompanyService.getMinesList();
    if (minesList != null) {
      arrMines.clear();
      arrMines.addAll(minesList);
      return minesList;
    }

    return null;
  }
}

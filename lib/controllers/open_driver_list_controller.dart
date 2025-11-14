import '/model/driver_model.dart';
import '/services/open_driver_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class OpenDriverListController extends GetxController {
  RefreshController refreshController = RefreshController();
  Rxn<List<UserModel>> arrOpenDriver = Rxn<List<UserModel>>();

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await getAllOpenDriver(showLoading: false);
    });
  }

  Future<void> getAllOpenDriver({
    bool refresh = false,
    bool showLoading = true,
  }) async {
    List<UserModel>? openDriverList = await OpenDriverService.getAllOpenDriver(
      reset: refresh,
      showProgress: showLoading,
    );
    if (openDriverList != null) {
      if (refresh) arrOpenDriver.value?.clear();
      arrOpenDriver.value = List<UserModel>.from(openDriverList);
    }
  }
}

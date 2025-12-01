import '/model/user_model.dart';
import '/services/search_service.dart';
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
    arrOpenDriver.value = null;
    List<UserModel>? openDriverList = await OpenDriverService.getAllOpenDriver(
      reset: refresh,
      showProgress: showLoading,
    );
    if (openDriverList != null) {
      arrOpenDriver.value = List<UserModel>.from(openDriverList);
    }
  }

  var isLoading = false.obs;
  RxList<UserModel> results = <UserModel>[].obs;
  var lastQuery = "";

  Future<void> searchUser(String query) async {
    if (query.isEmpty) {
      results.clear();
      return;
    }

    // Avoid duplicate API calls
    if (query == lastQuery) return;
    lastQuery = query;

    isLoading.value = true;

    List<UserModel> searchResult = await SearchService.searchUser(query);
    if (searchResult.isNotEmpty) {
      results.value = List<UserModel>.from(searchResult);
    } else {
      results.clear();
    }

    isLoading.value = false;
  }
}

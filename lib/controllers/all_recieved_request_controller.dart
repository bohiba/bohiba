import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/model/driver_model.dart';
import 'package:bohiba/services/driver_job_service.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:bohiba/services/pref_utils.dart';
import 'package:get/get.dart';

class AllRecievedRequestController extends GetxController {
  final PrefUtils _prefUtils = PrefUtils();

  List<UserModel> recvdRequest = <UserModel>[].obs;

  RxString strHeaderMsg = ''.obs;
  RxString strDescription = ''.obs;

  bool showAgain = true;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await allRequest();
      showAgain = _prefUtils.getBool(PrefUtils.showConnectDialog);
    });
  }

  Future<int> updateStatus(ConnectionType conect, int id) async {
    int success = await DriverJobService.updateStatus(conect, id);
    if (success > 0) {
      GlobalService.showAppToast(message: 'Success');
    }
    return success;
  }

  Future<void> allRequest({
    bool refresh = false,
    showLoading = true,
  }) async {
    List<UserModel>? arrUser = await DriverJobService.getAllRecivedRequest(
      reset: refresh,
      showProgress: showLoading,
    );

    if (arrUser != null) {
      if (refresh == true) arrUser.clear();
      recvdRequest.addAll(arrUser);
    }
  }
}

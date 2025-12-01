import '/model/user_model.dart';
import '/services/open_driver_service.dart';
import 'package:get/get.dart';

class AllSentRequestController extends GetxController {
  RxList<UserModel> arrSentReq = <UserModel>[].obs;
  RxString strHeaderMsg = ''.obs;
  RxString strDescription = ''.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await getSentReq();
    });
  }

  Future<void> getSentReq({bool showLoading = true, bool reset = false}) async {
    List<UserModel>? sentReqList = await OpenDriverService.getSentReqList(
      showProgress: showLoading,
    );

    if (sentReqList != null) {
      if (reset) arrSentReq.clear();
      arrSentReq.addAll(sentReqList);
    }
    if (arrSentReq.isEmpty) {
      strHeaderMsg.value = 'No Request Found';
      strDescription.value = 'Start sending connection request and connect with driver to boost you business';
    }
  }

  Future<void> getAllOpenDriver() async {
    List<UserModel>? openDriverList = await OpenDriverService.getAllOpenDriver();

    if (openDriverList != null) {
      arrSentReq.clear();
      arrSentReq.addAll(openDriverList);
    }
  }
}

import 'package:bohiba/model/driver_model.dart';
import '/services/open_driver_service.dart';
import 'package:get/get.dart';

class AllSentRequestController extends GetxController {
  RxList<DriverModel> arrSentReq = <DriverModel>[].obs;
  RxString strHeaderMsg = ''.obs;
  RxString strDescription = ''.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await _getSentReq();
    });
  }

  Future<void> _getSentReq() async {
    List<DriverModel> sentReqList = await OpenDriverService.getSentReqList();
    arrSentReq.addAll(sentReqList);
    if (arrSentReq.isEmpty) {
      strHeaderMsg.value = 'No Request Found';
      strDescription.value =
          'Start sending connection request and connect with driver to boost you business';
    }
  }

  Future<void> getAllOpenDriver() async {
    List<DriverModel> openDriverList =
        await OpenDriverService.getAllOpenDriver();
    arrSentReq.clear();
    arrSentReq.addAll(openDriverList);
  }
}

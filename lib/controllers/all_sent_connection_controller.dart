import '/model/open_driver_model.dart';
import '/services/open_driver_service.dart';
import 'package:get/get.dart';

class AllSentRequestController extends GetxController {
  RxList<OpenDriverModel> arrSentReq = <OpenDriverModel>[].obs;
  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await _getSentReq();
    });
  }

  Future<void> _getSentReq() async {
    List<OpenDriverModel> sentReqList =
        await OpenDriverService.getSentReqList();
    arrSentReq.addAll(sentReqList);
  }
}

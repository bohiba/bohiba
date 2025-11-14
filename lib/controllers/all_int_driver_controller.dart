import 'package:bohiba/services/owner_job_service.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/model/job_detail_model.dart';
import 'package:get/get.dart';

class AllIntDriverController extends GetxController {
  RefreshController refresPageController = RefreshController();
  Rx<JobDetailModel> jobDetail = JobDetailModel().obs;
  RxList<InterestedDriver> arrIntDriver = <InterestedDriver>[].obs;

  @override
  void onInit() {
    jobDetail.value = Get.arguments;
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getAllApplicant();
    });
  }

  Future<void> getAllApplicant() async {
    List<InterestedDriver>? arrFetched =
        await OwnerJobService.allApplicant(jobId: jobDetail.value.id!);
    if (arrFetched != null) {
      arrIntDriver.clear();
      arrIntDriver.addAll(arrFetched);
    }
  }
}

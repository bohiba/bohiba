import '/services/job_service.dart';
import 'package:get/get.dart';

class MyJobController extends GetxController {
  late Map jobBrief;
  RxMap<dynamic, dynamic> jobObj = <dynamic, dynamic>{}.obs;
  RxList arrIntDriver = [].obs;

  @override
  void onInit() {
    jobBrief = Get.arguments;
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await jobDetail();
    });
  }

  Future<void> jobDetail() async {
    Map<dynamic, dynamic>? jobInfo =
        await JobService.getJob(jobId: jobBrief['id']);
    if (jobInfo != null) {
      jobObj.clear();
      jobObj.assignAll(jobInfo);
      if (jobObj['interested_drivers'] != null &&
          jobObj['interested_drivers'] is List) {
        arrIntDriver.addAll(jobObj['interested_drivers']);
      }
    } else {
      jobObj.clear();
    }
  }
}

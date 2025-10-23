import '/model/job_detail_model.dart';
import '/services/driver_job_service.dart';
import 'package:get/get.dart';

class AllAppliedJobController extends GetxController {
  RxList<JobDetailModel> arrAppliedJob = <JobDetailModel>[].obs;
  RxString strHeaderMsg = ''.obs;
  RxString strDescription = ''.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await getAppliedJobs();
    });
  }

  Future<void> getAppliedJobs({bool refresh = false}) async {
    List<JobDetailModel>? appliedJobList =
        await DriverJobService.getAppliedJobs();
    if (appliedJobList != null) {
      if (refresh) arrAppliedJob.clear();
      arrAppliedJob.addAll(appliedJobList);
    }
  }
}

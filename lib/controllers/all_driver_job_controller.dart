import 'package:get/get.dart';
import '/model/job_detail_model.dart';
import '/services/driver_job_service.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllDriverJobController extends GetxController {
  RefreshController refreshController = RefreshController();
  RxList<JobDetailModel> arrJobDetail = <JobDetailModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getAllJobs();
    });
  }

  Future<void> getAllJobs(
      {bool refresh = false, bool showLoading = true}) async {
    List<JobDetailModel>? jobDetail =
        await DriverJobService.getAllDriverJob(showProgress: showLoading);
    if (jobDetail != null) {
      if (refresh) arrJobDetail.clear();
      arrJobDetail.addAll(jobDetail);
    }
  }
}

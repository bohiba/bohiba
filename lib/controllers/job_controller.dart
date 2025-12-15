import '/services/driver_job_service.dart';

import '/model/job_detail_model.dart';
import '/services/pref_utils.dart';
import '/services/user_role_type.dart';

import '/services/owner_job_service.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class JobController extends GetxController {
  final refreshController = RefreshController();
  final PrefUtils _prefUtils = PrefUtils();

  Rx<JobDetailModel> jobDetailModel = JobDetailModel().obs;

  RxList<InterestedDriver> arrIntDriver = <InterestedDriver>[].obs;
  RxList<String> statusItem = ['open', 'closed', 'drafted'].obs;
  RxString jobStatus = ''.obs;
  Rx<int> anyUpdate = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      jobDetailModel.value = Get.arguments;
      int roleId = _prefUtils.getInt(PrefUtils.roleKey);
      if (roleId == UserRoles.truckOwner) {
        await ownerJobDetail();
      } else {
        await driverJobDetail();
      }
    });
  }

  Future<void> applyToJob() async {
    int success = await DriverJobService.applyToJob(jobId: jobDetailModel.value.id!);
    if (success > 0) {
      // Success
    }
  }

  Future<void> driverJobDetail() async {
    /*JobDetailModel? jobInfo =
        await DriverJobService.getJob(jobId: jobObj.value.id!);
    if (jobInfo != null) {
      jobObj.value = jobInfo;
      jobStatus.value = jobObj.value.status ?? '';
      if (jobObj.value.interestedDrivers != null) {
        arrIntDriver.clear();
        arrIntDriver.addAll(jobObj.value.interestedDrivers!);
      }
    }*/
  }

  Future<void> updateJob() async {
    int success = await OwnerJobService.updateJobPost(
      jobInfo: jobDetailModel.value,
      status: jobStatus.value,
    );
    if (success > 0) {
      anyUpdate.value++;
      await ownerJobDetail();
    }
  }

  Future<void> ownerJobDetail() async {
    JobDetailModel? jobInfo = await OwnerJobService.getJob(jobId: jobDetailModel.value.id!);
    if (jobInfo != null) {
      jobDetailModel.value = jobInfo;
      jobStatus.value = jobDetailModel.value.status ?? '';
      if (jobDetailModel.value.interestedDrivers != null) {
        arrIntDriver.clear();
        arrIntDriver.addAll(jobDetailModel.value.interestedDrivers!);
      }
    }
  }
}

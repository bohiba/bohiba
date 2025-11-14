import 'package:bohiba/model/job_detail_model.dart';

import '../services/owner_job_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllJobController extends GetxController {
  RefreshController refreshController = RefreshController();
  RxList<dynamic> arrJobs = <dynamic>[].obs;

  Rx<String> strTitle = ''.obs;
  Rx<String> strSubTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getAllJobs();
    });
  }

  Future<void> refreshPage() async {
    await getAllJobs();
    refreshController.refreshCompleted();
  }

  Future<void> getAllJobs() async {
    List<JobDetailModel>? fetchList = await OwnerJobService.allJobs();
    if (fetchList == null || fetchList.isEmpty) {
      arrJobs.clear();
      strTitle.value = 'No Jobs Found';
      strSubTitle.value = 'Post job to find driver in your area.';
    } else {
      arrJobs.clear();
      arrJobs.addAll(fetchList);
    }
  }

  Color statusColor({required String status}) {
    switch (status) {
      case 'open':
        return bohibaTheme.colorScheme.onPrimary;
      case 'drafted':
        return bohibaTheme.colorScheme.secondary;
      case 'closed':
        return bohibaTheme.colorScheme.error;
      default:
        return bohibaTheme.colorScheme.secondary;
    }
  }
}

import 'package:bohiba/services/job_service.dart';

import '/dist/app_enums.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddJobController extends GetxController {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController locEditingController = TextEditingController();
  // TextEditingController licenseTypeEditingController = TextEditingController();
  TextEditingController jobTypeEditingController = TextEditingController();
  TextEditingController regdNoEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();
  TextEditingController statusEditingController = TextEditingController();
  TextEditingController startFromEditingController = TextEditingController();

  List<String> odishaDistricts = [
    "Angul",
    "Balangir",
    "Balasore",
    "Bargarh",
    "Bhadrak",
    "Boudh",
    "Cuttack",
    "Deogarh",
    "Dhenkanal",
    "Gajapati",
    "Ganjam",
    "Jagatsinghpur",
    "Jajpur",
    "Jharsuguda",
    "Kalahandi",
    "Kandhamal",
    "Kendrapara",
    "Kendujhar",
    "Khordha",
    "Koraput",
    "Malkangiri",
    "Mayurbhanj",
    "Nabarangpur",
    "Nayagarh",
    "Nuapada",
    "Puri",
    "Rayagada",
    "Sambalpur",
    "Subarnapur",
    "Sundargarh",
  ];

  List<String> arrJobType = [
    'Full-Time',
    'Permanent',
    'Temporary',
  ];

  String? selectedLoc;

  Future<void> createJob() async {
    Map<String, dynamic> bodyObj = {
      'job_title': titleEditingController.text.trim(),
      'location': locEditingController.text.trim(),
      'regd_number': regdNoEditingController.text.trim().toUpperCase(),
      'job_type': jobTypeEditingController.text.trim().toLowerCase(),
      'description': descEditingController.text,
      'status': 'open',
      'start_from': startFromEditingController.text.trim(),
    };
    int createJob = await JobService.createJob(bodyMap: bodyObj);
    if (createJob > 0) {
      GlobalService.showAlertDialog(
        status: AlertStatus.success,
        title: 'Success',
        description: 'Do you want to create more jobs?',
        onSave: () {
          Get.back();
          Get.back(result: true);
        },
      );
    }
  }
}

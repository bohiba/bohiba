import '/controllers/trip_controller.dart';
import '/model/trip_model.dart';
import '/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripAddReassignController extends GetxController {
  DateTime assignDate = DateTime.now();

  final TripController tripController = Get.find<TripController>();
  TextEditingController dateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController truckNumberController = TextEditingController();

  TripModel? tripModel;
  Reassignment? reassign;

  @override
  void onInit() {
    if (Get.arguments is TripModel) {
      tripModel = Get.arguments as TripModel;
    } else {
      reassign = Get.arguments as Reassignment;
      onEditTextController();
    }
    super.onInit();
  }

  Future<void> addUpdateReassign() async {
    Map<String, dynamic> bodyObj = {
      'truck_regd_number': truckNumberController.text.trim(),
      'reassigned_at': dateController.text.trim(),
      'reason': remarkController.text.trim(),
    };

    if (reassign != null && tripModel == null) {
      int editSuccess = await TripService.editReassign(
          bodyMap: bodyObj, reassignId: reassign!.id!);
      if (editSuccess > 0) {
        Get.back(result: true);
      }
    } else if (reassign == null && tripModel != null) {
      bodyObj['trip_id'] = tripModel!.id!;
      int addSucess =
          await TripService.addReassignment(bodyObj: bodyObj, trip: tripModel!);
      if (addSucess > 0) {
        //
      }
    } else {
      DoNothingAction();
    }

    discard();
  }

  void onEditTextController() {
    truckNumberController.text = reassign?.regdNumber ?? '';
    dateController.text = reassign?.date ?? '';
    remarkController.text = reassign?.reason ?? '';
  }

  void discard() {
    truckNumberController.clear();
    dateController.clear();
    remarkController.clear();
  }
}

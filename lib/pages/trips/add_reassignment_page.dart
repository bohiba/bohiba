import 'package:get/get.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/controllers/trip_add_reassign_controller.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/services/global_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AddReassignementPage extends GetView<TripAddReassignController> {
  const AddReassignementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
          title: controller.tripModel == null
              ? 'Edit Reassignment'
              : 'Reassignment',
          popResult: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
          ),
          child: Column(
            children: [
              DateInputField(
                width: ScreenUtils.width,
                onTap: () async {
                  controller.assignDate =
                      await GlobalService.datePickerModal(context: context);
                  controller.dateController.text =
                      DateFormat('dd-MM-yyyy').format(controller.assignDate);
                },
                controller: controller.dateController,
                hintText: 'Payment Date',
              ),
              TextInputField(
                hintText: 'Truck Number',
                controller: controller.truckNumberController,
                textCapitalization: TextCapitalization.characters,
              ),
              TextInputField(
                height: 110,
                maxLines: 4,
                maxLength: 30,
                counterText: '30',
                hintText: 'Remark',
                textCapitalization: TextCapitalization.none,
                controller: controller.remarkController,
              ),
              Spacer(),
              PrimaryButton(
                onPressed: () => controller.addUpdateReassign(),
                label: controller.tripModel == null ? 'UPDATE' : 'SAVE',
              )
            ],
          ),
        ),
      ),
    );
  }
}



/*

  DateTime assignDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

 */
import 'package:bohiba/component/bohiba_buttons/primary_button.dart';
import 'package:bohiba/component/bohiba_dropdown/app_dropdown_button.dart';
import 'package:bohiba/component/bohiba_inputfield/date_inputfield.dart';
import 'package:bohiba/component/bohiba_inputfield/text_inputfield.dart';
import 'package:bohiba/controllers/add_job_controller.dart';
import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/pages/widget/required_label.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddJobsPage extends GetView<AddJobController> {
  const AddJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Add Jobs'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height20,
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RequiredLabel(
                        label: 'Start From',
                        required: true,
                      ),
                      DateInputField(
                        hintText: 'Select Date',
                        controller: controller.startFromEditingController,
                        onTap: () async {
                          DateTime date = await GlobalService.datePickerModal(
                              context: context);
                          controller.startFromEditingController.text =
                              DateFormat('dd-MM-yyyy').format(date);
                        },
                      ),
                      RequiredLabel(
                        label: 'Job Title',
                        required: true,
                      ),
                      TextInputField(
                        maxLines: 1,
                        nextActionType: TextInputAction.next,
                        controller: controller.titleEditingController,
                      ),
                      RequiredLabel(
                        label: 'Vechile Number',
                        required: true,
                      ),
                      TextInputField(
                        textCapitalization: TextCapitalization.characters,
                        controller: controller.regdNoEditingController,
                      ),
                      RequiredLabel(
                        label: 'Location',
                        required: true,
                      ),
                      AppDropdown(
                        hint: 'Select Location',
                        // dropDownValue: controller.selectedLoc,
                        items: controller.odishaDistricts,
                        labelBuilder: (p0) {
                          return p0;
                        },
                        onChanged: (p0) {
                          // controller.selectedLoc = p0;
                          if (p0 != null) {
                            controller.locEditingController.text = p0;
                          }
                        },
                        menuController: controller.locEditingController,
                      ),
                      RequiredLabel(
                        label: 'Job Type',
                        required: true,
                      ),
                      AppDropdown(
                        hint: 'Select job type',
                        items: controller.arrJobType,
                        labelBuilder: (p0) => p0,
                        menuController: controller.jobTypeEditingController,
                      ),
                      RequiredLabel(
                        label: 'Descriptation',
                        required: true,
                      ),
                      TextInputField(
                        height: ScreenUtils.height * 0.32,
                        maxLines: 12,
                        keyboardType: TextInputType.multiline,
                        nextActionType: TextInputAction.next,
                        controller: controller.descEditingController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PrimaryButton(
              onPressed: () async => await controller.createJob(),
              label: 'Create Job',
            )
          ],
        ),
      ),
    );
  }
}

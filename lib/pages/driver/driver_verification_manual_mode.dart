import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/screen_utils.dart';
import '/controllers/driver_add_controller.dart';
import '/services/global_service.dart';

import '/pages/widget/required_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class ManualModeDriverVerification extends GetView<DriverAddController> {
  const ManualModeDriverVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequiredLabel(label: 'Driving License', required: true),
        TextInputField(
          prefixIcon: const Icon(
            Remix.user_3_fill,
            size: 20,
          ),
          hintText: "License Number",
          textCapitalization: TextCapitalization.characters,
          maxLength: 16,
        ),
        RequiredLabel(label: 'D.O.B', required: true),
        DateInputField(
          width: ScreenUtils.width,
          controller: controller.dateController,
          onTap: () async {
            DateTime? pickedDate =
                await GlobalService.datePickerModal(context: context);
            if (pickedDate != null) {
              controller.dateController.text =
                  DateFormat('dd-MM-yyyy').format(pickedDate);
            }
          },
          hintText: "D.O.B",
        ),
      ],
    );
  }
}

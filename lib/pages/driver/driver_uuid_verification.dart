import '/component/bohiba_inputfield/text_inputfield.dart';
import '/controllers/driver_add_controller.dart';
import '/pages/widget/required_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class UUIDDriverVerification extends GetView<DriverAddController> {
  const UUIDDriverVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequiredLabel(label: 'UUID', required: true),
        TextInputField(
          prefixIcon: const Icon(
            Remix.user_3_fill,
            size: 20,
          ),
          maxLength: 6,
          hintText: "6-digit UUID",
          textCapitalization: TextCapitalization.characters,
          controller: controller.uuidCtlr,
        ),
      ],
    );
  }
}

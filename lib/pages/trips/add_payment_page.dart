import 'package:bohiba/dist/enums/enum_trip_payment.dart';
import 'package:bohiba/pages/widget/required_label.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../component/bohiba_dropdown/app_search_dropdown_button.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/controllers/trip_payment_add_controller.dart';
import 'package:get/get.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/services/global_service.dart';
import 'package:intl/intl.dart';
import '/component/screen_utils.dart';
import 'package:flutter/material.dart';

class AddPaymentPage extends GetView<TripPaymentAddController> {
  const AddPaymentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: controller.tripModel == null ? 'Edit Payment' : 'Add Payment',
          popResult: controller.countUpdate > 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height20,
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateInputField(
                        width: ScreenUtils.width,
                        onTap: () async {
                          DateTime? paymentDate =
                              await GlobalService.datePickerModal(
                            context: context,
                            startTime: DateFormat('yyyy-MM-dd')
                                .parse(controller.tripModel?.startDate ?? ''),
                          );
                          if (paymentDate != null) {
                            controller.paymentDateController.text =
                                DateFormat('dd-MM-yyyy').format(paymentDate);
                          }
                        },
                        controller: controller.paymentDateController,
                        hintText: 'Payment Date',
                      ),
                      RequiredLabel(
                        label: 'Paid By',
                        required: true,
                      ),
                      TextInputField(
                        controller: controller.paidByController,
                        hintText: 'Transporter/Mines',
                        textCapitalization: TextCapitalization.characters,
                        nextActionType: TextInputAction.next,
                      ),
                      RequiredLabel(
                        label: 'Recieved By',
                        required: true,
                      ),
                      AppDropdownSearch<EnumTripPaymentReceiver>(
                        padding: EdgeInsets.only(bottom: 5.h),
                        hint: 'Driver/Self',
                        items: controller.arrRecievedBy,
                        initialValue: controller.selectedReceivedBy.value,
                        labelBuilder: (e) => e.displayName,
                        onChanged: (v) =>
                            controller.selectedReceivedBy.value = v,
                      ),
                      RequiredLabel(
                        label: 'Payment Mode',
                        required: true,
                      ),
                      AppDropdownSearch<EnumTripPaymentMode>(
                        padding: EdgeInsets.only(bottom: 5.h),
                        hint: 'Select Payment Mode',
                        items: controller.arrPaymentMode,
                        initialValue: controller.selectedPaymentMode.value,
                        labelBuilder: (e) => e.displayName,
                        onChanged: (v) =>
                            controller.selectedPaymentMode.value = v,
                      ),
                      RequiredLabel(
                        label: 'Payment Type',
                        required: true,
                      ),
                      AppDropdownSearch<EnumTripPaymentType>(
                        padding: EdgeInsets.only(bottom: 5.h),
                        hint: 'Select Payment Type',
                        items: controller.arrPaymentType,
                        initialValue: controller.selectedPaymentType.value,
                        labelBuilder: (e) => e.displayName,
                        onChanged: (v) =>
                            controller.selectedPaymentType.value = v,
                      ),
                      RequiredLabel(
                        label: 'Amount',
                        required: true,
                      ),
                      TextInputField(
                        width: ScreenUtils.width,
                        hintText: 'Amount',
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: controller.paidController,
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
                onPressed: () async => await controller.addUpdatePayment(),
                label: controller.tripModel == null ? 'UPDATE' : 'SAVE',
              ),
            ],
          ),
        ),
      );
    });
  }
}

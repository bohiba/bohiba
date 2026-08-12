import '/component/bohiba_appbar/title_appbar.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_dropdown/app_search_dropdown_button.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/screen_utils.dart';
import '/pages/widget/icon_text_tile.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/controllers/ticket_controller.dart';

class ReportIssuePage extends GetView<TicketController> {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(title: 'Report Issue'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Issue Type",
                      style: bohibaTheme.textTheme.headlineMedium,
                    ),
                    Gap(ScreenUtils.height5),
                    AppDropdownSearch(
                      padding:
                          EdgeInsets.symmetric(vertical: ScreenUtils.height10),
                      items: controller.bohibaIssues,
                      hint: 'Select bug from list',
                      labelBuilder: (issue) {
                        return issue;
                      },
                      onChanged: (p0) {
                        controller.selectedIssue = p0;
                      },
                    ),
                    TextInputField(
                      maxLines: 6,
                      height: ScreenUtils.height * 0.15,
                      hintText: 'Describe the issue in detail',
                      controller: controller.descriptionController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      nextActionType: TextInputAction.done,
                    ),
                    IconTextTile(
                      icon: Icons.attach_file,
                      text: 'Attach Screenshot/ File',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                onPressed: () async =>
                    await controller.createTicket().then((onValue) {
                  navigatorState.pop(onValue);
                }),
                width: ScreenUtils.width,
                label: 'Report',
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';
import 'package:bohiba/component/bohiba_buttons/primary_button.dart';
import 'package:bohiba/component/bohiba_dropdown/app_dropdown_button.dart';
import 'package:bohiba/component/bohiba_inputfield/text_inputfield.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/widget/icon_text_tile.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  String? selectedIssue;
  final TextEditingController descriptionController = TextEditingController();
  final List<String> bohibaIssues = [
    "Login / Authentication Issue",
    "Trip Creation Problem",
    "Expense Entry Error",
    "Payment Not Reflecting",
    "Driver Assignment Issue",
    "Truck Details Missing/Wrong",
    "App Crashes / Not Responding",
    "Slow Performance",
    "Notification Not Received",
    "Document Upload Failure",
    "Data Sync Problem",
    "Dark Mode / Theme Issue",
    "Incorrect Analytics Report",
    "Profile Update Not Saving",
    "Other (Please Specify)"
  ];
  @override
  Widget build(BuildContext context) {
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
                    AppDropdown(
                      padding:
                          EdgeInsets.symmetric(vertical: ScreenUtils.height10),
                      items: bohibaIssues,
                      hint: 'Select bug from list',
                      labelBuilder: (issue) {
                        return issue;
                      },
                      onChanged: (p0) {
                        setState(() {
                          selectedIssue = p0;
                        });
                      },
                    ),
                    TextInputField(
                      maxLines: 6,
                      height: ScreenUtils.height * 0.15,
                      hintText: 'Describe the issue in detail',
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
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
                onPressed: () {},
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

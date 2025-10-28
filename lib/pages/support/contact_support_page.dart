import '/services/launcher_service.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/pages/widget/icon_text_tile.dart';
import '/theme/bohiba_theme.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final headerStyle = bohibaTheme.textTheme.headlineMedium;
    return Scaffold(
      appBar: TitleAppbar(title: 'Contact & Support'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Frequently Asked Questions", style: headerStyle),

              _buildFaqTile(
                "How do I add a new truck?",
                "To add a new truck, navigate to the 'Trucks' section and tap the '+' button. Enter the truck details, including make, model, and VIN.",
              ),
              _buildFaqTile(
                "How do I assign a driver to a truck?",
                "Go to the 'Drivers' section, choose a driver and link them to a truck under assignments.",
              ),
              _buildFaqTile(
                "How do I view truck maintenance history?",
                "Open the truck details page and select 'Maintenance History'.",
              ),
              Gap(ScreenUtils.height50),

              // Contact Us Section
              Text("Contact Us", style: headerStyle),
              Gap(ScreenUtils.height10),
              IconTextTile(
                icon: Remix.whatsapp_line,
                text: "WhatsApp Chat",
                onTap: () async => await LauncherService.supportViaWhatsApp(),
              ),

              IconTextTile(
                icon: Icons.email_outlined,
                text: 'Email Support',
                onTap: () async => await LauncherService.supportViaEmail(),
              ),

              Gap(ScreenUtils.height30),

              /*Text("Submit a Ticket", style: headerStyle),
              Gap(ScreenUtils.height10),
              TextInputField(
                hintText: "Subject",
                nextActionType: TextInputAction.next,
              ),

              TextInputField(
                height: ScreenUtils.height * 0.2,
                maxLines: 10,
                hintText: 'Description',
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
              ),
              IconTextTile(
                icon: Icons.attach_file,
                text: 'Attach Screenshot/ File',
              ),

              Padding(
                padding: EdgeInsets.only(top: ScreenUtils.height10),
                child: Text(
                  "Response Time: Our team typically responds within 24-48 hours.",
                  style: bohibaTheme.textTheme.bodyMedium,
                ),
              ),
              Gap(ScreenUtils.height10),
              PrimaryButton(
                onPressed: () {},
                width: ScreenUtils.width,
                label: 'Submit Ticket',
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtils.height5),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(),
        title: Text(
          question,
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.labelLarge!.fontSize,
            fontWeight: bohibaTheme.textTheme.titleSmall!.fontWeight,
            color: bohibaTheme.textTheme.bodySmall!.color,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              answer,
              style: bohibaTheme.textTheme.titleLarge,
            ),
          )
        ],
      ),
    );
  }
}

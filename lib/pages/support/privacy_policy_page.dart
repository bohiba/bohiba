import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = bohibaTheme.textTheme.titleMedium;
    return Scaffold(
      appBar: TitleAppbar(title: 'Privay & Policy'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height20,
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Privacy Policy",
                    style: bohibaTheme.textTheme.headlineMedium),
                Gap(ScreenUtils.height20),
                Text("Updates", style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'Last Update on: September 19, 2025',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height10),
                Text(
                  'This privacy policy applies to the Bohiba app (hereby referred to as "Application") '
                  'for mobile devices that was created by Bohiba (hereby referred to as "Service Provider") '
                  'as a Commercial service. This service is intended for use "AS IS".',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Information Collection and Use",
                    style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'The Application collects information when you download and use it. This information may include:\n\n'
                  '• Your device\'s Internet Protocol address (e.g. IP address)\n'
                  '• The pages of the Application that you visit, the time and date of your visit\n'
                  '• The time spent on the Application\n'
                  '• The operating system you use on your mobile device\n\n'
                  'The Application collects your device\'s location, which helps the Service Provider determine '
                  'your approximate geographical location and make use of it in below ways:\n\n'
                  '1. Geolocation Services: Provide personalized content, recommendations, and location-based services.\n'
                  '2. Analytics and Improvements: Analyze anonymized data to improve the Application.\n'
                  '3. Third-Party Services: Periodically transmit anonymized location data to optimize services.',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Third Party Access",
                    style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'Only aggregated, anonymized data is periodically transmitted to external services to aid the '
                  'Service Provider in improving the Application and their service.\n\n'
                  'The Service Provider may disclose User Provided and Automatically Collected Information:\n'
                  '• As required by law\n'
                  '• To protect rights, safety, and investigate fraud\n'
                  '• With trusted providers who work on their behalf',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Opt-Out Rights",
                    style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'You can stop all collection of information by the Application easily by uninstalling it. '
                  'You may use the standard uninstall processes of your mobile device or application marketplace.',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Data Retention Policy",
                    style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'The Service Provider will retain User Provided data for as long as you use the Application '
                  'and for a reasonable time thereafter. To request deletion, contact support@bohiba.com.',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Children", style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'The Service Provider does not knowingly collect personally identifiable information from children under 13. '
                  'Parents are encouraged to monitor their children’s use of the Application. If you believe a child has '
                  'submitted personal data, contact support@bohiba.com.',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Security", style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'The Service Provider safeguards your information with physical, electronic, and procedural protections.',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Changes", style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'This Privacy Policy may be updated from time to time. Changes will be reflected on this page. '
                  'Effective as of 2025-09-18.',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Your Consent",
                    style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'By using the Application, you consent to the processing of your information as set forth in this Privacy Policy.',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text("Contact Us", style: bohibaTheme.textTheme.headlineMedium),
                Text(
                  'If you have any questions regarding privacy while using the Application, please contact us at support@bohiba.com.',
                  style: titleStyle,
                ),
                Gap(ScreenUtils.height20),
                Text(
                  'For full policy, visit or website',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: bohibaTheme.textTheme.titleMedium!.fontWeight,
                      fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                      color: bohibaTheme.textTheme.bodySmall!.color),
                ),
                Gap(ScreenUtils.height30),
                Center(
                  child: GestureDetector(
                    onTap: () async => await openBohibaWeb(),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: ScreenUtils.height25),
                      child: Text(
                        'www.bohiba.com',
                        style: titleStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openBohibaWeb() async {
    final Uri emailUri = Uri(path: 'www.bohiba.com');

    try {
      bool canLaunch = await canLaunchUrl(emailUri);
      if (canLaunch) {
        await launchUrl(emailUri, mode: LaunchMode.inAppBrowserView);
      } else {
        GlobalService.showAppToast(message: 'Could not launch website');
      }
    } catch (e) {
      GlobalService.showAppToast(message: 'Could not launch website');
      GlobalService.printHandler('$e');
    }
  }
}

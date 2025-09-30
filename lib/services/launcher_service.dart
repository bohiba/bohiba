import 'package:url_launcher/url_launcher.dart';

import 'global_service.dart';

class LauncherService {
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      GlobalService.printHandler('Could not launch $phoneNumber');
    }
  }
}

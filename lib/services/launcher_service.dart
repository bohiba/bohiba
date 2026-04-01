import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'global_service.dart';

class LauncherService {
  static final _appUrl = Platform.isIOS ? 'Not available on App Store' : 'https://play.google.com/store/apps/details?id=com.app.bohiba';
  static final String _shareMsg = "🚛 *Bohiba – India’s 1 Truck and Trip Management App!*%0A%0A"
      "Manage your *Trips*, *Drivers*, and *Expenses* — all in one app.%0A"
      "Track your trucks, hire drivers, and stay updated with *MiningNews*!%0A%0A"
      "💡 Easy to use | 🔒 Secure | 🇮🇳 Made for *Truck Owners and Drivers*%0A%0A"
      "👉 *Download Bohiba App now and simplify your transport life!*%0A"
      "📲 $_appUrl"
      "#Bohiba #TruckOwner #DriverHiring #TransportIndia";

  static Future<void> shareViaAnyApp() async {
    try {
      Share.share(_appUrl);
    } catch (e) {
      GlobalService.printHandler('Failed to share');
    }
  }

  static Future<void> shareViaSms() async {
    final smsBody = Uri.encodeComponent("🚛 Bohiba – India’s #1 Truck & Trip Management App!\n\n"
        "Manage your #Trips, #Drivers, and #Expenses — all in one app.\n"
        "Download now: $_appUrl");
    final Uri smsUrl = Platform.isAndroid ? Uri.parse("sms:?body=$smsBody") : Uri.parse("sms:&body=$smsBody");

    try {
      await launchUrl(smsUrl);
    } catch (e) {
      GlobalService.printHandler('Could not launch SMS');
    }
  }

  static Future<void> shareViaEmail() async {
    final subject = Uri.encodeComponent("Try Bohiba – India’s #1 Truck Management App");
    final body = Uri.encodeComponent("🚛 Bohiba – India’s #1 Truck & Trip Management App!\n\n"
        "Manage your #Trips, #Drivers, and #Expenses — all in one app.\n"
        "Track your trucks, hire drivers, and stay updated with #MiningNews!\n\n"
        "💡 Easy to use | 🔒 Secure | 🇮🇳 Made for Truck Owners & Drivers\n\n"
        "👉 Download now: $_appUrl\n\n"
        "#Bohiba #TruckOwner #DriverHiring #TransportIndia");
    final mailUrl = "mailto:?subject=$subject&body=$body";
    try {
      await launchUrl(Uri.parse(mailUrl));
    } catch (e) {
      GlobalService.printHandler('Could not launch Mail');
    }
  }

  static Future<void> shareAppOnTelegram() async {
    final launchUri = Uri.parse(
      "https://t.me/share/url?url=$_appUrl&text=$_shareMsg",
    );
    try {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      GlobalService.printHandler('Could not launch Telegram');
    }
  }

  static Future<void> shareAppOnWhatsApp() async {
    final launchUri = Uri.parse("https://api.whatsapp.com/send?text=$_shareMsg");
    try {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      GlobalService.printHandler('Could not launch WhatsApp');
    }
  }

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

  static Future<void> supportViaWhatsApp() async {
    final Uri whatsappUri = Uri.parse("https://wa.me/8249860429");
    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      GlobalService.showAppToast(message: 'Could not launch WhatsApp');
      GlobalService.printHandler('$e');
    }
  }

  static Future<void> supportViaEmail({
    String subject = "",
    String body = "",
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@bohiba.com',
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      GlobalService.showAppToast(message: 'Could not launch Email');
      GlobalService.printHandler('$e');
    }
  }

  static Future<void> openWebsite(String webUrl) async {
    try {
      await launchUrl(Uri(scheme: webUrl), mode: LaunchMode.inAppBrowserView);
    } catch (e) {
      GlobalService.showAppToast(message: 'Could not launch Email');
      GlobalService.printHandler('$e');
    }
  }

  static Future<void> openMaps(double lat, double lng) async {
    Uri uri;

    if (Platform.isAndroid) {
      uri = Uri.parse(
        "google.navigation:q=$lat,$lng&mode=d",
      );
    } else {
      uri = Uri.parse(
        "http://maps.apple.com/?daddr=$lat,$lng&dirflg=d",
      );
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open maps';
    }
  }
}

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({
    super.key,
  });

  @override
  Widget build(Object context) {
    final h2Style = bohibaTheme.textTheme.headlineLarge;
    final headlineStyle = bohibaTheme.textTheme.headlineMedium;
    final titleStyle = bohibaTheme.textTheme.titleMedium;
    return Scaffold(
      appBar: TitleAppbar(title: 'About App'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height10,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("About App", style: headlineStyle),
              Text(
                '''Bohiba is a smart, all-in-one platform designed to simplify trip, truck, and driver management for India’s transport industry — especially for truck owners, managers, and drivers involved in mining, logistics, and goods transportation. Built with the real challenges of Indian transporters in mind, Bohiba helps you organize your fleet, track finances, manage drivers, and analyze profits — all from one simple mobile app.''',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(30.h),
              Divider(thickness: 1.0),
              Gap(30.h),
              Text("What Bohiba Does", style: h2Style),
              Text("Add & Manage Trucks", style: headlineStyle),
              Text(
                'Easily register your trucks, store all RC and vehicle details, and keep your fleet information updated in one place.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(10.h),
              Text("Add & Manage Drivers", style: headlineStyle),
              Text(
                'Access driver profiles with their UUID and license details. Assign or unassign drivers from trips with just a tap.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(10.h),
              Text("Create & Track Trips", style: headlineStyle),
              Text(
                'Plan trips with clear start and end points, record material type, load details, rates, and monitor each trip’s performance in real time.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(10.h),
              Text("Manage Finances", style: headlineStyle),
              Text(
                'Automatically calculate trip expenses, payments, and profits. Get a transparent view of your total earnings and spending with detailed breakdowns.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(10.h),
              Text("Analytics Dashboard", style: headlineStyle),
              Text(
                'View simple yet powerful analytics to understand your business performance — know which trucks or drivers bring the best results.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(10.h),
              Text("Upload & Manage Documents", style: headlineStyle),
              Text(
                'Keep all important documents like PAN, Aadhaar, RC, and DL digitally stored and accessible anytime, anywhere.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(10.h),
              Text("Secure & Verified System", style: headlineStyle),
              Text(
                'Every user (Owner, Manager, or Driver) is verified through proper ID validation, ensuring data security and authenticity.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(30.h),
              Divider(thickness: 1.0),
              Gap(30.h),
              Text("🇮🇳 Why Bohiba?", style: h2Style),
              Text(
                'Bohiba brings desi innovation to the heart of India’s transport ecosystem. No complicated systems — just simple, reliable tools that speak the transporter’s language.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Text(
                '''

        ✅ Works even in low network areas
        ✅ Easy to use, paperless, and secure''',
                style: titleStyle,
              ),
              Gap(30.h),
              Divider(thickness: 1.0),
              Gap(30.h),
              Text("Our Mission", style: h2Style),
              Text(
                'To empower small and mid-sized truck owners across India with smart digital tools that make daily operations easier, faster, and more profitable — helping the Indian logistics industry grow stronger from the ground up.',
                textAlign: TextAlign.start,
                style: titleStyle,
              ),
              Gap(ScreenUtils.height * 0.3)
            ],
          ),
        ),
      ),
    );
  }
}

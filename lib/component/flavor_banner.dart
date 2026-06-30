import 'package:bohiba/config/app_config.dart';
import 'package:flutter/material.dart';

class FlavorBanner extends StatelessWidget {
  const FlavorBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (AppConfig.isProd) return child;
    return Banner(
      message: 'BETA',
      location: BannerLocation.topEnd,
      color: const Color(0xFFE53935),
      child: child,
    );
  }
}

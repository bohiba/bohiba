import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/pages/status/load_tile.dart';
import 'package:flutter/material.dart';

class LoadStatusScreen extends StatelessWidget {
  const LoadStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bohibaColors.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: BohibaResponsiveScreen.width15,
          vertical: BohibaResponsiveScreen.height10,
        ),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return LoadTile(index: index);
          },
        ),
      ),
    );
  }
}

import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/status/compelete_tile.dart';
import 'package:flutter/material.dart';

class CompleteStatusScreen extends StatelessWidget {
  const CompleteStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: BohibaResponsiveScreen.width15,
          vertical: BohibaResponsiveScreen.height10,
        ),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return CompeleteTile();
          },
        ),
      ),
    );
  }
}

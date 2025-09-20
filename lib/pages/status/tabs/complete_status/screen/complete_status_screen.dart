import '/component/screen_utils.dart';
import '/pages/status/compelete_tile.dart';
import 'package:flutter/material.dart';

class CompleteStatusScreen extends StatelessWidget {
  const CompleteStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width15,
          vertical: ScreenUtils.height10,
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

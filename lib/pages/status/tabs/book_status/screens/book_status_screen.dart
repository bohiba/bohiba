import '/dist/component_exports.dart';
import '/pages/status/book_tile.dart';
import 'package:flutter/material.dart';

class BookStatusScreen extends StatelessWidget {
  const BookStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BohibaColors.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width15,
          vertical: ScreenUtils.height10,
        ),
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return BookTile(index: index);
          },
        ),
      ),
    );
  }
}
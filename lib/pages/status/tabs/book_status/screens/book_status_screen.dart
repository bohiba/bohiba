import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/pages/status/book_tile.dart';
import 'package:flutter/material.dart';

class BookStatusScreen extends StatelessWidget {
  const BookStatusScreen({super.key});

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
          itemCount: 2,
          itemBuilder: (context, index) {
            return BookTile(index: index);
          },
        ),
      ),
    );
  }
}

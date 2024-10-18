import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_colors.dart';

class BookStatusScreen extends StatelessWidget {
  const BookStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bohibaColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: ListTile(
                onTap: () {},
                minTileHeight: 65,
                title: const Text('0D 14A 7224'),
                subtitle: const Text('24-22 Tonne'),
                trailing: const Text('Paid'),
                leadingAndTrailingTextStyle: TextStyle(
                  fontWeight: bohibaTheme
                      .listTileTheme.leadingAndTrailingTextStyle!.fontWeight,
                  fontFamily: bohibaTheme
                      .listTileTheme.leadingAndTrailingTextStyle!.fontFamily,
                  fontSize: bohibaTheme
                      .listTileTheme.leadingAndTrailingTextStyle!.fontSize,
                  color: bohibaColors.successColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

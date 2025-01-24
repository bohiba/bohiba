import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:remixicon/remixicon.dart';

class CompanyHistoryButton extends StatelessWidget {
  final VoidCallback onTap;

  const CompanyHistoryButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: Material(
        type: MaterialType.button,
        elevation: 0.5,
        color: bohibaColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: height * 0.070,
            height: height * 0.070,
            decoration: BoxDecoration(
                color: bohibaColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1.0, color: Colors.black)),
            child: const Icon(Remix.history_line, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class CompanyBookLoadButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final TextStyle? style;

  const CompanyBookLoadButton(
      {super.key, this.onTap, this.label = "Text", this.style});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: Material(
        type: MaterialType.button,
        elevation: 0.5,
        color: bohibaColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: width * 0.5,
            height: height * 0.070,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(label,
                style: TextStyle(
                    fontWeight:
                        Theme.of(context).textTheme.labelLarge!.fontWeight,
                    fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                    color: bohibaColors.white)),
          ),
        ),
      ),
    );
  }
}

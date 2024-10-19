import 'package:flutter/material.dart';

import '../bohiba_colors.dart';

class BottomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double width;
  final double height;
  final String labelPrice;

  const BottomButton({
    Key? key,
    this.onTap,
    this.height = 47,
    this.width = 210,
    this.labelPrice = "Bank Button",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Material(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Material(
                type: MaterialType.button,
                elevation: 0.5,
                color: onTap == null
                    ? bohibaColors.secoundaryColor
                    : bohibaColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: width,
                    height: height,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      labelPrice,
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontSize,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontWeight,
                          color: bohibaColors.white),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

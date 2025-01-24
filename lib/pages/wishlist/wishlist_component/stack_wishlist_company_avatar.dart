import 'package:bohiba/component/screen_utils.dart';
import 'package:flutter/material.dart';

class StackCompanyAvatar extends StatelessWidget {
  final String? fromCompanyAvatar;
  final String? toCompanyAvatar;

  const StackCompanyAvatar({
    super.key,
    this.fromCompanyAvatar,
    this.toCompanyAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BohibaResponsiveScreen.width50,
      margin: EdgeInsets.only(right: BohibaResponsiveScreen.width15),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 5,
            left: 0,
            child: Container(
              height: BohibaResponsiveScreen.height30,
              width: BohibaResponsiveScreen.height30,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.grey.shade100),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 4,
            child: Container(
              height: BohibaResponsiveScreen.height30,
              width: BohibaResponsiveScreen.height30,
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.grey.shade100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

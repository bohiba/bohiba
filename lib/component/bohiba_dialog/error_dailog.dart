import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_colors.dart';

class ErrorDialog extends StatelessWidget {
  final String error;

  const ErrorDialog({Key? key, this.error = "Something went wrong"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text('Alert Message'),
      /*titleTextStyle: GoogleFonts.poppins(
        color: BohibaColors.warning,
      ),*/
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      children: [
        Container(
          height: 35,
          width: 120,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bohibaColors.primaryColor.withOpacity(0.09),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                EvaIcons.alertCircleOutline,
                color: bohibaColors.primaryColor,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  error,
                  style: TextStyle(
                    fontSize: 14,
                    color: bohibaColors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

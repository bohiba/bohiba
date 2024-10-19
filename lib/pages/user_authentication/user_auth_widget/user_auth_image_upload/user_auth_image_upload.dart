import 'dart:io';

import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class UserAuthContainerImageUpload extends StatefulWidget {
  final String label;
  final DecorationImage? imageDec;
  final VoidCallback? onTap;
  final File? img;

  const UserAuthContainerImageUpload({
    Key? key,
    this.label = "User Auth Container Image Upload",
    this.imageDec,
    this.onTap,
    this.img,
  }) : super(key: key);

  @override
  State<UserAuthContainerImageUpload> createState() =>
      _UserAuthContainerImageUploadState();
}

class _UserAuthContainerImageUploadState
    extends State<UserAuthContainerImageUpload> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: bohibaColors.lightGreyColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 1.5,
        child: InkWell(
          // onTap: imagePicker,
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: height * 0.2,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: widget.img != null
                  ? DecorationImage(
                      image: FileImage(
                        File(widget.img!.path),
                      ),
                      fit: BoxFit.cover)
                  : null,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: widget.img == null
                ? Text(
                    widget.label,
                    style: TextStyle(
                      color: bohibaTheme.textTheme.bodySmall!.color,
                      fontFamily: bohibaTheme.textTheme.bodySmall!.fontFamily,
                      fontWeight: bohibaTheme.textTheme.labelLarge!.fontWeight,
                    ),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}

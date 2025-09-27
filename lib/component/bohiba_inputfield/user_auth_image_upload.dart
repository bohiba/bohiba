import 'dart:io';

import '/component/screen_utils.dart';
import '/component/bohiba_colors.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class UserAuthContainerImageUpload extends StatefulWidget {
  final String label;
  final DecorationImage? imageDec;
  final VoidCallback? onTap;
  final File? img;

  const UserAuthContainerImageUpload({
    super.key,
    this.label = "User Auth Container Image Upload",
    this.imageDec,
    this.onTap,
    this.img,
  });

  @override
  State<UserAuthContainerImageUpload> createState() =>
      _UserAuthContainerImageUploadState();
}

class _UserAuthContainerImageUploadState
    extends State<UserAuthContainerImageUpload> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: BohibaColors.lightGreyColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 1.5,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: ScreenUtils.width,
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

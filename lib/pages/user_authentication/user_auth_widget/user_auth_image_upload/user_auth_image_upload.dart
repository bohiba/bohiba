import 'dart:io';

import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UserAuthContainerImageUpload extends StatefulWidget {
  final String label;
  final DecorationImage? imageDec;

  const UserAuthContainerImageUpload({
    Key? key,
    this.label = "User Auth Container Image Upload",
    this.imageDec,
  }) : super(key: key);

  @override
  State<UserAuthContainerImageUpload> createState() =>
      _UserAuthContainerImageUploadState();
}

class _UserAuthContainerImageUploadState
    extends State<UserAuthContainerImageUpload> {
  File? img;

  void imagePicker() async {
    try {
      XFile? image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 25);

      if (image == null) return;
      setState(() {
        img = File(image.path);
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

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
        elevation: 2.0,
        child: InkWell(
          onTap: imagePicker,
          // onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: height * 0.2,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: img != null
                  ? DecorationImage(
                      image: FileImage(
                        File(img!.path),
                      ),
                      fit: BoxFit.cover)
                  : null,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: img == null
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

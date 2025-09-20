import 'dart:io';
import '/component/bohiba_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class DocumentImagePicker extends StatefulWidget {
  final String label;
  final double width;
  final double height;
  final Color? backgroundColor;
  const DocumentImagePicker(
      {this.label = "Label",
      this.width = double.maxFinite,
      this.height = 50,
      this.backgroundColor,
      super.key});

  @override
  State<DocumentImagePicker> createState() => _DocumentImagePickerState();
}

class _DocumentImagePickerState extends State<DocumentImagePicker> {
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
    double width = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () {
        imagePicker();
      },
      child: Container(
        height: 45,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: img == null
                ? BohibaColors.primaryVariantColor
                : BohibaColors.primaryColor,
            borderRadius: BorderRadius.circular(8.0)),
        child: Text(widget.label,
            style: TextStyle(
                color: BohibaColors.white,
                fontWeight:
                    Theme.of(context).textTheme.labelLarge!.fontWeight)),
      ),
    );
  }
}

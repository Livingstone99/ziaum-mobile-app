import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:switch_app/constants/colors.dart';
import 'package:switch_app/widgets/textWidget.dart';

class ImageSourceDialog extends StatelessWidget {
  final ValueChanged<ImageSource> onImageSourceSelected;

  const ImageSourceDialog({Key? key, required this.onImageSourceSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bgColor,
      title: TextWidget(text: 'Choose an option'),
      // content: TextWidget(
      //     text:
      //         'Would you like to pick a picture from the gallery or take a new picture?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onImageSourceSelected(
                ImageSource.gallery); // Call callback with gallery source
          },
          child: Row(
            children: [
              Icon(Icons.photo, color: Colors.blue),
              SizedBox(width: 8),
              TextWidget(text: 'Gallery'),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onImageSourceSelected(
                ImageSource.camera); // Call callback with camera source
          },
          child: Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.blue),
              SizedBox(width: 8),
              TextWidget(text: 'Camera'),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _pickedPicture;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final selectedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (selectedImage == null) {
      return;
    }

    setState(() {
      _pickedPicture = File(selectedImage.path);
    });

    widget.onPickImage(_pickedPicture!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _pickedPicture != null
        ? GestureDetector(
            onTap: _takePicture,
            child: Image.file(
              _pickedPicture!,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          )
        : TextButton.icon(
            icon: const Icon(Icons.camera),
            label: const Text('Take picture'),
            onPressed: _takePicture,
          );

    return Container(
      alignment: Alignment.center,
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: content,
    );
  }
}

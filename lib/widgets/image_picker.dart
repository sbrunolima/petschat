import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFunction);

  final void Function(File pickedImage) imagePickFunction;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path == null
          ? 'assets/profile.png'
          : pickedImageFile.path);
    });
    widget.imagePickFunction(File(_pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _pickedImage == null
                ? Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.asset('assets/profile.png'),
                  )
                : Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _pickedImage != null
                        ? Image.file(
                            _pickedImage!,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
            SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    Text(
                      'Adicionar Au-magem',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

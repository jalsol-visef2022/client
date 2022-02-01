import 'dart:io';

import 'package:client/globals.dart';
import 'package:client/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
        source: (global.srcOption == SourceOption.gallery)
            ? ImageSource.gallery
            : ImageSource.camera);

    setState(() {
      image = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Chọn ảnh từ " +
            ((global.srcOption == SourceOption.gallery)
                ? "Kho ảnh"
                : "Máy ảnh")),
        actions: const [SettingsDialog()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 450,
              child: (image == null)
                  ? const Center(child: Text("Chưa chọn ảnh."))
                  : Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(height: 100, width: 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (image != null) {
                        Navigator.pushNamed(context, '/result',
                            arguments: image);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.send, size: 30),
                        Text("Gửi"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(height: 100, width: 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => pickImage(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.drive_folder_upload, size: 30),
                        Text("Chọn"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

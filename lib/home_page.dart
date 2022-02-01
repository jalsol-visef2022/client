import 'package:client/globals.dart';
import 'package:client/settings_dialog.dart';

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    global.initSettingsDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Ứng dụng Di động"),
        actions: const [
          SettingsDialog(),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Expanded(
            //   child: Image.asset('assets/images/pepe.jpg'),
            // ),
            ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(height: 150, width: 150),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  global.srcOption = SourceOption.camera;
                  Navigator.pushNamed(context, '/select');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.photo_camera,
                      size: 30,
                    ),
                    Text("Chụp ảnh mới"),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(height: 150, width: 150),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  global.srcOption = SourceOption.gallery;
                  Navigator.pushNamed(context, '/select');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.folder,
                      size: 30,
                    ),
                    Text("Chọn trong máy"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

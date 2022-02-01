import 'globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData {
  String contactName = "";
  String homeAddress = "";
  String phoneNumber = "";
  String apiAddress = "";

  SettingsData({
    required this.contactName,
    required this.homeAddress,
    required this.phoneNumber,
    required this.apiAddress,
  });
}

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  TextEditingController contactNameInputController = TextEditingController();
  TextEditingController homeAddressInputController = TextEditingController();
  TextEditingController phoneNumberInputController = TextEditingController();
  TextEditingController apiAddressInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    global.initSettingsDialog();

    contactNameInputController.text = global.settings.contactName;
    homeAddressInputController.text = global.settings.homeAddress;
    phoneNumberInputController.text = global.settings.phoneNumber;
    apiAddressInputController.text = global.settings.apiAddress;
  }

  Future<SettingsData> loadSettingsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    return SettingsData(
      contactName: prefs.getString('contactName') ?? "",
      homeAddress: prefs.getString('homeAddress') ?? "",
      phoneNumber: prefs.getString('phoneNumber') ?? "",
      apiAddress: prefs.getString('apiAddress') ?? "",
    );
  }

  Future<void> mountSettings() async {
    SettingsData asyncUriData = await loadSettingsFromPrefs();
    global.globalMountSettings(asyncUriData);
  }

  Future<void> setUri(SettingsData data, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contactName', data.contactName);
    await prefs.setString('homeAddress', data.homeAddress);
    await prefs.setString('phoneNumber', data.phoneNumber);
    await prefs.setString('apiAddress', data.apiAddress);

    global.globalMountSettings(data);

    SnackBar mySnackBar = SnackBar(
        content: Text('(Dev) API Address set: ${global.settings.apiAddress}'));
    ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
  }

  Future createSettingsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cài đặt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: contactNameInputController,
                decoration: const InputDecoration(hintText: 'Tên'),
              ),
              TextField(
                controller: homeAddressInputController,
                decoration: const InputDecoration(hintText: 'Địa chỉ'),
              ),
              TextField(
                controller: phoneNumberInputController,
                decoration: const InputDecoration(hintText: 'Số điện thoại'),
              ),
              TextField(
                controller: apiAddressInputController,
                decoration:
                    const InputDecoration(hintText: 'API Address (Dev)'),
              ),
            ],
          ),
          actions: [
            MaterialButton(
              child: const Text('Lưu'),
              onPressed: () {
                Navigator.of(context).pop(
                  SettingsData(
                    contactName: contactNameInputController.text.toString(),
                    homeAddress: homeAddressInputController.text.toString(),
                    phoneNumber: phoneNumberInputController.text.toString(),
                    apiAddress: apiAddressInputController.text.toString(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    mountSettings();
    return IconButton(
      onPressed: () {
        global.initSettingsDialog();
        contactNameInputController.text = global.settings.contactName;
        homeAddressInputController.text = global.settings.homeAddress;
        phoneNumberInputController.text = global.settings.phoneNumber;
        apiAddressInputController.text = global.settings.apiAddress;

        createSettingsDialog(context).then((data) {
          setUri(data, context);
        });
      },
      icon: const Icon(Icons.settings),
    );
  }
}

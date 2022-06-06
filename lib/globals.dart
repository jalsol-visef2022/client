// import 'dart:math';

import 'package:client/settings_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SourceOption { gallery, camera }

class Global {
  SourceOption srcOption = SourceOption.gallery;

  SettingsData settings = SettingsData(
      contactName: "", homeAddress: "", phoneNumber: "", apiAddress: "");

  String prediction = '';
  Map<String, dynamic> jsonItems = {};

  Future<void> initSettingsDialog() async {
    final prefs = await SharedPreferences.getInstance();
    settings.contactName = prefs.getString('contactName') ?? "";
    settings.homeAddress = prefs.getString('homeAddress') ?? "";
    settings.phoneNumber = prefs.getString('phoneNumber') ?? "";
    settings.apiAddress = prefs.getString('apiAddress') ?? "";
  }

  void globalMountSettings(SettingsData _settings) {
    settings = _settings;
  }

  String fullNameOfDisease() {
    return jsonItems[prediction]['name'];
  }
}

Global global = Global();

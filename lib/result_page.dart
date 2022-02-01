import 'dart:convert';
import 'dart:io';

import 'package:client/globals.dart';
import 'package:client/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class RespondedData {
  final String message;
  final String status;
  final String prediction;
  final String confidence;

  RespondedData({
    required this.message,
    required this.status,
    required this.prediction,
    required this.confidence,
  });

  factory RespondedData.fromJson(Map<String, dynamic> json) {
    return RespondedData(
      message: json['Message'],
      status: json['Status'],
      prediction: json['Prediction'],
      confidence: json['Confidence'],
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<ResultPage> {
  late Future<RespondedData> futureInfo;

  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context)!.settings.arguments as XFile;
    futureInfo = sendRequest(image);
    retrieveJsonData();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Kết quả"),
        actions: const [SettingsDialog()],
      ),
      body: Center(
        child: FutureBuilder<RespondedData>(
          future: futureInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return showFinalResult(
                  snapshot.data!.prediction, snapshot.data!.confidence, image);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => share(context, image),
        child: const Icon(Icons.share),
      ),
    );
  }

  Future<RespondedData> sendRequest(XFile image) async {
    Uri uri = Uri.parse('http://${global.settings.apiAddress}/predict/');

    var request = MultipartRequest('POST', uri);
    request.files.add(await MultipartFile.fromPath('image', image.path));

    var streamedResponse = await request.send();
    var response = await Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return RespondedData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gửi ảnh thất bại.');
    }
  }

  Future<void> retrieveJsonData() async {
    final String response = await rootBundle.loadString('assets/info.json');
    global.jsonItems = await json.decode(response);
  }

  void share(BuildContext context, XFile image) {
    final RenderBox? box = context.findRenderObject() as RenderBox;
    final String text = "Tên: ${global.settings.contactName}\n"
        "Địa chỉ: ${global.settings.homeAddress}\n"
        "Số điện thoại: ${global.settings.phoneNumber}\n"
        "Thông báo về trường hợp Sâu/Bệnh: ${global.fullNameOfDisease()}.";

    Share.shareFiles([image.path],
        text: text,
        subject: global.fullNameOfDisease(),
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  Widget getInfoFromJson(String prediction) {
    String result =
        "1. Thông tin:\n - ${global.jsonItems[prediction]["description"]}\n"
        "2. Triệu chứng:\n - ${global.jsonItems[prediction]["symptoms"]}\n"
        "3. Giải pháp:\n";

    List solutions = global.jsonItems[prediction]["solutions"];

    for (var item in solutions) {
      result += "- $item\n";
    }

    return Text(result);
  }

  Widget showFinalResult(prediction, confidence, image) {
    global.prediction = prediction;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 150, maxWidth: 150),
          // child: Image.network(
          //     'http://${global.settings.apiAddress}/get_result?version=${global.rng.nextInt(10000)}'),
          child: Image.file(
            File(image!.path),
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Kết quả: ${global.jsonItems[prediction]["name"]}',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('Tỉ lệ dự đoán: $confidence%'),
        const SizedBox(height: 30),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(height: 250, width: 300),
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: getInfoFromJson(prediction),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Hãy liên lạc tới Trung tâm Khuyến nông nếu cần thiết!',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

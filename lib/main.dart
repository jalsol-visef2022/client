import 'package:client/result_page.dart';
import 'package:client/select_page.dart';
import 'package:flutter/material.dart';

import 'package:client/home_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:
          "A client app that requests and receive responses from the server.",

      // routes
      initialRoute: '/',
      routes: {
        '/': (context) => const Homepage(),
        '/select': (context) => const SelectPage(),
        '/result': (context) => const ResultPage(),
      },
    );
  }
}

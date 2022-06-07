import 'package:flutter/material.dart';
import 'package:refresh_flutter/refresh_api_page.dart';
import 'package:refresh_flutter/refresh_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RefreshApiPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tagz/Screens%20Layouts/File_Upload_Screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: fileUploadScreen()
    );
  }
}

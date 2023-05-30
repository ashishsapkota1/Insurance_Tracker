import 'package:flutter/material.dart';
import 'package:hira/screens/home_page.dart';
import 'package:nepali_utils/nepali_utils.dart';


void main() {
  runApp(const MyApp());
  NepaliUtils(Language.nepali);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Homepage(),
    );
  }
}


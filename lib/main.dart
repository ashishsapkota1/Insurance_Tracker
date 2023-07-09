import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hira/screens/home_page.dart';
import 'package:nepali_utils/nepali_utils.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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


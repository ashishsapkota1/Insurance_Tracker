import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hira/screens/home_page.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var indexes = [
    Index(
      collectionGroup: "renewals",
      queryScope: QueryScope.collection,
      fields: [
        IndexField(fieldPath: "year", order: Order.ascending),
        IndexField(fieldPath: "session", order: Order.ascending),
        IndexField(fieldPath: 'receiptNo', order: Order.ascending)
      ],
    ),
    Index(
      collectionGroup: "renewals",
      queryScope: QueryScope.collection,
      fields: [
        IndexField(fieldPath: "family", order: Order.ascending),
        IndexField(fieldPath: "year", order: Order.descending),
      ],
    ),
  ];
  await FirebaseFirestore.instance.setIndexConfiguration(indexes: indexes);

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


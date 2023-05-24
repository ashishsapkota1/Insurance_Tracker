import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String familyTable= 'family_table';
  String name='';
  int hiCode= 0;
  String phnNo= '';
  int membersNo= 0;
  String renewalSession = '';
  String annualFee= '';
  String lastRenewal='';
  String type='';
  String renewalDue='';

  String transactionTable = 'transaction_table';
  int id=0;
  int family = 0;
  int year = 0;
  String session = '';
  String amount = '';
  String dateOfTransaction = '';
  bool isAmountReceived = false;
  String transactionType = '';


  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}insurance.db';

    var insuranceDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return insuranceDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $familyTable($hiCode INTEGER PRIMARY KEY, $name TEXT, '
        '$phnNo TEXT, $membersNo INTEGER, $renewalSession TEXT, $annualFee TEXT,$lastRenewal Text,$type Text,$renewalDue Text)'
    );
    await db.execute(
        'CREATE TABLE $transactionTable($id INTEGER PRIMARY KEY AUTO INCREMENT, $family INTEGER, '
        '$year INTEGER, $session TEXT, $amount TEXT,$dateOfTransaction TEXT, $isAmountReceived Bool,$transactionType Text)'
    );
  }

  Future<List<Map<String, dynamic>>> getAllFamily() async {
    Database db = await database;
    var result = await db.query(familyTable);
    return result;
  }


  // Future<int> insertNote() async {
  //   Database db = await database;
  //     var result = await db.insert();
  //     return result;
  // }

}

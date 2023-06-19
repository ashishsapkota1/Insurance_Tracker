import 'package:flutter/cupertino.dart';
import 'package:hira/database_helper/family.dart';
import 'package:hira/database_helper/transaction.dart';
import 'package:hira/database_helper/user_Repo.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  DatabaseHelper._internal();

  Future<Database?> openDB() async {
    _database =
        await openDatabase(join(await getDatabasesPath(), 'insurance.db'));
    return _database;
  }

  Future<int> insertFamily(
      TextEditingController familyHeadController,
      TextEditingController membershipNoController,
      TextEditingController phoneNoController,
      TextEditingController noOfMembersController,
      TextEditingController annualFeeController,
      TextEditingController receiptNoController,
      TextEditingController familyTypeController,
      TextEditingController transactionTypeController,
      TextEditingController yearController,
      TextEditingController sessionController,
      TextEditingController amountReceivedController) async {
    _database = await openDB();
    UserRepo userRepo = UserRepo();
    userRepo.createDb(_database);
    // try {
    Family familyData = Family(
        int.tryParse(membershipNoController.text) ?? 0,
        familyHeadController.text,
        phoneNoController.text,
        int.tryParse(noOfMembersController.text) ?? 0,
        sessionController.text,
        annualFeeController.text,
        familyTypeController.text,
        (int.tryParse(yearController.text)) ?? 0,
        sessionController.text);

    TransactionDetail transactionData = TransactionDetail(
      int.tryParse(membershipNoController.text) ?? 0,
      int.tryParse(yearController.text) ?? 0,
      sessionController.text,
      annualFeeController.text,
      NepaliDateTime.now().toString(),
      amountReceivedController.text,
      transactionTypeController.text,
      receiptNoController.text,
    );
    _database?.insert('familyTable', familyData.toMap());
    _database?.insert('transactionDetailTable', transactionData.toMap());
    return 1;
    // } catch(error){
    //   return 0;
    // }
  }

  Future<List<Map<String, dynamic>>> getTableData() async {
    await openDB();

    final List<Map<String, dynamic>> familyTableData =
        await _database!.query('familyTable');

    return familyTableData;
  }

  Future<List<Map<String, dynamic>>> getLapsedFamily() async {
    await openDB();
    NepaliDateTime today = NepaliDateTime.now();
    List<String> months = [
      'Baishakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra'
    ];
    final List<Map<String, dynamic>> allFamilyData =
        await _database!.query('familyTable');
    List<Map<String, dynamic>> lapsedFamily = [];
    allFamilyData.map((Map<String, dynamic> fam) {
          List<String> words = fam['lastRenewalSession'].toString().split("-");
          NepaliDateTime lastRenewalDate = NepaliDateTime(
            fam['lastRenewalYear']+1,
            months.indexOf(words[0]) + 2,
            0
          );
          if (today.isAfter(lastRenewalDate)) {
            lapsedFamily.add(fam);
          }
    });
    return lapsedFamily;
  }

  Future<List<Map<String, dynamic>>> getThisSessionData(int year, String session) async {
    await openDB();
    final List<Map<String, dynamic>> familyTableData =
    await _database!.query('familyTable',
      where: '(lastRenewalYear = ? AND renewalSession = ?) OR (lastRenewalYear = ? AND renewalSession = ?)',
        whereArgs: [year, session, year-1, session]
    );
    return familyTableData;
  }

  Future<List<Map<String, dynamic>>> searchData(String searchTerm) async {
    await openDB();

    return _database!.query('familyTable',
        where: 'LOWER(hiCode) LIKE LOWER(?) OR LOWER(name) LIKE LOWER(?)',
        whereArgs: ['%$searchTerm%', '%$searchTerm%']);
  }
}

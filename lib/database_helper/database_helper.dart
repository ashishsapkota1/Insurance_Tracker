import 'package:flutter/cupertino.dart';
import 'package:hira/database_helper/family.dart';
import 'package:hira/database_helper/transaction.dart';
import 'package:hira/database_helper/user_Repo.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      TextEditingController addressController,
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
    try {
      Family familyData = Family(
          int.tryParse(membershipNoController.text) ?? 0,
          familyHeadController.text,
          phoneNoController.text,
          int.tryParse(noOfMembersController.text) ?? 0,
          sessionController.text,
          annualFeeController.text,
          familyTypeController.text,
          (int.tryParse(yearController.text)) ?? 0,
          sessionController.text,
          addressController.text
      );

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
      await _database?.insert('familyTable', familyData.toMap());
      await _database?.insert('transactionDetailTable', transactionData.toMap());
      return 1;
    } catch(error){
      return 0;
    }
  }

  Future<int> updateFamily(
      TextEditingController familyHeadController,
      TextEditingController membershipNoController,
      TextEditingController phoneNoController,
      TextEditingController addressController,
      TextEditingController noOfMembersController,
      TextEditingController annualFeeController,
      TextEditingController familyTypeController,
      TextEditingController yearController,
      TextEditingController sessionController) async {
    _database = await openDB();
    UserRepo userRepo = UserRepo();
    userRepo.createDb(_database);
    try {
      Family familyData = Family(
          0,
          familyHeadController.text,
          phoneNoController.text,
          int.tryParse(noOfMembersController.text) ?? 0,
          sessionController.text,
          annualFeeController.text,
          familyTypeController.text,
          (int.tryParse(yearController.text)) ?? 0,
          sessionController.text,
          addressController.text
      );
      await _database?.update('familyTable', familyData.updateFamilyMap(),
        where: 'hiCode = ?',
        whereArgs: [int.tryParse(membershipNoController.text)]
      );
      return 1;
    } catch(error){
      return 0;
    }
  }

  Future<int> renewInsurance(
      String hiCode,
      String amount,
      TextEditingController receiptNoController,
      TextEditingController yearController,
      TextEditingController sessionController,
      TextEditingController amountReceivedController) async {
    _database = await openDB();
    UserRepo userRepo = UserRepo();
    userRepo.createDb(_database);
    try {
      Family familyData = Family(
          0,
          '',
          '',
          0,
          sessionController.text,
          '',
          '',
          (int.tryParse(yearController.text)) ?? 0,
          sessionController.text,
          ''
      );
      TransactionDetail transactionData = TransactionDetail(
        int.tryParse(hiCode) ?? 0,
        int.tryParse(yearController.text) ?? 0,
        sessionController.text,
        amount,
        NepaliDateTime.now().toString(),
        amountReceivedController.text,
        "Renew",
        receiptNoController.text,
      );
      final List<Map<String, dynamic>> familyTableData =
          await _database!.query('transactionDetailTable',
            where: 'family = ? AND year = ? AND session = ?',
            whereArgs: [int.tryParse(hiCode), int.tryParse(yearController.text), sessionController.text]
          );
      if (familyTableData.isEmpty){
        await _database?.insert('transactionDetailTable', transactionData.toMap());
        await _database?.update('familyTable', familyData.updateFamilyWhileRenew(),
          where: 'hiCode = ?',
          whereArgs: [hiCode],
        );
        return 1;
      }
      else {
        return 0;
      }
    } catch(error){
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getTableData() async {
    // await openDB();

    // final List<Map<String, dynamic>> familyTableData =
    //     await _database!.query('familyTable',
    //       orderBy: 'name ASC'
    //     );
    final List<Map<String, dynamic>> familyTableData = [];
    await FirebaseFirestore.instance.collection("family").orderBy("name").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          familyTableData.add({'id': docSnapshot.id, ...docSnapshot.data()});
        }
      }
    );
    return familyTableData;
  }


  Future<Map<String, dynamic>> getOneFamily(int hiCode) async {
    final List<Map<String, dynamic>> family = [];
    final List<Map<String, dynamic>> allRenewals = [];
    await FirebaseFirestore.instance.collection("family").where("hiCode", isEqualTo: hiCode).get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            family.add({'id': docSnapshot.id, ...docSnapshot.data()});
          }
        }
    );
    await FirebaseFirestore.instance.collection("renewals").where("family", isEqualTo: hiCode).get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            allRenewals.add({'id': docSnapshot.id, ...docSnapshot.data()});
          }
        }
    );
    Map<String, dynamic> oneFamily = {
      'family': family[0],
      'transactions': allRenewals
    };
    return oneFamily;


    // await openDB();
    //
    // final List<Map<String, dynamic>> familyTableData =
    //   await _database!.query('familyTable',
    //     where: 'hiCode = ?',
    //     whereArgs: [hiCode],
    //   );
    // final List<Map<String, dynamic>> allTransactions =
    //   await _database!.query('transactionDetailTable',
    //     where: 'family = ?',
    //     whereArgs: [hiCode],
    //     orderBy: 'year DESC'
    //   );
    // final Map<String, dynamic> oneFamily = {
    //   'family': familyTableData[0],
    //   'transactions': allTransactions
    // };
    // return oneFamily;
  }


  Future<List<Map<String, dynamic>>> getThisSessionData(int year, String session) async {
    final List<Map<String, dynamic>> allFamily = await getTableData();
    List<Map<String, dynamic>> thisSessionData = [];
    for (var fam in allFamily) {
      int lastRenewalYear = fam['lastRenewalYear'];
      String lastRenewalSession = fam['lastRenewalSession'];
      if ((lastRenewalYear == year && lastRenewalSession == session) || (lastRenewalYear == year-1 && lastRenewalSession == session)) {
        thisSessionData.add(fam);
      }
    }
    return thisSessionData;
    // await openDB();
    // final List<Map<String, dynamic>> familyTableData =
    // await _database!.query('familyTable',
    //   where: '(lastRenewalYear = ? AND renewalSession = ?) OR (lastRenewalYear = ? AND renewalSession = ?)',
    //     whereArgs: [year, session, year-1, session],
    //   orderBy: 'name ASC'
    // );
    // return familyTableData;
  }

  Future<List<Map<String, dynamic>>> searchData(String searchTerm) async {
    // final List<Map<String, dynamic>> allFamily = await getTableData();
    // List<Map<String, dynamic>> searchedData = [];
    // for (var fam in allFamily) {
    //   String name = fam['name'];
    //   int hiCode = fam['hiCode'];
    //   if (name.toLowerCase().contains(searchTerm.toLowerCase()) || hiCode.toString().toLowerCase().contains(searchTerm.toLowerCase())){
    //     searchedData.add(fam);
    //   }
    // }
    // return searchedData;
    await openDB();

    return _database!.query('familyTable',
        where: 'LOWER(hiCode) LIKE LOWER(?) OR LOWER(name) LIKE LOWER(?)',
        whereArgs: ['%$searchTerm%', '%$searchTerm%']);
  }
}

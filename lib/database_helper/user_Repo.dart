import 'package:sqflite/sqflite.dart';

class UserRepo{
  void createDb(Database? db) async {
    await db?.execute(
        'CREATE TABLE IF NOT EXISTS familyTable(hiCode INTEGER PRIMARY KEY, name TEXT, '
            'phnNo TEXT, membersNo INTEGER, renewalSession TEXT, '
            'annualFee TEXT, type TEXT, lastRenewalYear INTEGER, lastRenewalSession TEXT)');
    await db?.execute(
        'CREATE TABLE IF NOT EXISTS transactionDetailTable(id INTEGER PRIMARY KEY AUTOINCREMENT, family INTEGER, '
            'year INTEGER, session TEXT, amount TEXT, dateOfTransaction TEXT, '
            'isAmountReceived TEXT, transactionType TEXT, receiptNo TEXT)');
  }
}
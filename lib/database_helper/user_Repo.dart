import 'package:sqflite/sqflite.dart';

class UserRepo{
  void createDb(Database? db) async {
    await db?.execute(
        'CREATE TABLE IF NOT EXISTS familyTable(hiCode INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, '
            'phnNo TEXT NOT NULL, membersNo INTEGER NOT NULL, renewalSession TEXT NOT NULL, '
            'annualFee TEXT NOT NULL, type TEXT, lastRenewalYear INTEGER, lastRenewalSession TEXT, address TEXT)');
    await db?.execute(
        'CREATE TABLE IF NOT EXISTS transactionDetailTable(id INTEGER PRIMARY KEY AUTOINCREMENT, family INTEGER, '
            'year INTEGER, session TEXT, amount TEXT, dateOfTransaction TEXT, '
            'isAmountReceived TEXT, transactionType TEXT, receiptNo TEXT)');
  }
}
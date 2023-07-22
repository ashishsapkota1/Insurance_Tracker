import 'package:flutter/cupertino.dart';
import 'package:hira/database_helper/family.dart';
import 'package:hira/database_helper/transaction.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  DatabaseHelper._internal();

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
    try {
      Family familyData = Family(
          int.tryParse(membershipNoController.text) ?? 0,
          familyHeadController.text,
          phoneNoController.text,
          int.tryParse(noOfMembersController.text) ?? 0,
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
      FirebaseFirestore.instance.collection("family").add(familyData.toMap());
      FirebaseFirestore.instance.collection("renewals").add(transactionData.toMap());
      return 1;
    } catch(error){
      return 0;
    }
  }

  Future<int> updateFamily(
      String id,
      TextEditingController familyHeadController,
      TextEditingController membershipNoController,
      TextEditingController phoneNoController,
      TextEditingController addressController,
      TextEditingController noOfMembersController,
      TextEditingController annualFeeController,
      TextEditingController familyTypeController,
      TextEditingController yearController,
      TextEditingController sessionController) async {
    try {
      Family familyData = Family(
          int.tryParse(membershipNoController.text) ?? 0,
          familyHeadController.text,
          phoneNoController.text,
          int.tryParse(noOfMembersController.text) ?? 0,
          annualFeeController.text,
          familyTypeController.text,
          (int.tryParse(yearController.text)) ?? 0,
          sessionController.text,
          addressController.text
      );
      FirebaseFirestore.instance.collection("family").doc(id).update(familyData.toMap());
      return 1;
    } catch(error){
      return 0;
    }
  }

  Future<int> updateRenewal(
      String id,
      TextEditingController membershipNoController,
      TextEditingController annualFeeController,
      TextEditingController yearController,
      TextEditingController sessionController,
      TextEditingController amountReceivedController,
      TextEditingController transactionTypeController,
      TextEditingController receiptNoController) async {
    try {
      TransactionDetail transactionData = TransactionDetail(
        0,
        int.tryParse(yearController.text) ?? 0,
        sessionController.text,
        annualFeeController.text,
        '',
        amountReceivedController.text,
        transactionTypeController.text,
        receiptNoController.text,
      );
      FirebaseFirestore.instance.collection("renewals").doc(id).update(transactionData.updateTransaction());
      return 1;
    } catch(error){
      return 0;
    }
  }

  Future<int> renewInsurance(
      String docId,
      String hiCode,
      String amount,
      TextEditingController receiptNoController,
      TextEditingController yearController,
      TextEditingController sessionController,
      TextEditingController amountReceivedController) async {
    try {
      Family familyData = Family(
          0,
          '',
          '',
          0,
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

      final List<Map<String, dynamic>> renewal = [];
      FirebaseFirestore.instance.collection("renewals")
        .where("family", isEqualTo: int.tryParse(hiCode))
        .where("year", isEqualTo: int.tryParse(yearController.text))
        .where("session", isEqualTo: sessionController.text)
        .get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            renewal.add({'id': docSnapshot.id, ...docSnapshot.data()});
          }
        }
      );
      if (renewal.isEmpty){
        FirebaseFirestore.instance.collection("family").doc(docId).update(familyData.updateFamilyWhileRenew());
        FirebaseFirestore.instance.collection("renewals").add(transactionData.toMap());
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
    await FirebaseFirestore.instance.collection("renewals").where("family", isEqualTo: hiCode)
        .orderBy('year', descending: true).get().then(
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
  }

  Future<Map<String, dynamic>> getOneRenewal(String id) async {
    Map<String, dynamic> oneRenewal = {};
    await FirebaseFirestore.instance.collection("renewals").doc(id).get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final docId = doc.id;
        oneRenewal = {'id': docId, ...data};
      }
    );
    return oneRenewal;
  }


  Future<Map<String, dynamic>> getThisSessionData(int year, String session) async {
    final List<Map<String, dynamic>> allFamily = await getTableData();
    final List<Map<String, dynamic>> allRenewals = [];
    await FirebaseFirestore.instance.collection("renewals")
        .where("year", isEqualTo: year)
        .where("session", isEqualTo: session)
        .orderBy('receiptNo')
        .get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            allRenewals.add({'id': docSnapshot.id, ...docSnapshot.data()});
          }
        }
    );
    Map<String, dynamic> thisSession =  filterThisSessionData(allFamily, allRenewals, year, session);
    return thisSession;
  }

  Map<String, dynamic> filterThisSessionData(List<Map<String, dynamic>> family,
      List<Map<String, dynamic>> renewals, int year, String session) {

    final List<Map<String, dynamic>> toBeRenewed = [];
    final List<Map<String, dynamic>> newGeneral = [];
    final List<Map<String, dynamic>> renewGeneral = [];
    final List<Map<String, dynamic>> newAged = [];
    final List<Map<String, dynamic>> newDisabled = [];
    final List<Map<String, dynamic>> renewDisabled = [];
    for (var fam in family) {
      final int lastRenewalYear = fam['lastRenewalYear'];
      final String lastRenewalSession = fam['lastRenewalSession'];
      final String familyType = fam['type'];
      if (lastRenewalYear == year - 1 && lastRenewalSession == session &&
          familyType != "Aged") {
        toBeRenewed.add(fam);
      }
    }
    for (var renew in renewals) {
        for (var fam in family) {
          Map<String, dynamic> familyDetail = {
            "name": fam['name'],
            "hiCode": fam['hiCode'],
            "isAmountReceived": renew['isAmountReceived'],
            "annualFee": renew['amount'],
            "receiptNo": renew['receiptNo'],
            "dateOfTransaction": renew['dateOfTransaction'],
            "phnNo": fam['phnNo'],
            "membersNo": fam['membersNo']
          };
          if (renew['family'] == fam['hiCode']) {
            if (renew['transactionType'] == 'New' && fam['type'] == "General") {
              newGeneral.add(familyDetail);
            } else if (renew['transactionType'] == 'Renew' &&
                fam['type'] == "General") {
              renewGeneral.add(familyDetail);
            } else if (renew['transactionType'] == 'New' &&
                fam['type'] == "Disabled") {
              newDisabled.add(familyDetail);
            } else if (renew['transactionType'] == 'Renew' &&
                fam['type'] == "Disabled") {
              renewDisabled.add(familyDetail);
            } else {
              newAged.add(familyDetail);
            }
          }
        }
    }
    Map<String, dynamic> thisSession = {
      'toBeRenewed': toBeRenewed,
      'newGeneral': newGeneral,
      'renewGeneral': renewGeneral,
      'newAged': newAged,
      'newDisabled': newDisabled,
      'renewDisabled': renewDisabled
    };
    return thisSession;
  }

  // Future<List<Map<String, dynamic>>> searchData(String searchTerm) async {
  //   await openDB();
  //
  //   return _database!.query('familyTable',
  //       where: 'LOWER(hiCode) LIKE LOWER(?) OR LOWER(name) LIKE LOWER(?)',
  //       whereArgs: ['%$searchTerm%', '%$searchTerm%']);
  // }
}

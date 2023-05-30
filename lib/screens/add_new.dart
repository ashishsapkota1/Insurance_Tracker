import 'package:flutter/material.dart';
import 'package:hira/database_helper/transaction.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hira/database_helper/database_helper.dart';
import 'package:hira/database_helper/family.dart';
import 'package:sqflite/sqflite.dart';

class AddFamily extends StatefulWidget {
  const AddFamily({Key? key}) : super(key: key);

  @override
  State<AddFamily> createState() => _AddFamilyState();
}

class _AddFamilyState extends State<AddFamily> {

  final Family family = Family(0, '', '', 0, '', '', '', 0, '');
  final TransactionDetail transactionDetail =
      TransactionDetail(0, 0, '', '', '', '', '', '');
  DatabaseHelper helper = DatabaseHelper();
  Database? _database;
  TextEditingController familyHeadController = TextEditingController();
  TextEditingController membershipNoController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController noOfMembersController = TextEditingController();
  TextEditingController annualFeeController = TextEditingController();
  TextEditingController receiptNoController = TextEditingController();
  TextEditingController familyTypeController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController sessionController = TextEditingController();
  TextEditingController amountReceivedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NepaliDateTime today = NepaliDateTime.now();
    NepaliDateTime firstSession = NepaliDateTime(today.year, 1, 1);
    NepaliDateTime secondSession = NepaliDateTime(today.year, 4, 1);
    NepaliDateTime thirdSession = NepaliDateTime(today.year, 7, 1);
    NepaliDateTime forthSession = NepaliDateTime(today.year, 10, 1);

    String sessionDropdownValue = '';
    if (today.isAfter(firstSession) && today.isBefore(secondSession)) {
      sessionDropdownValue = 'Baisakh-Jestha-Asar';
    } else if (today.isAfter(secondSession) && today.isBefore(thirdSession)) {
      sessionDropdownValue = 'Shrawan-Bhadra-Ashwin';
    } else if (today.isAfter(thirdSession) && today.isBefore(forthSession)) {
      sessionDropdownValue = 'Kartik-Mangsir-Poush';
    } else {
      sessionDropdownValue = 'Magh-Falgun-Chaitra';
    }
    sessionController.text = sessionDropdownValue;

    String familyTypeDropdownValue = 'Normal';
    familyTypeController.text = familyTypeDropdownValue;

    String yearsDropdownValue = NepaliDateTime.now().year.toString();
    yearController.text = yearsDropdownValue;

    String transactionTypeDropdownValue = 'New';
    transactionTypeController.text = transactionTypeDropdownValue;

    String amountReceivedDropdownValue = 'Yes';
    amountReceivedController.text = amountReceivedDropdownValue;

    var items = ['Normal', 'Aged', 'Disabled'];
    var sessionItems = [
      'Baisakh-Jestha-Asar',
      'Shrawan-Bhadra-Ashwin',
      'Kartik-Mangsir-Poush',
      'Magh-Falgun-Chaitra'
    ];
    var transactionTypeItems = ['New', 'Renew'];
    var amountReceivedItems = ['Yes', 'No'];
    List<String> getYears(int year) {
      int currentYear = NepaliDateTime.now().year;

      List<String> yearsTillPresent = [];

      while (year <= currentYear + 10) {
        yearsTillPresent.add(year.toString());
        year++;
      }

      return yearsTillPresent;
    }

    var yearsList = getYears(2075);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Insured Tracker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Family Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: familyHeadController,
                  decoration: InputDecoration(
                      label: const Text('Family Head'),
                      hintText: 'Name of Head of the Family',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: membershipNoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: const Text('Membership No.'),
                      hintText: 'Membership No.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: phoneNoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: const Text('Phone No.'),
                      hintText: 'Phone No.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: noOfMembersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: const Text('No. of members'),
                      hintText: 'No. of members',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: annualFeeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: const Text('Annual Fee'),
                      hintText: 'Annual Fee',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        label: const Text('Family Type'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                    value: familyTypeDropdownValue,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        familyTypeDropdownValue = newValue!;
                        familyTypeController.text = newValue;
                      });
                    })),
            const Text(
              'Transaction Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        label: const Text('Transaction type'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                    value: transactionTypeDropdownValue,
                    items: transactionTypeItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        transactionTypeDropdownValue = newValue!;
                        transactionTypeController.text = newValue;
                      });
                    })),
            Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        label: const Text('Year'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                    value: yearsDropdownValue,
                    items: yearsList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        yearsDropdownValue = newValue!;
                        yearController.text = newValue;
                      });
                    })),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      label: const Text('Session'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  value: sessionDropdownValue,
                  items: sessionItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      sessionDropdownValue = newValue!;
                      sessionController.text = newValue;
                    });
                  }),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: receiptNoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: const Text('Receipt No.'),
                      hintText: 'Receipt No.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      label: const Text('Amount Received?'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  value: amountReceivedDropdownValue,
                  items: amountReceivedItems.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      amountReceivedDropdownValue = newValue!;
                      amountReceivedController.text = newValue;
                    });
                  }),
            ),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.only(
                      left: 50, top: 14, right: 50, bottom: 14),
                ),
                onPressed: () {
                  setState(() {
                    _save();
                  });
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  void _save() async {
    int result = (await helper.insertFamily(
        familyHeadController,
        membershipNoController,
        phoneNoController,
        noOfMembersController,
        annualFeeController,
        receiptNoController,
        familyTypeController,
        transactionTypeController,
        yearController,
        sessionController,
        amountReceivedController));
    if (result != 0) {
      _showAlertDialog('Status', "New family added successfully");
    } else {
      _showAlertDialog('Status', "Failed to add new family.");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(message));
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }

  Future<Database?> openDB() async {
    _database = await DatabaseHelper().openDB();
    return _database;
  }
}

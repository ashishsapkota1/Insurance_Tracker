import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hira/database_helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class Renew extends StatefulWidget {
  final String name;
  final String hiCode;
  final String amount;

  const Renew({super.key, required this.name, required this.hiCode, required this.amount});

  @override
  State<Renew> createState() => _RenewState();
}

class _RenewState extends State<Renew> {

  DatabaseHelper helper = DatabaseHelper();
  Database? _database;

  String sessionDropdownValue = '';
  String yearsDropdownValue = '';
  String amountReceivedDropdownValue = '';

  NepaliDateTime today = NepaliDateTime.now();

  TextEditingController receiptNoController = TextEditingController();
  TextEditingController yearController = TextEditingController(text: NepaliDateTime.now().year.toString());
  TextEditingController sessionController = TextEditingController();
  TextEditingController amountReceivedController = TextEditingController(text: "Yes");

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    receiptNoController.dispose();
    yearController.dispose();
    sessionController.dispose();
    amountReceivedController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    NepaliDateTime firstSession = NepaliDateTime(today.year, 1, 1);
    NepaliDateTime secondSession = NepaliDateTime(today.year, 4, 1);
    NepaliDateTime thirdSession = NepaliDateTime(today.year, 7, 1);
    NepaliDateTime forthSession = NepaliDateTime(today.year, 10, 1);
    if (today.isAfter(firstSession) && today.isBefore(secondSession)) {
      sessionDropdownValue = 'Baishakh-Jestha-Ashadh';
      sessionController.text = 'Baishakh-Jestha-Ashadh';
    } else if (today.isAfter(secondSession) && today.isBefore(thirdSession)) {
      sessionDropdownValue = 'Shrawan-Bhadra-Ashwin';
      sessionController.text = 'Shrawan-Bhadra-Ashwin';
    } else if (today.isAfter(thirdSession) && today.isBefore(forthSession)) {
      sessionDropdownValue = 'Kartik-Mangsir-Poush';
      sessionController.text = 'Kartik-Mangsir-Poush';
    } else {
      sessionDropdownValue = 'Magh-Falgun-Chaitra';
      sessionController.text = 'Magh-Falgun-Chaitra';
    }
    yearsDropdownValue = NepaliDateTime.now().year.toString();
    amountReceivedDropdownValue = 'Yes';
  }

  @override
  Widget build(BuildContext context) {
    var sessionItems = [
      'Baishakh-Jestha-Ashadh',
      'Shrawan-Bhadra-Ashwin',
      'Kartik-Mangsir-Poush',
      'Magh-Falgun-Chaitra'
    ];
    var amountReceivedItems = ['Yes', 'No'];
    List<String> getYears(int year) {
      int currentYear = NepaliDateTime.now().year;

      List<String> yearsTillPresent = [];

      while (year <= currentYear + 1) {
        yearsTillPresent.add(year.toString());
        year++;
      }

      return yearsTillPresent;
    }

    var yearsList = getYears(2075);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Renew Insurance'),
        backgroundColor: const Color(0xFF1a457c),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    readOnly: true,
                    initialValue: widget.name,
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
                    initialValue: widget.hiCode,
                    readOnly: true,
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
                    initialValue: widget.amount,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        label: const Text('Annual Fee'),
                        hintText: 'Annual Fee',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  )),
              const Text(
                'Transaction Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          label: const Text('Year'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      value: yearsDropdownValue,
                      items: yearsList.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
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
                    items: sessionItems.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
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
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please select an item';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        label: const Text('Amount Received?'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                    value: amountReceivedDropdownValue,
                    items: amountReceivedItems.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
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
                    backgroundColor: const Color(0xFF1a457c),
                    padding: const EdgeInsets.only(
                        left: 50, top: 14, right: 50, bottom: 14),
                  ),
                  onPressed: () {
                    setState(() {
                      if(_formKey.currentState!.validate()){
                        _save();
                      }

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
      ),
    );
  }

  void _save() async {
    int result = (await helper.renewInsurance(
        widget.hiCode,
        widget.amount,
        receiptNoController,
        yearController,
        sessionController,
        amountReceivedController));
    if (result != 0) {
      _showAlertDialog('Status', "Insurance renewed successfully.");
      receiptNoController.clear();
      yearController.clear();
      sessionController.clear();
      amountReceivedController.clear();
    } else {
      _showAlertDialog('Status', "Failed to renew insurance.");
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

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
  DatabaseHelper helper = DatabaseHelper();
  Database? _database;

  String sessionDropdownValue = '';
  String familyTypeDropdownValue = '';
  String yearsDropdownValue = '';
  String transactionTypeDropdownValue = '';
  String amountReceivedDropdownValue = '';

  NepaliDateTime today = NepaliDateTime.now();

  TextEditingController familyHeadController = TextEditingController();
  TextEditingController membershipNoController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noOfMembersController = TextEditingController();
  TextEditingController annualFeeController = TextEditingController();
  TextEditingController receiptNoController = TextEditingController();
  TextEditingController familyTypeController = TextEditingController(text: "General");
  TextEditingController transactionTypeController = TextEditingController(text: "New");
  TextEditingController yearController = TextEditingController(text: NepaliDateTime.now().year.toString());
  TextEditingController sessionController = TextEditingController();
  TextEditingController amountReceivedController = TextEditingController(text: "Yes");

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    membershipNoController.dispose();
    phoneNoController.dispose();
    noOfMembersController.dispose();
    annualFeeController.dispose();
    receiptNoController.dispose();
    familyTypeController.dispose();
    transactionTypeController.dispose();
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
      sessionDropdownValue = 'बैशाख-जेठ-असार';
      sessionController.text = 'बैशाख-जेठ-असार';
    } else if (today.isAfter(secondSession) && today.isBefore(thirdSession)) {
      sessionDropdownValue = 'साउन-भदौ-असोज';
      sessionController.text = 'साउन-भदौ-असोज';
    } else if (today.isAfter(thirdSession) && today.isBefore(forthSession)) {
      sessionDropdownValue = 'कार्तिक-मंसिर-पुष';
      sessionController.text = 'कार्तिक-मंसिर-पुष';
    } else {
      sessionDropdownValue = 'माघ-फागुन-चैत';
      sessionController.text = 'माघ-फागुन-चैत';
    }
    familyTypeDropdownValue = 'General';
    yearsDropdownValue = NepaliDateTime.now().year.toString();
    transactionTypeDropdownValue = 'New';
    amountReceivedDropdownValue = 'Yes';
  }



  @override
  Widget build(BuildContext context) {
    var items = ['General', 'Aged', 'Disabled'];
    var sessionItems = [
      'बैशाख-जेठ-असार',
      'साउन-भदौ-असोज',
      'कार्तिक-मंसिर-पुष',
      'माघ-फागुन-चैत'
    ];
    var transactionTypeItems = ['New', 'Renew'];
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
        title: const Text('नयाँ परिवार दर्ता'),
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
                  'परिवारको विवरण',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return 'Please enter Name';
                      }
                      return null;
                    },
                    controller: familyHeadController,
                    decoration: InputDecoration(
                        label: const Text('घरमूलीको नाम'),
                        hintText: 'घरमूलीको नाम',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter HICODE';
                      }else if(value.length<9 || value.length>9){
                        return 'Must be exactly 9 digits';
                      }
                      return null;
                    },
                    controller: membershipNoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        label: const Text('सदस्यता नं.'),
                        hintText: 'सदस्यता नं.',
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
                        label: const Text('सम्पर्क नं.'),
                        hintText: 'सम्पर्क नं.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        label: const Text('ठेगाना'),
                        hintText: 'ठेगाना',
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
                        label: const Text('सदस्यको संख्या'),
                        hintText: 'सदस्यको संख्या',
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
                        label: const Text('योगदान रकम'),
                        hintText: 'योगदान रकम',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          label: const Text('प्रकार'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      value: familyTypeDropdownValue,
                      items: items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          familyTypeDropdownValue = newValue!;
                          familyTypeController.text = newValue;
                        });
                      })),
              const Text(
                'दर्ता विवरण',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          label: const Text('नयाँ/नविकरण'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      value: transactionTypeDropdownValue,
                      items: transactionTypeItems.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
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
                          label: const Text('वर्ष'),
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
                        label: const Text('चरण'),
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
                        label: const Text('रसिद नं.'),
                        hintText: 'रसिद नं.',
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
                        label: const Text('रकम भुक्तानि'),
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
                    backgroundColor: Colors.blue,
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
    int result = (await helper.insertFamily(
        familyHeadController,
        membershipNoController,
        phoneNoController,
        addressController,
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
      familyHeadController.clear();
      membershipNoController.clear();
      phoneNoController.clear();
      addressController.clear();
      noOfMembersController.clear();
      annualFeeController.clear();
      receiptNoController.clear();
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

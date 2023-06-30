import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hira/database_helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class EditFamily extends StatefulWidget {
  final int hiCode;

  const EditFamily({super.key, required this.hiCode});

  @override
  State<EditFamily> createState() => _EditFamilyState();
}

class _EditFamilyState extends State<EditFamily> {
  Map<String, dynamic> familyData = {};
  DatabaseHelper helper = DatabaseHelper();
  Database? _database;

  String sessionDropdownValue = '';
  String familyTypeDropdownValue = '';
  String yearsDropdownValue = '';

  NepaliDateTime today = NepaliDateTime.now();

  TextEditingController familyHeadController = TextEditingController();
  TextEditingController membershipNoController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noOfMembersController = TextEditingController();
  TextEditingController annualFeeController = TextEditingController();
  TextEditingController familyTypeController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController sessionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    membershipNoController.dispose();
    phoneNoController.dispose();
    noOfMembersController.dispose();
    annualFeeController.dispose();
    familyTypeController.dispose();
    yearController.dispose();
    sessionController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    fetchFamilyData(widget.hiCode);
  }

  Future<void> fetchFamilyData(int hiCode) async {
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getOneFamily(hiCode);
    setState(() {
      familyData = data;
    });
    initializeFields();
  }

  void initializeFields(){
    familyHeadController.text = familyData['family']['name'];
    membershipNoController.text = familyData['family']['hiCode'];
    phoneNoController.text = familyData['family']['phnNo'];
    noOfMembersController.text = familyData['family']['membersNo'];
    annualFeeController.text = familyData['family']['annualFee'];
    // familyTypeController.text = familyData['family']['type'];
    // familyTypeDropdownValue = familyData['family']['type'];
    // yearController.text = familyData['family']['lastRenewalYear'];
    // yearsDropdownValue = familyData['family']['lastRenewalYear'];
    // sessionController.text = familyData['family']['lastRenewalSession'];
    // sessionDropdownValue = familyData['family']['lastRenewalSession'];
    addressController.text = familyData['family']['address'];
  }

  @override
  Widget build(BuildContext context) {
    var items = ['Normal', 'Aged', 'Disabled'];
    var sessionItems = [
      'Baishakh-Jestha-Ashadh',
      'Shrawan-Bhadra-Ashwin',
      'Kartik-Mangsir-Poush',
      'Magh-Falgun-Chaitra'
    ];
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
        title: const Text('Edit Family'),
        backgroundColor: const Color(0xFF1a457c),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                        label: const Text('Family Head'),
                        hintText: 'Name of Head of the Family',
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
                    readOnly: true,
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
                    controller: addressController,
                    decoration: InputDecoration(
                        label: const Text('Address'),
                        hintText: 'Address',
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
                      value: 'Normal',
                      items: items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          // familyTypeDropdownValue = newValue!;
                          // familyTypeController.text = newValue;
                        });
                      })),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          label: const Text('Last Renewed Year'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      value: '2080',
                      items: yearsList.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          // yearsDropdownValue = newValue!;
                          // yearController.text = newValue;
                        });
                      })),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        label: const Text('Session'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                    value: 'Baishakh-Jestha-Ashadh',
                    items: sessionItems.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        // sessionDropdownValue = newValue!;
                        // sessionController.text = newValue;
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
                    'Update',
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
    // int result = (await helper.insertFamily(
    //     familyHeadController,
    //     membershipNoController,
    //     phoneNoController,
    //     addressController,
    //     noOfMembersController,
    //     annualFeeController,
    //     receiptNoController,
    //     familyTypeController,
    //     transactionTypeController,
    //     yearController,
    //     sessionController,
    //     amountReceivedController));
    // if (result != 0) {
    //   _showAlertDialog('Status', "New family added successfully");
    //   familyHeadController.clear();
    //   membershipNoController.clear();
    //   phoneNoController.clear();
    //   addressController.clear();
    //   noOfMembersController.clear();
    //   annualFeeController.clear();
    //   receiptNoController.clear();
    // } else {
    //   _showAlertDialog('Status', "Failed to add new family.");
    // }
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

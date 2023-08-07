import 'package:flutter/material.dart';
import 'package:hira/screens/family_details.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hira/database_helper/database_helper.dart';

class EditRenewal extends StatefulWidget {
  final String id;

  const EditRenewal({super.key, required this.id});

  @override
  State<EditRenewal> createState() => _EditRenewalState();
}

class _EditRenewalState extends State<EditRenewal> {
  Map<String, dynamic> renewalData = {};
  DatabaseHelper helper = DatabaseHelper();

  String sessionDropdownValue = '';
  String yearsDropdownValue = '';
  String transactionTypeDropdownValue = '';
  String amountReceivedDropdownValue = '';

  NepaliDateTime today = NepaliDateTime.now();

  TextEditingController membershipNoController = TextEditingController();
  TextEditingController annualFeeController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController sessionController = TextEditingController();
  TextEditingController receiptNoController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController amountReceivedController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    membershipNoController.dispose();
    annualFeeController.dispose();
    yearController.dispose();
    sessionController.dispose();
    receiptNoController.dispose();
    remarksController.dispose();
    transactionTypeController.dispose();
    amountReceivedController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    fetchRenewalData(widget.id);
  }

  Future<void> fetchRenewalData(String id) async {
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getOneRenewal(id);
    setState(() {
      renewalData = data;
    });
    initializeFields();
  }

  void initializeFields(){
    membershipNoController.text = renewalData['family'].toString();
    annualFeeController.text = renewalData['amount'].toString();
    yearController.text = renewalData['year'].toString();
    yearsDropdownValue = renewalData['year'].toString();
    sessionController.text = renewalData['session'].toString();
    sessionDropdownValue = renewalData['session'].toString();
    receiptNoController.text = renewalData['receiptNo'].toString();
    remarksController.text = renewalData['remarks'].toString();
    transactionTypeDropdownValue = renewalData['transactionType'].toString();
    transactionTypeController.text = renewalData['transactionType'].toString();
    amountReceivedDropdownValue = renewalData['isAmountReceived'].toString();
    amountReceivedController.text = renewalData['isAmountReceived'].toString();
  }

  @override
  Widget build(BuildContext context) {
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

    if (renewalData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('नविकरण सम्पादन'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: renewalData['family'].toString())),
                );
              }
          ),
          centerTitle: true,
          title: const Text('नविकरण सम्पादन'),
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
                          label: const Text('सदस्यता नं.'),
                          hintText: 'सदस्यता नं.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    )),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            label: const Text('नविकरण वर्ष'),
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
                          label: const Text('नविकरण चरण'),
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
                    child: TextFormField(
                      controller: remarksController,
                      decoration: InputDecoration(
                          label: const Text('कैफियत'),
                          hintText: 'अपाङ्ग(ख)/विपन्न/म.स्वा.स्व.स.',
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
                      'सम्पादन गर्नुहोस्',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      );
    }
  }

  void _save() async {
    int result = (await helper.updateRenewal(
        widget.id,
        membershipNoController,
        annualFeeController,
        yearController,
        sessionController,
        amountReceivedController,
        transactionTypeController,
        receiptNoController,
        remarksController));
    if (result != 0) {
      _showAlertDialog('Status', "Renewal Updated Successfully.");
      fetchRenewalData(widget.id);
    } else {
      _showAlertDialog('Status', "Failed to update renewal.");
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
}

import 'package:flutter/material.dart';
import 'package:hira/screens/family_details.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hira/database_helper/database_helper.dart';

class EditFamily extends StatefulWidget {
  final String hiCode;

  const EditFamily({super.key, required this.hiCode});

  @override
  State<EditFamily> createState() => _EditFamilyState();
}

class _EditFamilyState extends State<EditFamily> {
  Map<String, dynamic> familyData = {};
  DatabaseHelper helper = DatabaseHelper();

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

  Future<void> fetchFamilyData(String hiCode) async {
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getOneFamily(hiCode);
    setState(() {
      familyData = data;
    });
    initializeFields();
  }

  void initializeFields(){
    familyHeadController.text = familyData['family']['name'].toString();
    membershipNoController.text = familyData['family']['hiCode'].toString();
    phoneNoController.text = familyData['family']['phnNo'].toString();
    noOfMembersController.text = familyData['family']['membersNo'].toString();
    annualFeeController.text = familyData['family']['annualFee'].toString();
    familyTypeController.text = familyData['family']['type'].toString();
    familyTypeDropdownValue = familyData['family']['type'].toString();
    yearController.text = familyData['family']['lastRenewalYear'].toString();
    yearsDropdownValue = familyData['family']['lastRenewalYear'].toString();
    sessionController.text = familyData['family']['lastRenewalSession'].toString();
    sessionDropdownValue = familyData['family']['lastRenewalSession'].toString();
    addressController.text = familyData['family']['address'].toString();
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

    if (familyData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('परिवार सम्पादन'),
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
                MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: widget.hiCode)),
              );
            }
          ),
          centerTitle: true,
          title: const Text('परिवार सम्पादन'),
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
                          label: const Text('सदस्य संख्या'),
                          hintText: 'सदस्य संख्या',
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
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            label: const Text('अन्तिम नविकरण वर्ष'),
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
    int result = (await helper.updateFamily(
        familyData['family']['id'].toString(),
        familyHeadController,
        membershipNoController,
        phoneNoController,
        addressController,
        noOfMembersController,
        annualFeeController,
        familyTypeController,
        yearController,
        sessionController));
    if (result != 0) {
      _showAlertDialog('Status', "Family Updated Successfully.");

      fetchFamilyData(widget.hiCode);
    } else {
      _showAlertDialog('Status', "Failed to update family.");
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

import 'package:flutter/material.dart';
import 'package:hira/screens/family_details.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database_helper/database_helper.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hira/screens/renew.dart';
import '../database_helper/mobile.dart';

class ThisSessionPage extends StatefulWidget {
  const ThisSessionPage({Key? key}) : super(key: key);

  @override
  State<ThisSessionPage> createState() => _ThisSessionPageState();
}

class _ThisSessionPageState extends State<ThisSessionPage> {
  Map<String, dynamic> familyData = {};
  String sessionDropdownValue = '';
  int yearsDropdownValue = 0;

  @override
  void initState() {
    super.initState();
    NepaliDateTime today = NepaliDateTime.now();
    NepaliDateTime firstSession = NepaliDateTime(today.year, 1, 1);
    NepaliDateTime secondSession = NepaliDateTime(today.year, 4, 1);
    NepaliDateTime thirdSession = NepaliDateTime(today.year, 7, 1);
    NepaliDateTime forthSession = NepaliDateTime(today.year, 10, 1);

    if (today.isAfter(firstSession) && today.isBefore(secondSession)) {
      sessionDropdownValue = 'बैशाख-जेठ-असार';
    } else if (today.isAfter(secondSession) && today.isBefore(thirdSession)) {
      sessionDropdownValue = 'साउन-भदौ-असोज';
    } else if (today.isAfter(thirdSession) && today.isBefore(forthSession)) {
      sessionDropdownValue = 'कार्तिक-मंसिर-पुष';
    } else {
      sessionDropdownValue = 'माघ-फागुन-चैत';
    }
    yearsDropdownValue = NepaliDateTime.now().year;
    fetchFamilyData(yearsDropdownValue, sessionDropdownValue);
  }

  Future<void> fetchFamilyData(int year, String session) async {
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getThisSessionData(year, session);
    setState(() {
      familyData = data;
    });
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
    AlertDialog(title: Text(title), content: Text(message));
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      await launchUrl(url);
    } catch(_){
      _showAlertDialog('Error', "Could not launch phone");
    }
  }

  Future<void> createExcel() async {
    final excelHelper = ExcelHelper();
    String path = await excelHelper.createExcel(yearsDropdownValue, sessionDropdownValue, familyData);
    _showAlertDialog('Success', 'Report saved at $path');
  }

  @override
  Widget build(BuildContext context) {

    var sessionItems = [
      'बैशाख-जेठ-असार',
      'साउन-भदौ-असोज',
      'कार्तिक-मंसिर-पुष',
      'माघ-फागुन-चैत'
    ];

    List<int> getYears(int year) {
      int currentYear = NepaliDateTime.now().year;

      List<int> yearsTillPresent = [];

      while (year <= currentYear + 1) {
        yearsTillPresent.add(year);
        year++;
      }

      return yearsTillPresent;
    }
    // int yearsDropdownValue = NepaliDateTime.now().year;
    List<int> yearsList = getYears(NepaliDateTime.now().year - 1);

    if (familyData.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                    label: const Text('Year'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                value: yearsDropdownValue,
                items: yearsList.map((int items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    yearsDropdownValue = newValue!;
                    fetchFamilyData(yearsDropdownValue, sessionDropdownValue);
                  });
                }),
          ),
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
                    fetchFamilyData(yearsDropdownValue, sessionDropdownValue);
                  });
                }),
          ),
          const Center(
            child: Text('No families found'),
          ),
        ],
      );
    } else {
      final List<dynamic> toBeRenewed = familyData['toBeRenewed'];
      final List<dynamic> newGeneral = familyData['newGeneral'];
      final List<dynamic> renewGeneral = familyData['renewGeneral'];
      final List<dynamic> newAged = familyData['newAged'];
      final List<dynamic> newDisabled = familyData['newDisabled'];
      final List<dynamic> renewDisabled = familyData['renewDisabled'];
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      label: const Text('Year'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  value: yearsDropdownValue,
                  items: yearsList.map((int items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      yearsDropdownValue = newValue!;
                      fetchFamilyData(yearsDropdownValue, sessionDropdownValue);
                    });
                  }),
            ),
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
                      fetchFamilyData(yearsDropdownValue, sessionDropdownValue);
                      });
                  }),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5dbea3)),
                    ),
                    onPressed: (){
                      createExcel();
                    },
                    child: const Text('Generate Report')
                ),
              ),
            ),
            const Text(
              'नविकरण गर्न बाँकि',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
            padding: const EdgeInsets.only(left:8, right:8, bottom: 20.0),
            child: SafeArea(
              bottom: true,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: toBeRenewed.length,
                itemBuilder: (context, index) {
                  final family = toBeRenewed[index];
                  final id = family['id'];
                  final name = family['name'];
                  final hiCode = family['hiCode'];
                  final phoneNo = family['phnNo'];
                  final amount = family['annualFee'];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: hiCode.toString())),
                        );
                      },
                      contentPadding:const EdgeInsets.all(8),
                      title: Text('$name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$hiCode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                          Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Contact: $phoneNo'),
                                      Text('Amount: $amount')
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF1a457c))
                                              ),
                                              onPressed: (){
                                                final Uri uri = Uri(
                                                  scheme: 'tel',
                                                  path: '+977$phoneNo',
                                                );
                                                _launchUrl(uri);
                                              },
                                              child: const Text('Call')
                                          ),
                                          const SizedBox(width: 8,),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5dbea3))
                                              ),
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => Renew(id: id.toString(), name: name, hiCode: hiCode.toString(), amount: amount)),
                                                );
                                              },
                                              child: const Text('Renew')
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              )
                            ),
                          ],
                        ),
                        // Add more fields as needed
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text(
              'साधारण परिवार - नयाँ दर्ता',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8, right:8, bottom: 20.0),
              child: SafeArea(
                bottom: true,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: newGeneral.length,
                  itemBuilder: (context, index) {
                    final family = newGeneral[index];
                    final name = family['name'];
                    final hiCode = family['hiCode'];
                    final amount = family['annualFee'];
                    final isAmountReceived = family['isAmountReceived'];
                    final receiptNo = family['receiptNo'];
                    final String dateOfTransaction = family['dateOfTransaction'].toString().split(' ')[0];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: hiCode.toString())),
                          );
                        },
                        contentPadding:const EdgeInsets.all(8),
                        title: Text('$name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$hiCode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('रकम: $amount'),
                                        Text('रसिद नं.: $receiptNo')
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('मिति: $dateOfTransaction'),
                                        Row(
                                          children: [
                                            const Text('रकम भुक्तानि?'),
                                            if (isAmountReceived.toString() == 'Yes')
                                              Image.asset('assets/tick.png', width: 30, height: 30),
                                            if (isAmountReceived.toString() == 'No')
                                              Image.asset('assets/cross.png', width: 30, height: 30),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        // Add more fields as needed
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text(
              'साधारण परिवार - नविकरण',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8, right:8, bottom: 20.0),
              child: SafeArea(
                bottom: true,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: renewGeneral.length,
                  itemBuilder: (context, index) {
                    final family = renewGeneral[index];
                    final name = family['name'];
                    final hiCode = family['hiCode'];
                    final amount = family['annualFee'];
                    final isAmountReceived = family['isAmountReceived'];
                    final receiptNo = family['receiptNo'];
                    final String dateOfTransaction = family['dateOfTransaction'].toString().split(' ')[0];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: hiCode.toString())),
                          );
                        },
                        contentPadding:const EdgeInsets.all(8),
                        title: Text('$name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$hiCode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('रकम: $amount'),
                                        Text('रसिद नं.: $receiptNo')
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('मिति: $dateOfTransaction'),
                                        Row(
                                          children: [
                                            const Text('रकम भुक्तानि?'),
                                            if (isAmountReceived.toString() == 'Yes')
                                              Image.asset('assets/tick.png', width: 30, height: 30),
                                            if (isAmountReceived.toString() == 'No')
                                              Image.asset('assets/cross.png', width: 30, height: 30),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        // Add more fields as needed
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text(
              'जेष्ठ नागरिक - नयाँ दर्ता',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8, right:8, bottom: 20.0),
              child: SafeArea(
                bottom: true,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: newAged.length,
                  itemBuilder: (context, index) {
                    final family = newAged[index];
                    final name = family['name'];
                    final hiCode = family['hiCode'];
                    final amount = family['annualFee'];
                    final isAmountReceived = family['isAmountReceived'];
                    final receiptNo = family['receiptNo'];
                    final String dateOfTransaction = family['dateOfTransaction'].toString().split(' ')[0];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: hiCode.toString())),
                          );
                        },
                        contentPadding:const EdgeInsets.all(8),
                        title: Text('$name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$hiCode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('रकम: $amount'),
                                        Text('रसिद नं.: $receiptNo')
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('मिति: $dateOfTransaction'),
                                        Row(
                                          children: [
                                            const Text('रकम भुक्तानि?'),
                                            if (isAmountReceived.toString() == 'Yes')
                                              Image.asset('assets/tick.png', width: 30, height: 30),
                                            if (isAmountReceived.toString() == 'No')
                                              Image.asset('assets/cross.png', width: 30, height: 30),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        // Add more fields as needed
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text(
              'अशक्त परिवार - नयाँ दर्ता',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8, right:8, bottom: 20.0),
              child: SafeArea(
                bottom: true,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: newDisabled.length,
                  itemBuilder: (context, index) {
                    final family = newDisabled[index];
                    final name = family['name'];
                    final hiCode = family['hiCode'];
                    final amount = family['annualFee'];
                    final isAmountReceived = family['isAmountReceived'];
                    final receiptNo = family['receiptNo'];
                    final String dateOfTransaction = family['dateOfTransaction'].toString().split(' ')[0];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: hiCode.toString())),
                          );
                        },
                        contentPadding:const EdgeInsets.all(8),
                        title: Text('$name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$hiCode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('रकम: $amount'),
                                        Text('रसिद नं.: $receiptNo')
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('मिति: $dateOfTransaction'),
                                        Row(
                                          children: [
                                            const Text('रकम भुक्तानि?'),
                                            if (isAmountReceived.toString() == 'Yes')
                                              Image.asset('assets/tick.png', width: 30, height: 30),
                                            if (isAmountReceived.toString() == 'No')
                                              Image.asset('assets/cross.png', width: 30, height: 30),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        // Add more fields as needed
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text(
              'अशक्त परिवार - नविकरण',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8, right:8, bottom: 100.0),
              child: SafeArea(
                bottom: true,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: renewDisabled.length,
                  itemBuilder: (context, index) {
                    final family = renewDisabled[index];
                    final name = family['name'];
                    final hiCode = family['hiCode'];
                    final amount = family['annualFee'];
                    final isAmountReceived = family['isAmountReceived'];
                    final receiptNo = family['receiptNo'];
                    final String dateOfTransaction = family['dateOfTransaction'].toString().split(' ')[0];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: hiCode.toString())),
                          );
                        },
                        contentPadding:const EdgeInsets.all(8),
                        title: Text('$name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$hiCode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('रकम: $amount'),
                                        Text('रसिद नं.: $receiptNo')
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('मिति: $dateOfTransaction'),
                                        Row(
                                          children: [
                                            const Text('रकम भुक्तानि?'),
                                            if (isAmountReceived.toString() == 'Yes')
                                              Image.asset('assets/tick.png', width: 30, height: 30),
                                            if (isAmountReceived.toString() == 'No')
                                              Image.asset('assets/cross.png', width: 30, height: 30),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        // Add more fields as needed
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

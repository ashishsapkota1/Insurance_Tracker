import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database_helper/database_helper.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:hira/screens/renew.dart';

class ThisSessionPage extends StatefulWidget {
  const ThisSessionPage({Key? key}) : super(key: key);

  @override
  State<ThisSessionPage> createState() => _ThisSessionPageState();
}

class _ThisSessionPageState extends State<ThisSessionPage> {
  List<Map<String, dynamic>> familyData = [];
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
      sessionDropdownValue = 'Baishakh-Jestha-Ashadh';
    } else if (today.isAfter(secondSession) && today.isBefore(thirdSession)) {
      sessionDropdownValue = 'Shrawan-Bhadra-Ashwin';
    } else if (today.isAfter(thirdSession) && today.isBefore(forthSession)) {
      sessionDropdownValue = 'Kartik-Mangsir-Poush';
    } else {
      sessionDropdownValue = 'Magh-Falgun-Chaitra';
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

  @override
  Widget build(BuildContext context) {

    var sessionItems = [
      'Baishakh-Jestha-Ashadh',
      'Shrawan-Bhadra-Ashwin',
      'Kartik-Mangsir-Poush',
      'Magh-Falgun-Chaitra'
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
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: SafeArea(
                    bottom: true,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: familyData.length,
                      itemBuilder: (context, index) {
                        final family = familyData[index];
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
                                                    onPressed: (){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => Renew(name: name.toString(), hiCode: hiCode.toString(), amount: amount.toString())),
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
              

          ],
        ),
      );
    }
  }
}

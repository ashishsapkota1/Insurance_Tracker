import 'package:flutter/material.dart';
import 'package:hira/screens/renew.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database_helper/database_helper.dart';
import 'package:nepali_utils/nepali_utils.dart';

class LapsedPage extends StatefulWidget {
  const LapsedPage({Key? key}) : super(key: key);

  @override
  State<LapsedPage> createState() => _LapsedPageState();
}

class _LapsedPageState extends State<LapsedPage> {
  List<Map<String, dynamic>> familyData = [];

  @override
  void initState() {
    super.initState();
    fetchFamilyData();
  }

  Future<void> fetchFamilyData() async {
    NepaliDateTime today = NepaliDateTime.now();
    List<String> months = [
      'Baishakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra'
    ];
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getTableData();
    List<Map<String, dynamic>> lapsedFamily = [];
    for (var fam in data) {
      List<String> words = fam['lastRenewalSession'].toString().split("-");
      int monthNumber = months.indexOf(words[2])+1 == 12 ? 1 : months.indexOf(words[2])+2;
      NepaliDateTime lastRenewalDate = NepaliDateTime(
          fam['lastRenewalYear']+1,
          monthNumber,
          0
      );
      if (today.isAfter(lastRenewalDate)) {
        lapsedFamily.add(fam);
      }
    }
    setState(() {
      familyData = lapsedFamily;
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
    if (familyData.isEmpty) {
      return const Center(
            child: Text('No families found'),
          );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 60.0),
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
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5dbea3))
                                                ),
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

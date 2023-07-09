import 'package:flutter/material.dart';
import 'package:hira/screens/edit_family.dart';
import 'package:hira/screens/renew.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database_helper/database_helper.dart';

class FamilyDetailsPage extends StatefulWidget {
  final String hiCode;

  const FamilyDetailsPage({super.key, required this.hiCode});

  @override
  State<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends State<FamilyDetailsPage> {
  Map<String, dynamic> familyData = {};

  @override
  void initState() {
    super.initState();
    fetchFamilyData(int.tryParse(widget.hiCode)??0);
  }

  Future<void> fetchFamilyData(int hiCode) async {
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getOneFamily(hiCode);
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
    } catch (_) {
      _showAlertDialog('Error', "Could not launch phone");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (familyData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Family Details'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      final String name = familyData['family']['name'].toString().toUpperCase();
      final String memNo = familyData['family']['hiCode'].toString();
      final String famNo = familyData['family']['membersNo'].toString();
      final String annualFee = familyData['family']['annualFee'].toString();
      final String contact = familyData['family']['phnNo'].toString();
      final String type = familyData['family']['type'].toString();
      final String address = familyData['family']['address'].toString();
      final String renewalYear = familyData['family']['lastRenewalYear'].toString();
      final String renewalSession = familyData['family']['lastRenewalSession'].toString();
      final List<dynamic> transaction = familyData['transactions'];

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Family Details',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF1a457c),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF1a457c),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Membership No.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      memNo,
                                      style: const TextStyle(fontSize: 18, color: Colors.white),
                                    )
                                  ],
                                ),
                            ),
                            Expanded(
                              flex: 1,
                              child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'No. of members.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      famNo,
                                      style: const TextStyle(fontSize: 18, color: Colors.white),
                                    )
                                  ],
                                ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Contact',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          final Uri uri = Uri(
                                            scheme: 'tel',
                                            path: '+977$contact',
                                          );
                                          _launchUrl(uri);
                                        },
                                        child: Text(
                                          contact,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blue.shade300,
                                              decoration: TextDecoration.underline),
                                        ))
                                  ],
                                )
                            ),
                            Expanded(
                              flex: 1,
                              child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Type',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      type,
                                      style: const TextStyle(fontSize: 18, color: Colors.white),
                                    )
                                  ],
                                ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Address',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  address,
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Last Renewal',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  '$renewalYear-$renewalSession',
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5dbea3))
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Renew(name: name, hiCode: memNo, amount: annualFee)),
                                  );
                                },
                                child: const Text('Renew')
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade300)
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditFamily(hiCode: memNo)),
                                  );
                                },
                                child: const Text('Edit')
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                                ),
                                onPressed: (){

                                },
                                child: const Text('Delete')
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Text(
                'RENEWALS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: transaction.length,
                      itemBuilder: (context, index) {
                        final trans = transaction[index];
                        final String renewalYear = trans['year'].toString();
                        final String renewalSession = trans['session'].toString();
                        final String receiptNo = trans['receiptNo'].toString();
                        final String amount = trans['amount'].toString();
                        final String date = trans['dateOfTransaction'].toString();
                        final String transactionType = trans['transactionType'].toString();
                        final DateTime renewalDate = DateTime.parse(date);
                        final String onlyDate =
                            '${renewalDate.year.toString()}-${renewalDate.month.toString()}-${renewalDate.day.toString()}';
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              '$renewalYear-$renewalSession'.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child:
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Receipt No: $receiptNo'),
                                              Text('Date: $onlyDate'),
                                              Text('Amount: $amount')
                                            ],
                                          ),
                                    ),
                                    Expanded(
                                      child:
                                        Column (
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text('Amount Received?'),
                                                if (trans['isAmountReceived'] == 'Yes')
                                                  Image.asset('assets/tick.png', width: 30, height: 30),
                                                if (trans['isAmountReceived'] == 'No')
                                                  Image.asset('assets/cross.png', width: 30, height: 30),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                  decoration: BoxDecoration(
                                                    color: (transactionType == 'New' ?  const Color(0xFF5dbea3) : const Color(0xFF1a457c)),
                                                    borderRadius: BorderRadius.circular(8)
                                                  ),
                                                  child: Text(
                                                    transactionType,
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ),
      );
    }
  }
}


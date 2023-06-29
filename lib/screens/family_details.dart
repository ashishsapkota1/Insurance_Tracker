import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database_helper/database_helper.dart';
import '../database_helper/family.dart';

class FamilyDetailsPage extends StatefulWidget {
  final int hiCode;

  const FamilyDetailsPage({super.key, required this.hiCode});

  @override
  State<FamilyDetailsPage> createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends State<FamilyDetailsPage> {
  Map<String, dynamic> familyData = {};

  @override
  void initState() {
    super.initState();
    fetchFamilyData(widget.hiCode);
  }

  Future<void> fetchFamilyData(int hiCode) async {
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getOneFamily(hiCode);
    print(data);
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
      final String name = familyData['family']['name'].toString();
      final int memNo = familyData['family']['hiCode'];
      final int famNo = familyData['family']['membersNo'];
      final String contact = familyData['family']['phnNo'];
      final String type = familyData['family']['type'];
      final String address = familyData['family']['address'];
      final int renewalYear = familyData['family']['lastRenewalYear'];
      final String renewalSession = familyData['family']['lastRenewalSession'];
      final List<dynamic> transaction = familyData['transactions'];

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Details',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[200],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Membership No.',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                memNo.toString(),
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'No. of members.',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                famNo.toString(),
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Type',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                type,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
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
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
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
                                '$renewalYear-$renewalSession'.toString(),
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const Text(
                'Renewals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: transaction.length,
                      itemBuilder: (context, index) {
                        final transactions = transaction[index];
                        final int renewalYear = transactions['year'];
                        final String renewalSession = transactions['session'];
                        final String receiptNo = transactions['receiptNo'];
                        final String amount = transactions['amount'];
                        final String date = transactions['dateOfTransaction'];
                        final DateTime renewalDate = DateTime.parse(date);
                        final String onlyDate =
                            '${renewalDate.year.toString()}-${renewalDate.month.toString()}-${renewalDate.day.toString()}';
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              '$renewalYear-$renewalSession'.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Receipt No: $receiptNo'),
                                    Text('Amount: $amount')
                                  ],
                                ),
                                Row(
                                  children: [Text('Date: $onlyDate')],
                                ),
                                Row(
                                  children: [
                                    Text('Amount Received?'),
                                    if (transactions['isAmountReceived'] == 'Yes')
                                      Image.asset('assets/tick.png', width: 30, height: 30), // Display check SVG image
                                    if (transactions['isAmountReceived'] == 'No')
                                      Image.asset('assets/cross.png', width: 30, height: 30),
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

// {
//   family: {
//     hiCode: 453794964,
//     name: Sandesh Prasad Paudel,
//     phnNo: 9860702575,
//     membersNo: 3,
//     renewalSession: Baishakh-Jestha-Ashadh,
//     annualFee: 3500,
//     type: Normal,
//     lastRenewalYear: 2080,
//     lastRenewalSession: Baishakh-Jestha-Ashadh,
//     address: Beni, Myagdi
//   },
//   transactions: [
//     {
//       id: 3,
//       family: 453794964,
//       year: 2080,
//       session: Baishakh-Jestha-Ashadh,
//       amount: 3500,
//       dateOfTransaction: 2080-03-14 19:18:01.657672,
//       isAmountReceived: Yes,
//       transactionType: Renew,
//       receiptNo: 83263
//     }
//   ]
// }

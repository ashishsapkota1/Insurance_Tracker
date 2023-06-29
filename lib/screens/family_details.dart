import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database_helper/database_helper.dart';

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
    } catch(_){
      _showAlertDialog('Error', "Could not launch phone");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello'),
    );
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

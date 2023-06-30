import 'package:flutter/material.dart';
import 'package:hira/screens/family_details.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database_helper/database_helper.dart';

class AllFamilyPage extends StatefulWidget {
  const AllFamilyPage({Key? key}) : super(key: key);

  @override
  State<AllFamilyPage> createState() => _AllFamilyPageState();
}

class _AllFamilyPageState extends State<AllFamilyPage> {
  List<Map<String, dynamic>> familyData = [];

  @override
  void initState() {
    super.initState();
    fetchFamilyData();
  }

  Future<void> fetchFamilyData() async {
    final databaseHelper = DatabaseHelper();
    final data = await databaseHelper.getTableData();
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
    if (familyData.isEmpty) {
      return const Center(
        child: Text('No families found'),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 60.0),
        child: ListView.builder(
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
          child: SafeArea(
            bottom: true,
            child: ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: hiCode)),
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
                                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF1a457c))
                                    ),
                                    onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => FamilyDetailsPage(hiCode: hiCode)),
                                        );
                                    },
                                    child: const Text('Details')
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
          ),
        );
          },
        ),
      );
    }
  }
}

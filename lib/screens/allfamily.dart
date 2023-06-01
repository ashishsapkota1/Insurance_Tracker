import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    if (familyData.isEmpty) {
      return const Center(
        child: Text('No families found'),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: ListView.builder(
          itemCount: familyData.length,
          itemBuilder: (context, index) {
        final family = familyData[index];
        final name = family['name'];
        final hicode = family['hiCode'];
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
              contentPadding:const EdgeInsets.only(bottom: 12,left: 10),
              title: Text('Name : $name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HiCode: $hicode'),
                  Text('Phone No: $phoneNo'),
                  Text('Amount: $amount'),
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

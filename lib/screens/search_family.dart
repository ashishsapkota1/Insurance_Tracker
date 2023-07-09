import 'package:flutter/material.dart';
import 'package:hira/database_helper/database_helper.dart';

class SearchFamily extends StatefulWidget {
  const SearchFamily({Key? key}) : super(key: key);

  @override
  State<SearchFamily> createState() => _SearchFamilyState();
}

class _SearchFamilyState extends State<SearchFamily> {
  List<Map<String, dynamic>> familyData = [];
  List searchResult = [];

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
      searchResult = data;
    });
  }

  void searchFromList(String searchTerm){
    List searchedData = [];
    for (var fam in familyData) {
      String name = fam['name'];
      int hiCode = fam['hiCode'];
      if (name.toLowerCase().contains(searchTerm.toLowerCase()) || hiCode.toString().toLowerCase().contains(searchTerm.toLowerCase())){
        searchedData.add(fam);
      }
    }
    setState(() {
      searchResult = searchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search Family'),
        backgroundColor: const Color(0xFF1a457c),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Search here",
                ),
                onChanged: (query){
                  searchFromList(query);
                },
              ),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (context, index){
                  final family = searchResult[index];
                  final name = family['name'];
                  final hiCode = family['hiCode'];
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(hiCode.toString()),
                  );
                }
              )
          )
        ],
      )
    );
  }
}
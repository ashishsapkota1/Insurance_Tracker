import 'package:flutter/material.dart';

import '../database_helper/database_helper.dart';

List<Map<String, dynamic>> familyData = [];

Future<void> fetchFamilyData() async {
  final databaseHelper = DatabaseHelper();
  final data = await databaseHelper.getTableData();
  familyData = data;
}

class CustomSearchDelegate extends SearchDelegate {
  final DatabaseHelper databaseHelper;

  CustomSearchDelegate(this.databaseHelper);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: databaseHelper.searchData(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          final List<Map<String, dynamic>> searchData = snapshot.data!;
          return ListView.builder(
            itemCount: searchData.length,
            itemBuilder: (context, index) {
              final result = searchData[index];
              return ListTile(
                title: Text(result['name'].toString()),
                subtitle: Text(result['hiCode'].toString()),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: databaseHelper.searchData(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          final List<Map<String, dynamic>> searchData = snapshot.data!;
           return ListView.builder(
            itemCount: searchData.length,
            itemBuilder: (context, index) {
              final result = searchData[index];
              return ListTile(
                title: Text(result['name'].toString()),
                subtitle: Text(result['hiCode'].toString()),
              );
            },
          );

        }
      },
    );
  }
}

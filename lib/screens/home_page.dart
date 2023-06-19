import 'package:flutter/material.dart';
import 'package:hira/database_helper/database_helper.dart';
import 'package:hira/screens/add_new.dart';
import 'package:hira/screens/lapsed.dart';
import 'package:hira/screens/thisSession.dart';

import '../components/searchbar.dart';
import 'allfamily.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final databaseHelper = DatabaseHelper();
              showSearch(
                  context: context,
                  // delegate to customize the search bar
                  delegate: CustomSearchDelegate(databaseHelper)
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
        centerTitle: true,
        title: const Text('Insured Tracker'),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              ThisSessionPage(),
              AllFamilyPage(),
              LapsedPage(),
            ],
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.payment),
                  label: 'This session',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.family_restroom),
                  label: 'All family',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timelapse_rounded),
                  label: 'Lapsed',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 57.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddFamily()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}


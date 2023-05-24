import 'package:flutter/material.dart';
import 'package:hira/screens/add_new.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Insured Tracker'),
      ),
      body: Stack(children: [
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
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
        )
      ]),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 57.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddFamily()));
            },
            child: const Icon(Icons.add),
          ),
        ),
    );
  }
}

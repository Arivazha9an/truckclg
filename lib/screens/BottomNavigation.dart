
import 'package:flutter/services.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/screens/calenderslide.dart';
import 'package:truckclgproject/screens/piechartbackend.dart';
import 'IncomeExpense.dart';
import 'VehicleList.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const VehicleList(),
    const IncomeExpense(),
   Calenderslide(),
    MyPieChart()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); 

                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child:  
 Text('Yes'),
              ),
            ],
          ),
        );
        return false; // Prevent the app from navigating back
      },child:   Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  // color: grey,
                ),
                label: '',
                backgroundColor: lightorange),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  // color: grey,
                ),
                label: '',
                backgroundColor: lightorange),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month,
                  //color: grey,
                ),
                label: '',
                backgroundColor: lightorange),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.pie_chart,
                  // color: grey,
                ),
                label: '',
                backgroundColor: lightorange),
          ],
          selectedItemColor: Colors.amber[800],
        ),
      ),);
  
  }
}

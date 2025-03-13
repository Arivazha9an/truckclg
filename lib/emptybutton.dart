import 'package:flutter/material.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/screens/BottomNavigation.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Welcome'),
      centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: orange
              ),
              child: TextButton(onPressed: (){
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>BottomNavigationBarExampleApp()),
                );
                 
              }, child: const Text('Click Here',style: TextStyle(color: white),),
                        ),
            )
          )
        ],
      ),
    );
  }
}
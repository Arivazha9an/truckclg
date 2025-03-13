import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:truckclgproject/firebase_options.dart';
import 'package:truckclgproject/screens/BottomNavigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(     
         debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BottomNavigationBarExampleApp());
  }
}

//  cd C:\Users\Softnova\Downloads\scrcpy-win64-v2.7\scrcpy-win64-v2.7
//  scrcpy --always-on-top

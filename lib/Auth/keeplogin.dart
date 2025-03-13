
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:truckclgproject/Auth/login.dart';
import 'package:truckclgproject/screens/BottomNavigation.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading spinner while waiting
        } else if (snapshot.hasData) {
          return BottomNavigationBarExampleApp(); // User is logged in, show the next page
        } else {
          return Login(); // User is not logged in, show the login screen
        }
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:truckclgproject/Auth/signup.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/screens/BottomNavigation.dart';
import 'package:truckclgproject/widgets/custombutton.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  State<LoginMain> createState() => _LoginState();
}

class _LoginState extends State<LoginMain> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;
    final _formKey = GlobalKey<FormState>();
    var _emailcontroller = TextEditingController();
    var _passwordcontroller = TextEditingController();
    login() async {
      _formKey.currentState!.validate();

      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailcontroller.text,
                password: _passwordcontroller.text);
                  if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationBarExampleApp()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: 'User Not found',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: grey,
              textColor: black);
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: 'Wrong Password',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: grey,
              textColor: black);
          ;
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: w * 0.05),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                            color: orange,
                            fontSize: w * 0.075,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: w * 0.05, top: w * 0.035, bottom: w * 0.07),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Please Enter your Login Details',
                        style: TextStyle(color: grey, fontSize: w * 0.039),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    width: w * 0.92,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(-4, 4),
                          blurRadius: 18,
                          spreadRadius: 0,
                          color: Color(0x17000000),
                        )
                      ],
                    ),
                    child: TextFormField(
                      minLines: 1,
                      controller: _emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: black,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                      onTap: () {},
                      decoration: InputDecoration(
                          labelText: 'Email',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: orange),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(4),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    width: w * 0.92,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(-4, 4),
                          blurRadius: 18,
                          spreadRadius: 0,
                          color: Color(0x17000000),
                        )
                      ],
                    ),
                    child: TextFormField(
                      minLines: 1,
                      controller: _passwordcontroller,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Password must be atleast 6 character';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: black,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                      onTap: () {},
                      decoration: InputDecoration(
                          labelText: 'Password',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: orange),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(4),
                          )),
                    ),
                  ),
                ),

                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {},
                        child: const Text('Forget Password? '))),
                SizedBox(
                  height: w * 0.24,
                ),
                CustomTextButton(
                    title: 'Login',
                    width: 300,
                    background: orange,
                    textColor: white,
                    fontSize: 20,
                    onTap: login),
                SizedBox(
                  height: w * 0.025,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: w * 0.15),
                      child: const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16, color: grey),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, color: blue),
                        ))
                  ],
                )
                // TextField(

                //   decoration: InputDecoration(
                //     labelText:'Email / Phone Number',
                //     hintText:  'enter',
                //     focusColor: orange,
                //     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))

                //   ),
                // )
              ],
            ),
          ),
        ));
  }
}

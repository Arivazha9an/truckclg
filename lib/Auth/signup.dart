
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:truckclgproject/Auth/login.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  var _namecontroller = TextEditingController();
  var _mobilecontroller = TextEditingController();
  var _emailcontroller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  var _confirmpasswordcontroller = TextEditingController();
  final _firebase = FirebaseAuth.instance;

   _submit() async{
_formKey.currentState!.validate();
    
    _formKey.currentState!.save();
     try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _emailcontroller.text, password:_passwordcontroller.text);
    
      await FirebaseFirestore.instance
          .collection('Admin')
          .doc(userCredentials.user!.uid)
          .set({
        'name': _namecontroller.text,
        'email': _emailcontroller.text,
        'password': _passwordcontroller.text,
        'phone':_mobilecontroller.text
      });
      //  _firebase.createUserWithEmailAndPassword(
      //     email: _enteredEmail, password: _enteredPassword);
     

      print(userCredentials);
    }  on FirebaseAuthException catch (e) {
      return print(e.message);
    }
     return null;
  

  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                        color: black,
                        fontSize: w * 0.090,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(
                height: w * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: CustomTextFormField(
                  controller: _namecontroller,
                  labeltext: 'Full Name',
                  keyboardType: TextInputType.name,
                  hintText: '',
                  validate: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: CustomTextFormField(
                  controller: _mobilecontroller,
                  labeltext: 'Mobile Number',
                  keyboardType: TextInputType.number,
                  hintText: '',
                  validate: true,
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
              //password
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
                    controller: _confirmpasswordcontroller,
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Empty';
                      }
                      if (val != _passwordcontroller.text) {
                        return 'Password Not Matching';
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
                        labelText: 'Confirm Password',
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
              SizedBox(
                height: w * 0.15,
              ),
              CustomTextButton(
                  title: 'Sign Up',
                  width: 300,
                  background: orange,
                  textColor: white,
                  fontSize: 20,
                  onTap: _submit),
              SizedBox(
                height: w * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: w * 0.3,
                      child: const Divider(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: Text('OR'),
                    ),
                    Container(
                      width: w * 0.3,
                      child: const Divider(),
                    )
                  ],
                ),
              ),

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.15),
                    child: const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16, color: grey),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: blue),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

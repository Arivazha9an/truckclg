import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombuttom%20outlined.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart';


class BPermit extends StatefulWidget {
  const BPermit({super.key});

  @override
  State<BPermit> createState() => _PermitState();
}

class _PermitState extends State<BPermit> {

 final _formKey = GlobalKey<FormState>();

  final TextEditingController _datepickController = TextEditingController();
   var _permittypecontroller = TextEditingController();
  var _permitnocontroller = TextEditingController();
  var _expirycontroller = TextEditingController();
  var _issuecontroller = TextEditingController();
  var _permitcardcontroller = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  List<String> _items = []; // List to hold Firestore data
  String? _selectedItemvehicle; // Variable to hold the selected item
  @override
  void initState() {
    super.initState();
    _fetchItems(); // Fetch items when the widget is initialized
  }

  void clear() {
    _datepickController.clear();
    _permittypecontroller.clear();
    _permitnocontroller.clear();
   _expirycontroller.clear();
   _issuecontroller.clear();
    _permitcardcontroller.clear();
    _dropController.clear();
  }

  void showDropdownMenu() {
    FocusScope.of(context).requestFocus(FocusNode());
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: _items.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    ).then((newValue) {
      if (newValue != null) {
        setState(() {
          _selectedItemvehicle = newValue;
          _dropController.text = newValue;
        });
      }
    });
  }


  // Function to fetch data from Firestore
  Future<void> _fetchItems() async {
    try {
      // Fetch data from Firestore (replace 'collectionName' and 'fieldName' with your actual Firestore collection and field)
        QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bharathbenzvehicledetail')
          .get();

      // Extract data from documents and convert to a list of strings
      List<String> items =
          snapshot.docs.map((doc) => doc['vehicle Number'].toString()).toList();

      setState(() {
        _items = items; // Update the state with fetched items
      });
    } catch (e) {
      print('Error fetching data from Firestore: $e'); // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    void _saveData() async {
      if (_dropController.text.isEmpty &&
          _datepickController.text.isEmpty &&
         _permittypecontroller.text.isEmpty &&
          _permitnocontroller.text.isEmpty &&
          _expirycontroller.text.isEmpty &&
          _issuecontroller.text.isEmpty &&
          _permitcardcontroller.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill all fields.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      } else if(_formKey.currentState!.validate()) {
        try {
          await FirebaseFirestore.instance.collection('bharathbenzpermit').add({
            'vehiclenumber': _dropController.text,
            'date': _datepickController.text,
              'Permit Type': _permittypecontroller.text,
            'Permit Number': _permitnocontroller.text,
            'Expiry': _expirycontroller.text,
            'Issue': _issuecontroller.text,
            'Permit Card': _permitcardcontroller.text,
            'delDate': Timestamp.now(),
          });
          Fluttertoast.showToast(
            msg: "Successfully Stored.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // Navigate back to the previous page after a delay
          Future.delayed(
              const Duration(seconds: 2), () => Navigator.pop(context));
        } on FirebaseException catch (e) {
          // Handle Firebase errors
          print('Failed with error code: ${e.code}');
          print(e.message);
          // Optionally show an error dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to Store Data. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } catch (e) {
          // Handle any other errors
          print('Unexpected error: $e');
          // Optionally show an error dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('An unexpected error occurred. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
      else{
        return;
      }
    }

    Future<void> _selectDate() async {
      DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2099));
      if (picked != null) {
        setState(() {
          _datepickController.text = DateFormat('dd/MM/yyyy').format(picked);
        });
      }
    }

    var w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Permit Detail'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: orange, width: w * 0.005)),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Vehicle Number')),
                        ),
                        SizedBox(
                          width: 320,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              showDropdownMenu();
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _dropController,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a Value';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Select Vehicle No',
                                  suffixIcon: DropdownButton<String>(
                                    value: _selectedItemvehicle,
                                    hint: const Text('Select'),
                                    icon: const Icon(Icons.arrow_drop_down),
                                    items: _items.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedItemvehicle = newValue;
                                        _dropController.text = newValue ?? '';
                                      });
                                    },
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: orange),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: black),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: orange)),
                                ),
                              ),
                            ),
                          ),
                        ),


                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Date')),
                        ),
                      Container(
                          width: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(-4, 4),
                                blurRadius: 18,
                                spreadRadius: 0,
                                color: Color(0x17000000),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: _selectDate,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _datepickController,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a Date';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: orange),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  hintText: 'Choose Date',
                                  prefixIcon: const Icon(Icons.calendar_month),
                                ),
                              ),
                            ),
                          ),
                        ),
                       
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Permit Type')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _permittypecontroller,
                          hintText: ' ',
                          labeltext: '',
                          keyboardType: TextInputType.name,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Permit No')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _permitnocontroller,
                          hintText: ' ',
                          labeltext: '',
                          keyboardType: TextInputType.number,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Expiry')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _expirycontroller,
                          hintText: ' ',
                          labeltext: '',
                          keyboardType: TextInputType.number,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Issue')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _issuecontroller,
                          hintText: ' ',
                          labeltext: '',
                          keyboardType: TextInputType.name,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Permit Card')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: w * 0.044),
                          child: CustomTextFormField(
                            width: 320,
                            controller: _permitcardcontroller,
                            hintText: '',
                            labeltext: '',
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: w * 0.07,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: w * 0.1),
                  child: CustomTextButton(
                      title: 'Save',
                      width: w * 0.3,
                      background: orange,
                      textColor: white,
                      fontSize: 20,
                      onTap: () {
                        _saveData();
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(left: w * 0.15),
                  child: CustomTextButtonOut(
                    title: 'Clear',
                    width: w * 0.3,
                    background: Colors.transparent,
                    textColor: black,
                    fontSize: 20,
                    onTap: () {
                      clear();
                    },
                    color: black,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

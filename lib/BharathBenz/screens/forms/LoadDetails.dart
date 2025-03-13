import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombuttom%20outlined.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart';
import 'package:truckclgproject/widgets/customtextformwithicon.dart';

class BLoadDetails extends StatefulWidget {
  const BLoadDetails({super.key});

  @override
  State<BLoadDetails> createState() => _LoadDetailsState();
}

class _LoadDetailsState extends State<BLoadDetails> {

final _formKey = GlobalKey<FormState>();


  final TextEditingController _datepickController = TextEditingController();
  DateTime? pickeddate;
  var _startpointcontroller = TextEditingController();
  var _loadpointcontroller = TextEditingController();
  var _droppointcontroller = TextEditingController();
  var _nooftonscontroller = TextEditingController();
  var _loadamountcontroller = TextEditingController();
  var _deliveryamountcontroller = TextEditingController();
  var _customernamecontroller = TextEditingController();
  var _customernocontroller = TextEditingController();
  var _dieselcontroller = TextEditingController();
  var _drivercontroller = TextEditingController();
  var _paytypecontroller = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  bool isOptionAppended = false;
  String selectedOption = '';
  String inputText = '';
  String selectedOption02 = '';
  final TextEditingController _controller = TextEditingController();

  List<String> options = ['Tons', 'Units'];
  List<String> options02 = ['Cash', 'Credit'];

  List<String> _items = []; // List to hold Firestore data
  String? _selectedItemvehicle; // Variable to hold the selected item
  @override
  void initState() {
    super.initState();
    _fetchItems(); // Fetch items when the widget is initialized
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

  void clear() {
    _datepickController.clear();
    _startpointcontroller.clear();
    _loadpointcontroller.clear();
    _droppointcontroller.clear();
    _loadamountcontroller.clear();
    _deliveryamountcontroller.clear();
    _customernamecontroller.clear();
    _customernocontroller.clear();
    _dropController.clear();
    _dieselcontroller.clear();
    _drivercontroller.clear();
    _paytypecontroller.clear();
    print(_nooftonscontroller.text + ' $selectedOption');
  }

  void _storeOrUpdateData(String date, String number) async {
    if (_dropController.text.isEmpty &&
        _datepickController.text.isEmpty &&
        _startpointcontroller.text.isEmpty &&
        _loadpointcontroller.text.isEmpty &&
        _droppointcontroller.text.isEmpty &&
        _nooftonscontroller.text.isEmpty &&
        _loadamountcontroller.text.isEmpty &&
        _deliveryamountcontroller.text.isEmpty &&
        _customernamecontroller.text.isEmpty &&
        _datepickController.text.isEmpty &&
        _drivercontroller.text.isEmpty &&
        _dieselcontroller.text.isEmpty &&
        _paytypecontroller.text.isEmpty &&
        _customernocontroller.text.isEmpty) {
     
      return;
    } else if (_formKey.currentState!.validate()) {
      try {
        // Reference to the Firestore collection
        final collectionRef = FirebaseFirestore.instance
            .collection('CalendarAppointmentCollectionIncome');

        // Convert the number from String to int, ensuring no null or invalid conversion
        int parsedNumber = int.tryParse(number) ?? 0;

        // Query to check if a document with the same date exists
        final querySnapshot =
            await collectionRef.where('StartTime', isEqualTo: date).get();

        if (querySnapshot.docs.isNotEmpty) {
          // Document exists, update the number
          final docRef = querySnapshot.docs.first.reference;
          // Retrieve the existing number, ensuring it's treated as int
          final existingNumberString =
              (querySnapshot.docs.first.data()['Subject'] ?? 0) as String;
          int existingNumber = int.tryParse(existingNumberString) ?? 0;

          // Sum the existing number with the new number
          final newNumber = existingNumber + parsedNumber;

          // Update the document with the new summed number
          await docRef.update({'Subject': newNumber.toString()});
          print('Document updated: $date with new number: $newNumber');
        } else {
          // Document does not exist, create a new one
          await collectionRef
              .add({'StartTime': date, 'Subject': parsedNumber.toString()});
          print(
              'New document created: $date with number: ${parsedNumber.toString()}');
        }
      } catch (e) {
        // Handle errors
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update data: $e')),
        );
      }
    }
    else{
      return;
    }
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
      if (kDebugMode) {
        print('Error fetching data from Firestore: $e');
      } // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    void _saveData() async {
      if (_dropController.text.isEmpty &&
          _datepickController.text.isEmpty &&
          _startpointcontroller.text.isEmpty &&
          _loadpointcontroller.text.isEmpty &&
          _droppointcontroller.text.isEmpty &&
          _nooftonscontroller.text.isEmpty &&
          _loadamountcontroller.text.isEmpty &&
          _deliveryamountcontroller.text.isEmpty &&
          _customernamecontroller.text.isEmpty &&
          _datepickController.text.isEmpty &&
          _drivercontroller.text.isEmpty &&
          _dieselcontroller.text.isEmpty &&
          _paytypecontroller.text.isEmpty &&
          _customernocontroller.text.isEmpty) {
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
      } else if (_formKey.currentState!.validate()) {
        try {
          await FirebaseFirestore.instance
              .collection('bharathbenzloaddetail')
              .add({
            'vehiclenumber': _dropController.text,
            'date': _datepickController.text,
            'Start Point': _startpointcontroller.text,
            'Load Point': _loadpointcontroller.text,
            'Drop Point': _droppointcontroller.text,
            'No Of Tons Units': _nooftonscontroller.text + ' $selectedOption',
            'Load Amount': _loadamountcontroller.text,
            'paymenttype': _paytypecontroller.text,
            'Delivery Amount': _deliveryamountcontroller.text,
            'Customer Name': _customernamecontroller.text,
            'Customer Number': _customernocontroller.text,
            'driver': _drivercontroller.text,
            'diesel': _dieselcontroller.text,
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
       else {
        return;
      }
    }

    void _appendOption() {
      // Append the option only if it hasn't been appended already
      if (!isOptionAppended &&
          inputText.isNotEmpty &&
          selectedOption.isNotEmpty) {
        _controller.text = '$inputText $selectedOption';
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        isOptionAppended = true; // Mark as appended
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
      appBar: const CustomAppBar(title: 'Load Detail'),
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
                              child: Text('Start Point')),
                        ),
                        CustomTextFormFieldIcon(
                          width: 320,
                          controller: _startpointcontroller,
                          hintText: '',
                          labeltext: '',
                          validate: true,
                          keyboardType: TextInputType.name,
                          prefixicon: const Icon(Icons.share_location_sharp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Load Point')),
                        ),
                        CustomTextFormFieldIcon(
                          width: 320,
                          controller: _loadpointcontroller,
                          hintText: '',
                          labeltext: '',
                          validate: true,
                          keyboardType: TextInputType.name,
                          prefixicon: const Icon(Icons.share_location_sharp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Drop Point')),
                        ),
                        CustomTextFormFieldIcon(
                          width: 320,
                          controller: _droppointcontroller,
                          hintText: ' ',
                          labeltext: ' ',
                          validate: true,
                          keyboardType: TextInputType.name,
                          prefixicon: const Icon(Icons.share_location_sharp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('No of Tons / Units')),
                        ),
                        Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextFormField(
                              width: 320,
                              controller: _nooftonscontroller,
                              hintText: "",
                              labeltext: "Item's in $selectedOption",
                              keyboardType: TextInputType.number,
                              validate: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 30, top: 10, bottom: 6),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: DropdownButton<String>(
                                hint: const Text('Select'),
                                value: selectedOption.isEmpty
                                    ? null
                                    : selectedOption,
                                items: options.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedOption = newValue!;
                                    _appendOption();
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Load Amount')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _loadamountcontroller,
                          hintText: ' ',
                          labeltext: '',
                          validate: true,
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
                              child: Text('Delivery Amount')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _deliveryamountcontroller,
                          hintText: ' ',
                          labeltext: '',
                          validate: true,
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
                              child: Text('Payment Type')),
                        ),
                    Container(
      width: 320,
      child: DropdownButtonFormField<String>(
        value: selectedOption02.isEmpty ? null : selectedOption02, // Set the value
        decoration: InputDecoration(
          labelText: '', 
          hintText: 'Select Payment Type',
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
        items: options02.map((String value02) {
          return DropdownMenuItem<String>(
            value: value02,
            child: Text(value02),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedOption02 = newValue!;
            _paytypecontroller.text = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a value';
          }
          return null;
        },
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
                              child: Text('Customer Name')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _customernamecontroller,
                          hintText: ' ',
                          labeltext: '',
                          keyboardType: TextInputType.name,
                          validate: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: w * 0.03,
                              right: w * 0.03,
                              left: w * 0.025,
                              bottom: w * 0.02),
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Customer No')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: w * 0.0044),
                          child: CustomTextFormField(
                            width: 320,
                            controller: _customernocontroller,
                            hintText: ' ',
                            labeltext: '',
                            keyboardType: TextInputType.number,
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
                              child: Text('Driver')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _drivercontroller,
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
                              child: Text('Diesel')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: w * 0.044),
                          child: CustomTextFormField(
                            width: 320,
                            controller: _dieselcontroller,
                            hintText: '',
                            labeltext: '',
                            keyboardType: TextInputType.number,
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
                        _storeOrUpdateData(_datepickController.text,
                            _deliveryamountcontroller.text);
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

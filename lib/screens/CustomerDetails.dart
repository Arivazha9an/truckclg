import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombuttom%20outlined.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart';
import 'package:truckclgproject/widgets/customtextformwithicon.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({super.key});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final _formKey = GlobalKey<FormState>();

  final _namecontroller = TextEditingController();
  final _placecontroller = TextEditingController();
  final _materialcontroller = TextEditingController();
  final _paymentcontroller = TextEditingController();
  final _paidcontroller = TextEditingController();
  final _notpaidcontroller = TextEditingController();


    @override
  void initState() {
    super.initState();

    // Add listeners to payment and paid fields
    _paymentcontroller.addListener(_updateDueAmount);
    _paidcontroller.addListener(_updateDueAmount);
  }

  clear() {
    _namecontroller.clear();
    _placecontroller.clear();
    _materialcontroller.clear();
    _paymentcontroller.clear();
    _paidcontroller.clear();
    _notpaidcontroller.clear();
  }
    void _updateDueAmount() {
    int amount = int.tryParse(_paymentcontroller.text) ?? 0;
   int paid = int.tryParse(_paidcontroller.text) ?? 0;

    int due = amount - paid;

    // Update the due field and border color
    _notpaidcontroller.text =
        due.toStringAsFixed(0); // Display due amount with 2 decimal places
    setState(() {
    });
  }

  void _saveData() {
    if (_namecontroller.text.isEmpty &&
        _placecontroller.text.isEmpty &&
        _materialcontroller.text.isEmpty &&
        _paymentcontroller.text.isEmpty &&
        _paidcontroller.text.isEmpty &&
        _notpaidcontroller.text.isEmpty) {
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
        FirebaseFirestore.instance.collection('customerdetails').add({
          'Name': _namecontroller.text,
          'Place': _placecontroller.text,
          'Material': _materialcontroller.text,
          'Payment': _paymentcontroller.text,
          'Paid': _paidcontroller.text,
          'Not_Paid': _notpaidcontroller.text,
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
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    }
    else{
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Customer Details'),
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
                              child: Text('Name')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _namecontroller,
                          hintText: '',
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
                              child: Text('place')),
                        ),
                        CustomTextFormFieldIcon(
                          width: 320,
                          controller: _placecontroller,
                          hintText: ' ',
                          labeltext: '',
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
                              child: Text('Material')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _materialcontroller,
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
                              child: Text('Amount')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _paymentcontroller,
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
                              child: Text('Paid')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _paidcontroller,
                          hintText: '',
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
                              child: Text('Due')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: w * 0.044),
                          child: CustomTextFormField(
                            width: 320,
                            controller: _notpaidcontroller,
                            hintText: '',
                            labeltext: '',
                            keyboardType: TextInputType.number,
                            readOnly:
                                true, // Make this field read-only since it's auto-calculated
                            // decoration: InputDecoration(
                            //   border: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //         color:
                            //             _dueBorderColor), // Change border color based on due amount
                            //   ),
                            // ),
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
                    title: 'clear',
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

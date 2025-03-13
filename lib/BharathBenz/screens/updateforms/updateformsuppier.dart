import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart';
import 'package:truckclgproject/widgets/customtextformwithicon.dart';
import 'package:flutter/material.dart';

class UpdateFormSupplier extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;
  const UpdateFormSupplier(
      {super.key, required this.docId, required this.data});

  @override
  State<UpdateFormSupplier> createState() => _updateFormCustomerState();
}

class _updateFormCustomerState extends State<UpdateFormSupplier> {
  final _formKey = GlobalKey<FormState>();
  

  // Define the controllers at the class level
  late TextEditingController _namecontroller;
  late TextEditingController _placecontroller;
  late TextEditingController _materialcontroller;
  late TextEditingController _paymentcontroller;
  late TextEditingController _paidcontroller;
  var  _notpaidcontroller= TextEditingController();
  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from Firestore
    _namecontroller = TextEditingController(text: widget.data['Name']);
    _placecontroller = TextEditingController(text: widget.data['Place'] ?? '');
    _materialcontroller =
        TextEditingController(text: widget.data['Material'] ?? '');
    _paymentcontroller =
        TextEditingController(text: widget.data['Payment'] ?? '');
    _paidcontroller = TextEditingController(text: widget.data['Paid'] ?? '');
         _paymentcontroller.addListener(_updateDueAmount);
    _paidcontroller.addListener(_updateDueAmount);
  }

  void _updateDueAmount() {
    int amount = int.tryParse(_paymentcontroller.text) ?? 0;
    int paid = int.tryParse(_paidcontroller.text) ?? 0;

    int due = amount - paid;

  
    _notpaidcontroller.text =
        due.toStringAsFixed(0); 
    setState(() {
    });
  }
  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _namecontroller.dispose();
    _placecontroller.dispose();
    _materialcontroller.dispose();
    _paymentcontroller.dispose();
    _paidcontroller.dispose();
    _notpaidcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Update Supplier Data', isGoBack: true),
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
                          hintText: '',
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
                              child: Text('Amount')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _paymentcontroller,
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
                                true,
                            // decoration: InputDecoration(
                            //   border: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //         color:
                            //             _dueBorderColor), 
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
            const SizedBox(height: 20),
            CustomTextButton(
              width: 150,
              title: 'Update',
              background: orange,
              textColor: white,
              fontSize: 18,
              onTap: () {
                // Update Firestore document with new values

                if (_formKey.currentState!.validate()) {
                  FirebaseFirestore.instance
                      .collection('supplierdetails')
                      .doc(widget.docId)
                      .update({
                    'Name': _namecontroller.text,
                    'Place': _placecontroller.text,
                    'Material': _materialcontroller.text,
                    'Payment': _paymentcontroller.text,
                    'Paid': _paidcontroller.text,
                    'Not_Paid': _notpaidcontroller.text,
                    'delDate': Timestamp.now(),
                  }).then((_) {
                    Navigator.pop(context); // Go back after updating
                  });
                } else {
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

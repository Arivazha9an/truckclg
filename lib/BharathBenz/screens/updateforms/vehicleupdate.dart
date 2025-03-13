import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart'; 

class UpdateFormVehicle extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const UpdateFormVehicle({super.key, required this.docId, required this.data});

  @override
  State<UpdateFormVehicle> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateFormVehicle> {
  final _formKey = GlobalKey<FormState>();

  // Define the controllers at the class level

  late TextEditingController _vehiclecondition;
  late TextEditingController _regnocontroller;
  late TextEditingController _brandcontroller;
  late TextEditingController _lorrycontroller;
  late TextEditingController _modelcontroller;
  late TextEditingController _buildyearcontroller;
// List to hold Firestore data
// Variable to hold the selected item

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from Firestore

    _vehiclecondition =
        TextEditingController(text: widget.data['Vehicle Condition'] ?? '');
    _regnocontroller =
        TextEditingController(text: widget.data['vehicle Number']);
    _brandcontroller = TextEditingController(text: widget.data['Brand'] ?? '');
    _lorrycontroller = TextEditingController(text: widget.data['Lorry'] ?? '');
    _modelcontroller = TextEditingController(text: widget.data['Model'] ?? '');
    _buildyearcontroller =
        TextEditingController(text: widget.data['Build Year'] ?? '');
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _regnocontroller.dispose();
    _vehiclecondition.dispose();
    _lorrycontroller.dispose();
    _brandcontroller.dispose();
    _modelcontroller.dispose();
    _lorrycontroller.dispose();
    _buildyearcontroller.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Update Refuel Data', isGoBack: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: orange, width: w * 0.005),
                ),
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
                              child: Text('Vehicle Condition')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _vehiclecondition,
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
                              child: Text('Registration No')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _regnocontroller,
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
                              child: Text('Brand')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _brandcontroller,
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
                              child: Text('lorry')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _lorrycontroller,
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
                              child: Text('Model')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: _modelcontroller,
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
                              child: Text('Build Year')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: w * 0.044),
                          child: CustomTextFormField(
                            width: 320,
                            controller: _buildyearcontroller,
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

            // Other fields with similar padding and input
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
                      .collection('bharathbenzvehicledetail')
                      .doc(widget.docId)
                      .update({
                    'Vehicle Condition': _vehiclecondition.text,
                    'vehicle Number': _regnocontroller.text,
                    'Brand': _brandcontroller.text,
                    'Lorry': _lorrycontroller.text,
                    'Model': _modelcontroller.text,
                    'Build Year': _buildyearcontroller.text,
                    'delDate': Timestamp.now(),
                  }).then((_) {
                    Navigator.pop(context); // Go back after updating
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombuttom%20outlined.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BVehicleDetails extends StatefulWidget {
  const BVehicleDetails({super.key});

  @override
  State<BVehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<BVehicleDetails> {

final _formKey =GlobalKey<FormState>();

  var _vehiclecondition = TextEditingController();
  var _regnocontroller = TextEditingController();
  var _brandcontroller = TextEditingController();
  var _lorrycontroller = TextEditingController();
  var _modelcontroller = TextEditingController();
  var _buildyearcontroller = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
// List to hold Firestore data
// Variable to hold the selected item
  @override
  void initState() {
    super.initState();
    _fetchItems(); // Fetch items when the widget is initialized
  }

  void clear() {
    _vehiclecondition.clear();
    _regnocontroller.clear();
    _brandcontroller.clear();
    _lorrycontroller.clear();
    _modelcontroller.clear();
    _buildyearcontroller.clear();
    _dropController.clear();
  }

  // Function to fetch data from Firestore
  Future<void> _fetchItems() async {
    try {
      // Fetch data from Firestore (replace 'collectionName' and 'fieldName' with your actual Firestore collection and field)
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bharathbenzvehicledetail')
          .get();

      // Extract data from documents and convert to a list of strings
      snapshot.docs.map((doc) => doc['vehicle Number'].toString()).toList();

      setState(() {
// Update the state with fetched items
      });
    } catch (e) {
      print('Error fetching data from Firestore: $e'); // Handle errors
    }
  }

  

  @override
  Widget build(BuildContext context) {
    void _saveData() async {
      if (_vehiclecondition.text.isEmpty &&
          _regnocontroller.text.isEmpty &&
          _brandcontroller.text.isEmpty &&
          _lorrycontroller.text.isEmpty &&
          _modelcontroller.text.isEmpty &&
          _buildyearcontroller.text.isEmpty) {
        // Show error dialog if fields are empty
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
      }

      try {
        // Check if the vehicle number already exists
        var querySnapshot = await FirebaseFirestore.instance
            .collection('bharathbenzvehicledetail')
            .where('vehicle Number', isEqualTo: _regnocontroller.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Show error dialog if vehicle number already exists
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('This vehicle number already exists.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        } else if (_formKey.currentState!.validate()){
          // Save data to Firestore
          await FirebaseFirestore.instance
              .collection('bharathbenzvehicledetail')
              .add({
            'Vehicle Condition': _vehiclecondition.text,
            'vehicle Number': _regnocontroller.text,
            'Brand': _brandcontroller.text,
            'Lorry': _lorrycontroller.text,
            'Model': _modelcontroller.text,
            'Build Year': _buildyearcontroller.text
          });

          // Show success toast
          Fluttertoast.showToast(
            msg: "Vehicle added successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // Navigate back to the previous page after a delay
          Future.delayed(
              const Duration(seconds: 2), () => Navigator.pop(context));
        }
        else{
          return;
        }
        
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

    var w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Vehicle Detail'),
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
                            hintText: ' ',
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

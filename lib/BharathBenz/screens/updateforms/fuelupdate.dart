import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:truckclgproject/widgets/custombutton.dart';
import 'package:truckclgproject/widgets/customtextform.dart';
import 'package:truckclgproject/widgets/customtextformwithicon.dart';

class UpdateForm extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const UpdateForm({super.key, required this.docId, required this.data});

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {

final _formKey = GlobalKey<FormState>();

  // Define the controllers at the class level
  late TextEditingController dateController;
  late TextEditingController startKmController;
  late TextEditingController priceController;
  late TextEditingController literController;
  late TextEditingController placeController;
  late TextEditingController endKmController;
  late TextEditingController _dropController;
  List<String> _items = []; // List to hold Firestore data
  String? _selectedItemvehicle; // Variable to hold the selected item
  
  @override
  void initState() {
    _fetchItems();
    super.initState();
    // Initialize controllers with data from Firestore
    _dropController = TextEditingController(text: widget.data['vehiclenumber']);
    dateController = TextEditingController(text: widget.data['date'] ?? '');
    startKmController =
        TextEditingController(text: widget.data['Start KM'] ?? '');
    priceController = TextEditingController(text: widget.data['Price'] ?? '');
    literController = TextEditingController(text: widget.data['Liter'] ?? '');
    placeController = TextEditingController(text: widget.data['Place'] ?? '');
    endKmController = TextEditingController(text: widget.data['End Km'] ?? '');
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

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _dropController.dispose();
    dateController.dispose();
    startKmController.dispose();
    priceController.dispose();
    literController.dispose();
    placeController.dispose();
    endKmController.dispose();
    super.dispose();
  }

  DateTime? _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }


    updateData() {
    int start = int.tryParse(startKmController.text) ?? 0;
    int end = int.tryParse(endKmController.text) ?? 0;
    int fuel = int.tryParse(literController.text) ?? 0;
    final distance = end - start;
    final milage = distance / fuel;
    // Update Firestore document with new values
    FirebaseFirestore.instance
        .collection('bharthbenzrefuel')
        .doc(widget.docId)
        .update({
      'vehiclenumber': _dropController.text,
      'date': dateController.text,
      'Start KM': startKmController.text,
      'Price': priceController.text,
      'Liter': literController.text,
      'Place': placeController.text,
      'End Km': endKmController.text,
      'Mileage': milage.toString(),
      'delDate': Timestamp.now(),
    }).then((_) {
      Navigator.pop(context); // Go back after updating
    });
  }

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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(dateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Update Refuel Data', isGoBack: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
           key: _formKey,
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
                            bottom: w * 0.02,
                          ),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Date'),
                          ),
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
                                controller: dateController,
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
                        // Other input fields go here
                        Padding(
                          padding: EdgeInsets.only(
                            top: w * 0.03,
                            right: w * 0.03,
                            left: w * 0.025,
                            bottom: w * 0.02,
                          ),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Start Km'),
                          ),
                        ),
                        CustomTextFormFieldIcon(
                          width: 320,
                          controller: startKmController,
                          hintText: 'Type',
                          labeltext: '',
                          keyboardType: TextInputType.number,
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
                              child: Text('Price')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: priceController,
                          hintText: 'Type',
                          labeltext: 'Type',
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
                              child: Text('Liters')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: literController,
                          hintText: 'Type',
                          labeltext: 'Type',
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
                              child: Text('Place')),
                        ),
                        CustomTextFormField(
                          width: 320,
                          controller: placeController,
                          hintText: 'Type',
                          labeltext: 'Type',
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
                              child: Text('End Km')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: w * 0.044),
                          child: CustomTextFormFieldIcon(
                            width: 320,
                            controller: endKmController,
                            hintText: 'Type',
                            labeltext: '',
                            keyboardType: TextInputType.number,
                            prefixicon: const Icon(Icons.share_location_sharp),
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
                          if(_formKey.currentState!.validate())
                          {
                            updateData();
                          }
                          else{
                            return;
                          }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

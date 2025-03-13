import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:truckclgproject/constants/colors.dart';

class FirestoreDropdownTextField extends StatefulWidget {
  @override
  _FirestoreDropdownTextFieldState createState() =>
      _FirestoreDropdownTextFieldState();
}

class _FirestoreDropdownTextFieldState
    extends State<FirestoreDropdownTextField> {
  final TextEditingController _dropController = TextEditingController();
  List<String> _items = []; // List to hold Firestore data
  String? _selectedItem; // Variable to hold the selected item

  @override
  void initState() {
    super.initState();
    _fetchItems(); // Fetch items when the widget is initialized
  }

  // Function to fetch data from Firestore
  Future<void> _fetchItems() async {
    try {
      // Fetch data from Firestore (replace 'collectionName' and 'fieldName' with your actual Firestore collection and field)
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('AddVehicles').get();

      // Extract data from documents and convert to a list of strings
      List<String> items =
          snapshot.docs.map((doc) => doc['Vehicle Number'].toString()).toList();

      setState(() {
        _items = items; // Update the state with fetched items
      });
    } catch (e) {
      print('Error fetching data from Firestore: $e'); // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;
    return  Padding(
        padding: EdgeInsets.all(w * 0.05),
        child: Column(
          children: [
            TextField(
              controller: _dropController,
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                labelText: 'Select Item',
                suffixIcon: DropdownButton<String>(
                  value: _selectedItem,
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
                      _selectedItem = newValue; // Update the selected item
                      _dropController.text =
                          newValue ?? ''; // Update the text field
                    });
                  },
                ),
                 focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: orange)
                ),
              ),
            ),
          ],
        ),
      );
    
  }
}

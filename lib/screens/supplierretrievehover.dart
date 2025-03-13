
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:truckclgproject/BharathBenz/screens/forms/Supplierdetails.dart';
import 'package:truckclgproject/BharathBenz/screens/updateforms/updateformsuppier.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/TextfieldwithButton.dart';

class Supplierretrievehover extends StatefulWidget {
  const Supplierretrievehover({super.key});

  @override
  State<Supplierretrievehover> createState() => _SupplierretrievehoverState();
}

class _SupplierretrievehoverState extends State<Supplierretrievehover> {
  bool _isLoading = true;

  List<Map<String, dynamic>> _allDataList = [];
  List<Map<String, dynamic>> _filteredDataList = [];
  TextEditingController _searchController = TextEditingController();
  double combinedexpense = 0.0;
  double combineincome = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _simulateLoading();
    expenseSum();
    incomeSum();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('supplierdetails').get();

      setState(() {
        _allDataList = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
        _filteredDataList = _allDataList;
        _isLoading = false;

        
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching supplierdetails details: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _filteredDataList = _allDataList
          .where((data) => data['Name']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  double combinedExpense = 0.0;
  double combinedIncome = 0.0;
  Future incomeSum() async {
    try {
      // Initialize a combined sum variable
      double combinedIncome = 0.0;

      // List of collection names
      List<String> collections = [
        'bharathbenzloaddetail',
        'bharathbenzloaddetail2',
        'taurusloaddetail',
      ];

      // Field names to sum
      String field1 = 'Delivery Amount';
      String field2 = 'Delivery Amount1';

      // Iterate through each collection
      for (String collection in collections) {
        // Fetch all documents from the current collection
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection(collection).get();

        // Iterate through documents in the current collection
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          // Access document data
          final data = doc.data() as Map<String, dynamic>;

          // Get the values of field1, field2, and field3
          final fieldValue1 = data[field1];
          final fieldValue2 = data[field2];

          // Convert to double and add to combined sum
          if (fieldValue1 != null) {
            if (fieldValue1 is String) {
              combinedIncome += double.tryParse(fieldValue1) ?? 0.0;
            } else if (fieldValue1 is num) {
              combinedIncome += fieldValue1.toInt();
            }
          }
          if (fieldValue2 != null) {
            if (fieldValue2 is String) {
              combinedIncome += double.tryParse(fieldValue2) ?? 0.0;
            } else if (fieldValue2 is num) {
              combinedIncome += fieldValue2.toInt();
            }
          }
        }
      }
      setState(() {
        combineincome = combinedIncome;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching documents: $e');
      }
    }
  }

  Future expenseSum() async {
    try {
      // Initialize a combined sum variable
      double combinedExpense = 0.0;

      // List of collection names
      List<String> collections = [
        'bharathbenzexpensedetail',
        'bharathbenzexpensedetail2',
        'taurusexpensedetail',
      ];

      // Field names to sum
      String field1 = 'Amount';

      // Iterate through each collection
      for (String collection in collections) {
        // Fetch all documents from the current collection
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection(collection).get();

        // Iterate through documents in the current collection
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          // Access document data
          final data = doc.data() as Map<String, dynamic>;

          // Get the values of field1, field2, and field3
          final fieldValue1 = data[field1];

          // Convert to double and add to combined sum
          if (fieldValue1 != null) {
            if (fieldValue1 is String) {
              combinedExpense += double.tryParse(fieldValue1) ?? 0.0;
            } else if (fieldValue1 is num) {
              combinedExpense += fieldValue1.toInt();
            }
          }
        }
      }

      setState(() {
        combinedexpense = combinedExpense;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching documents: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: orange, size: 60),
            )
          : Column(
              children: [
                _buildSummaryRow(),
                const Divider(color: Color.fromARGB(101, 87, 86, 84)),
                _buildSearchBar(),
                _buildCustomerList(),
                _buildAddCustomerButton(),
              ],
            ),
    );
  }

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Income', combineincome),
          Container(
            height: 70,
            child: const VerticalDivider(
              color: Colors.grey, // Adjust the color as needed
              thickness: 1, // Adjust the thickness as needed
              width: 20, // Space around the divider
            ),
          ),
          _buildSummaryItem('Expense', combinedexpense),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        Row(
          children: [
            const Icon(Icons.currency_rupee),
            Text(
              amount.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 280,
            child: Column(
              children: [
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: grey),
                    suffixIcon: const Icon(Icons.search, color: black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(color: black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                _fetchData();
              });
            },
            icon: Icon(Icons.refresh))
      ],
    );
  }

  Widget _buildCustomerList() {
    if (_filteredDataList.isEmpty) {
      return const Center(child: Text('No Supplier found'));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: _filteredDataList.length,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomFieldButton(
                name: _filteredDataList[index]['Name'],
                ontap: () {
                  // Access the document ID from _filteredDataList
                  String docId = _filteredDataList[index]
                      ['id']; // 'id' is already set in _fetchData

                  // Navigate to DetailPage and pass both data and docId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        data: _filteredDataList[index], // Pass data
                        documentId: docId, // Pass document ID
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddCustomerButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Supplierdetails()),
              );
            },
            backgroundColor: orange,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: white),
          ),
          const Text('Add Supplier'),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId; // Document ID for deleting

  DetailPage({required this.data, required this.documentId});

  @override
  Widget build(BuildContext context) {
    Color borderColor =
        (data['Not_Paid'] == 0.toString()) ? Colors.green : Colors.red;
    double width = (data['Not_Paid'] == 0.toString()) ? 2 : 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Information'),
      ),
      body: Center(
        child: Container(
          height: 200,
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: borderColor, width: width),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Supplier Name:', data['Name']),
              _buildDetailRow('Place:', data['Place']),
              _buildDetailRow('Material:', data['Material']),
              _buildDetailRow('Paid:', data['Paid']),
              _buildDetailRow('Not Paid:', data['Not_Paid']),
              _buildDetailRow('Payment:', data['Payment']),
              Center(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateFormSupplier(
                              docId: documentId,
                              data: data,
                            ),
                          ),
                        );
                      },
                      icon: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: orange,
                            border: Border.all(color: orange)),
                        child: const Icon(
                          Icons.edit,
                          color: white,
                          // size: 30,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      icon: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.red,
                            border: Border.all(color: Colors.red)),
                        child: const Icon(
                          Icons.delete,
                          color: white,
                          // size: 30,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Container(
                    //     height: 35,
                    //     width: 35,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(40),
                    //         color: Colors.green.shade400,
                    //         border: Border.all(color: Colors.red)),
                    //     child: const Icon(
                    //       Icons.share,
                    //       color: white,
                    //       // size: 30,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Row(
      children: [
        Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('$value'),
      ],
    );
  }

  // Show confirmation dialog for deletion
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this supplier?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog first
                _deleteCustomer(
                    context); // Proceed to delete after dialog is closed
              },
            ),
          ],
        );
      },
    );
  }

  // Delete customer document from Firestore
  Future<void> _deleteCustomer(BuildContext context) async {
    try {
      // Delete the customer document
      await FirebaseFirestore.instance
          .collection('supplierdetails')
          .doc(documentId)
          .delete();

      // Show the SnackBar using root context
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Supplier deleted successfully")),
      );

      // Wait for a brief moment so the SnackBar is visible before popping
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pop(); // Go back to the previous screen
      });
    } catch (e) {
      // Show an error message if the delete fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting Supplier: $e")),
      );
    }
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:truckclgproject/BharathBenz/screens/updateforms/customerupdate.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/screens/CustomerDetails.dart';
import 'package:truckclgproject/widgets/TextfieldwithButton.dart';

class CustomerRetriveHover extends StatefulWidget {
  const CustomerRetriveHover({super.key});

  @override
  State<CustomerRetriveHover> createState() => _CustomerRetriveHoverState();
}

class _CustomerRetriveHoverState extends State<CustomerRetriveHover> {
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
          await FirebaseFirestore.instance.collection('customerdetails').get();

      setState(() {
        _allDataList = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Store document ID in the data map
          return data;
        }).toList();
        _filteredDataList = _allDataList; // Initialize with all data
        _isLoading = false;

        // Stop loading once data is fetched
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching customer details: $e');
      }
      setState(() {
        _isLoading = false; // Stop loading on error as well
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
      return const Center(child: Text('No Customer found'));
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
                    builder: (context) => const CustomerDetails()),
              );
            },
            backgroundColor: orange,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: white),
          ),
          const Text('Add Customer'),
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

    Future<void> _generatePdf() async {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                  child: pw.Text('Customer Data',
                      style: pw.TextStyle(fontSize: 24))),
              pw.SizedBox(height: 16),
              pw.Text('Customer Name: ${data['Name'] ?? ''}'),
              pw.Text('Place: ${data['Place'] ?? ''}'),
              pw.Text('Material: ${data['Material'] ?? ''}'),
              pw.Text('Payment: ${data['Payment'] ?? ''}'),
              pw.Text('Paid: ${data['Paid'] ?? ''}'),
              pw.Text('Not Paid: ${data['Not_Paid'] ?? ''}'),
            ],
          ),
        ),
      );

      try {
        // Request storage permission if not granted
        if (!await Permission.storage.isGranted) {
          await Permission.storage.request();
        }

        // Get directory for saving the PDF
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/customer_data_${DateTime.now().toIso8601String()}.pdf';

        // Save the PDF to file
        final file = File(path);
        await file.writeAsBytes(await pdf.save());

        // Share or open the PDF (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved: $path')),
        );
      } catch (e) {
        print('Error generating PDF: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Information'),
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
              _buildDetailRow('Customer Name:', data['Name']),
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
                            builder: (context) => UpdateFormCustomer(
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
                            color: Colors.orange,
                            border: Border.all(color: Colors.orange)),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     _generatePdf();
                    //   },
                    //   icon: Container(
                    //     height: 35,
                    //     width: 35,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(40),
                    //         color: Colors.green.shade400),
                    //     child: const Icon(
                    //       Icons.share,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
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
          content: const Text("Are you sure you want to delete this customer?"),
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
      await FirebaseFirestore.instance
          .collection('customerdetails')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer deleted successfully")),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pop(); // Go back to the previous screen
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting customer: $e")),
      );
    }
  }
}

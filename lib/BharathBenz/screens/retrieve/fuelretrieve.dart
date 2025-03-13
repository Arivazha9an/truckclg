import 'dart:io';
import 'package:truckclgproject/BharathBenz/screens/updateforms/fuelupdate.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class FuelRetrieve extends StatefulWidget {
  const FuelRetrieve({super.key});

  @override
  _FuelRetrieveState createState() => _FuelRetrieveState();
}

class _FuelRetrieveState extends State<FuelRetrieve> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int _currentPage = 0;
  Map<int, List<DocumentSnapshot>> _pageData = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  late PageController _pageController;
  final TextEditingController _dropController = TextEditingController();
  List<String> _items = []; // List to hold Firestore data
  String? _selectedItemvehicle;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchData(0);
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _pageController.dispose();
    super.dispose();
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

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String docId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await FirebaseFirestore.instance
                      .collection('bharthbenzrefuel')
                      .doc(docId)
                      .delete();
                } catch (e) {
                  // Handle error (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to delete the record.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      TextEditingController controller, DateTime? currentDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
        if (controller == _startDateController) {
          _startDate = picked;
        } else if (controller == _endDateController) {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _fetchData(int pageIndex) async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    // Start with the base query
    Query query = FirebaseFirestore.instance
        .collection('bharthbenzrefuel')
        .orderBy('date')
        .limit(10);

    // Apply date filters if selected
    if (_startDate != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: DateFormat('dd/MM/yyyy').format(_startDate!));
    }
    if (_endDate != null) {
      query = query.where('date',
          isLessThanOrEqualTo: DateFormat('dd/MM/yyyy').format(_endDate!));
    }

    // Filter by the selected vehicle number if one is selected
    if (_selectedItemvehicle != null && _selectedItemvehicle!.isNotEmpty) {
      query = query.where('vehiclenumber', isEqualTo: _selectedItemvehicle);
    }

    // Paginate the results
    if (pageIndex > 0 && _pageData.containsKey(pageIndex - 1)) {
      query = query.startAfterDocument(_pageData[pageIndex - 1]!.last);
    }

    try {
      QuerySnapshot querySnapshot = await query.get();
      List<DocumentSnapshot> documents = querySnapshot.docs;

      setState(() {
        _isLoading = false;
        if (documents.isEmpty) {
          _hasMoreData = false;
        } else {
          _pageData[pageIndex] = documents;
          if (documents.length < 10) {
            _hasMoreData = false;
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');
      // Handle errors (optional)
      Fluttertoast.showToast(msg: 'Failed to fetch data.');
    }
  }

  void _onPageChanged(int index) {
    if (!_pageData.containsKey(index)) {
      _fetchData(index);
    }
    setState(() {
      _currentPage = index;
    });
  }

  void _onPageNumberClicked(int index) {
    if (index < _pageData.length) {
      _pageController.jumpToPage(index);
    }
  }

  // Generate PDF document from the data
  Future<File> _generatePdf(List<DocumentSnapshot> documents) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final data = documents[index].data() as Map<String, dynamic>;

            return pw.Container(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Vehicle No: ${data['vehiclenumber'] ?? ''}'),
                  pw.Text('Date: ${data['date'] ?? ''}'),
                  pw.Text('Start Km: ${data['Start KM'] ?? ''}'),
                  pw.Text('Price: ${data['Price'] ?? ''}'),
                  pw.Text('Liters: ${data['Liter'] ?? ''}'),
                  pw.Text('Place: ${data['Place'] ?? ''}'),
                  pw.Text('End KM: ${data['End Km'] ?? ''}'),
                  pw.Text('Mileage: ${data['Mileage'] ?? ''}'),
                  pw.Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );

    // Generate the PDF bytes
    final bytes = await pdf.save();

    // Request storage permission (if not already granted)
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }

    // Get the directory to save the PDF
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/fuel_data_${DateTime.now().toString().replaceAll(':', '-')}.pdf';

    // Save the PDF to the device
    final file = File(path);
    await file.writeAsBytes(bytes);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Refuel Data', isGoBack: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () =>
                            _selectDate(_startDateController, _startDate),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () =>
                            _selectDate(_endDateController, _endDate),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _pageData.clear();
                      _hasMoreData = true;
                      _currentPage = 0;
                      _fetchData(0); // Fetch first page
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 15, left: 15, top: 0, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedItemvehicle,
                  hint: const Text('Vehicle Number'),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItemvehicle =
                          newValue; // Update the selected item
                      _dropController.text =
                          newValue ?? ''; // Update the text field
                      _pageData.clear(); // Clear existing data
                      _hasMoreData = true; // Reset data fetching state
                      _currentPage = 0; // Reset to the first page
                      _fetchData(0); // Fetch data for the first page
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: () {
                    setState(() {
                      _startDate = null; // Clear the start date filter
                      _endDate = null; // Clear the end date filter
                      _selectedItemvehicle = null; // Clear the vehicle filter
                      _startDateController
                          .clear(); // Clear the start date TextField
                      _endDateController
                          .clear(); // Clear the end date TextField
                      _pageData.clear(); // Clear existing paginated data
                      _hasMoreData = true; // Reset the flag to fetch more data
                      _currentPage = 0; // Reset to the first page
                      _fetchData(0); // Fetch data without filters
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pageData.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (_pageData.containsKey(index)) {
                  List<DocumentSnapshot> documents = _pageData[index]!;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, i) {
                      Map<String, dynamic> data =
                          documents[i].data() as Map<String, dynamic>;
                      String vehicleno = data['vehiclenumber'] ?? '';
                      String date = data['date'] ?? '';
                      String startKm = data['Start KM'] ?? '';
                      String price = data['Price'] ?? '';
                      String liter = data['Liter'] ?? '';
                      String place = data['Place'] ?? '';
                      String endKm = data['End Km'] ?? '';
                      String mileage = data['Mileage'] ?? '';
                      String docId = documents[i].id;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 240,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: orange, width: w * 0.005)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 20, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Vehicle No: '),
                                    Text(vehicleno),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Date: '),
                                    Text(date),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Start Km: '),
                                    Text(startKm),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Price: '),
                                    Text(price),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Liters: '),
                                    Text(liter),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Place: '),
                                    Text(place),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('End Km: '),
                                    Text(endKm),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Mileage: '),
                                    Text(mileage),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdateForm(
                                              docId: docId,
                                              data: data,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
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
                                        _showDeleteConfirmationDialog(
                                            context, docId);
                                      },
                                      icon: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: Colors.red,
                                            border:
                                                Border.all(color: Colors.red)),
                                        child: const Icon(
                                          Icons.delete,
                                          color: white,
                                          // size: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: orange,
                      size: 50,
                    ),
                  );
                }
              },
            ),
          ),
          // Page number indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pageData.length,
              (index) => GestureDetector(
                onTap: () => _onPageNumberClicked(index),
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.orange : Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Download button for PDF generation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              IconButton(
                onPressed: _pageData.containsKey(_currentPage)
                    ? () async {
                        try {
                          final file =
                              await _generatePdf(_pageData[_currentPage]!);
                          await Share.shareXFiles(
                            [XFile(file.path)],
                            sharePositionOrigin: Rect.fromCircle(
                              radius: w * 0.25,
                              center: const Offset(0, 0),
                            ),
                          );
                        } catch (e) {
                          print('Error sharing PDF: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error sharing PDF.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    : null,
                icon: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),

                      /// color: black,
                      border: Border.all(color: black)),
                  child: const Icon(
                    Icons.share_rounded,
                    // size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

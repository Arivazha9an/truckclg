import 'dart:io';
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

import '../updateforms/vehicleupdate.dart';

class Vehicleretrieve extends StatefulWidget {
  const Vehicleretrieve({super.key});

  @override
  State<Vehicleretrieve> createState() => _VehicleretrieveState();
}

class _VehicleretrieveState extends State<Vehicleretrieve> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  int _currentPage = 0;
  Map<int, List<DocumentSnapshot>> _pageData = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  late PageController _pageController;
// List to hold Firestore data

  @override
  void initState() {
    super.initState();
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
                      .collection('bharathbenzvehicledetail')
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
        } else if (controller == _endDateController) {
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
        .collection('bharathbenzvehicledetail')
        .limit(10);

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
                  pw.Text('Vehicle Reg No: ${data['vehicle Number'] ?? ''}'),
                  pw.Text(
                      'Vehicle Condition: ${data['Vehicle Condition'] ?? ''}'),
                  pw.Text('Brand: ${data['Brand'] ?? ''}'),
                  pw.Text('Lorry: ${data['Lorry'] ?? ''}'),
                  pw.Text('Model: ${data['Model'] ?? ''}'),
                  pw.Text('Build Year: ${data['Build Year'] ?? ''}'),
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
      appBar: const CustomAppBar(title: 'Vehicle  Data', isGoBack: true),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                      String registrationNo = data['vehicle Number'] ?? '';
                      String vehicleCondition = data['Vehicle Condition'] ?? '';
                      String brand = data['Brand'] ?? '';
                      String lorry = data['Lorry'] ?? '';
                      String model = data['Model'] ?? '';
                      String buildYear = data['Build Year'] ?? '';
                      String docId = documents[i].id;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 210,
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
                                    Text('vehicle Condition = '),
                                    Text(vehicleCondition),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Registration No  = '),
                                    Text(registrationNo),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Brand = '),
                                    Text(brand),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Lorry= '),
                                    Text(lorry),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Model = '),
                                    Text(model),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('build Year = '),
                                    Text(buildYear),
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
                                            builder: (context) => UpdateFormVehicle(
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

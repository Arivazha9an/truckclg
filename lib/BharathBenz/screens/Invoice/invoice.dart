import 'dart:typed_data';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signature/signature.dart';
import 'package:pdf/widgets.dart' as pw;

class Invoice extends StatefulWidget {
  final Map<String, dynamic> data;
  const Invoice({super.key, required this.data});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  final TextEditingController _addresscontroller = TextEditingController();
  late String date;
  late String vehicleNumber;
  late String startPoint;
  late String loadPoint;
  late String dropPoint;
  late String noofTons;
  late String loadAmount;
  late String deliveryAmount;
  late String customerName;
  late String customerNo;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    date = widget.data['date'] ?? '';
    deliveryAmount = widget.data['Delivery Amount'] ?? '';
    // Initialize controllers with data from Firestore
    vehicleNumber = widget.data['vehiclenumber'];

    startPoint = widget.data['Start Point'] ?? '';
    loadPoint = widget.data['Load Point'] ?? '';
    dropPoint = widget.data['Drop Point'] ?? '';
    noofTons = widget.data['No Of Tons Units'] ?? '';
    loadAmount = widget.data['Load Amount'] ?? '';
    deliveryAmount = widget.data['Delivery Amount'] ?? '';
    customerName = widget.data['Customer Name'] ?? '';
    customerNo = widget.data['Customer Number'] ?? '';
  }

  // Variable to hold the captured signature
  Uint8List? _signatureImage;

  Future<void> _showSignaturePad(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Here'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Signature(
              controller: _controller,
              height: 100,
              width: 300,
              backgroundColor: Colors.grey[200]!,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.clear(); // Clear the signature pad
                  },
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      final signature = await _controller.toPngBytes();
                      if (signature != null) {
                        setState(() {
                          _signatureImage = signature; // Save the signature
                        });
                      }
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _createPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(20), // Add padding to the page
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 10),
              // Header Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Logo', style: const pw.TextStyle(fontSize: 16)),
                  pw.Text(
                    'INVOICE',
                    style: pw.TextStyle(
                        fontSize: 28, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 40),

              // Billing Information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Billed To:', style: const pw.TextStyle(fontSize: 18)),
                      pw.Text(customerName, style: const pw.TextStyle(fontSize: 16)),
                      pw.Text(customerNo, style: const pw.TextStyle(fontSize: 16)),
                      pw.Text(_addresscontroller.text,
                          style: const pw.TextStyle(fontSize: 14)),
                    ],
                  ),
                  pw.Text('Date: $date', style: const pw.TextStyle(fontSize: 16)),
                ],
              ),
              pw.SizedBox(height: 30),

              // Divider
              pw.Divider(thickness: 1.5),

              // Table Header
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text('Description',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Price',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              pw.Divider(thickness: 1),

              // Table Content
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text('Vehicle Number: $vehicleNumber',
                        style: const pw.TextStyle(fontSize: 14)),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('-', style: const pw.TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              pw.Divider(),

              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text('No of Tons/Units: $noofTons',
                        style: const pw.TextStyle(fontSize: 14)),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('-', style: const pw.TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              pw.Divider(),

              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text('Load Amount',
                        style: const pw.TextStyle(fontSize: 14)),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Rs. $loadAmount',
                        style: const pw.TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              pw.Divider(),

              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text('Delivery Amount',
                        style: const pw.TextStyle(fontSize: 14)),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Rs. $deliveryAmount',
                        style: const pw.TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              pw.Divider(),

              // Total Amount
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Total Amount: Rs. $deliveryAmount',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),

              // Signature
              if (_signatureImage != null) ...[
                pw.SizedBox(height: 40),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Signature:', style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 6),
                      pw.Image(pw.MemoryImage(_signatureImage!),
                          width: 80, height: 40),
                    ],
                  ),
                ),
              ],

              pw.SizedBox(height: 20),

              // Footer
              pw.Text('Thank You !!!', style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 40),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Thiruchendur Murugan',
                          style: const pw.TextStyle(fontSize: 18)),
                      pw.Text('Peravurani', style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Thanjavur', style: const pw.TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return pdf.save();
  }

  // Function to share the generated PDF
  Future<void> _sharePdf() async {
      var date= DateTime.now();
    final pdfBytes = await _createPdf();

    // Share the PDF using share_plus
    await Share.shareXFiles(
      [      
        XFile.fromData(pdfBytes,
            mimeType: 'application/pdf', name: 'invoice$date.pdf')
      ],
      text: 'Here is your invoice!',
    );
  }
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Invoice'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Center(
              child: Container(
                width: 350,
                height: 600,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: orange, width: w * 0.005)),
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
                          child: Text(
                            'Invoice',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text('Date : $date'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Billed To '),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 325,
                              height: 80,
                              child: TextField(
                                controller: _addresscontroller,
                                maxLines: null, // Allows unlimited lines
                                decoration: const InputDecoration(
                                  labelText: 'Enter Address',
                                  border: OutlineInputBorder(),
                                  hintText: 'Type here...',
                                ),
                                keyboardType: TextInputType.multiline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Text('Customer name    :'),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(customerName),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Customer No         :'),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(customerNo),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Vehicle Number    :'),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(vehicleNumber),
                          ],
                        ),                   
                        Row(
                          children: [
                            const Text('No of Tons/ Units :'),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(noofTons),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Load Amount        :'),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(loadAmount),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Delivery Amount   :'),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(deliveryAmount),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('Total Amount : ₹'),
                            Text(deliveryAmount)
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // SizedBox(
                            //   width: 100,
                            //   height: 100,
                            //   child: TextField(
                            //     controller: _controllername,
                            //     maxLines: null, // Allows unlimited lines
                            //     decoration: InputDecoration(
                            //       labelText: 'Enter your text',
                            //       border: OutlineInputBorder(),
                            //       hintText: 'Type here...',
                            //     ),
                            //     keyboardType: TextInputType.multiline,
                            //   ),
                            // ),

                            GestureDetector(
                              onTap: () => _showSignaturePad(context),
                              child: Container(
                                height: 60,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  // border: Border.all(color: Colors.black),
                                ),
                                child: _signatureImage != null
                                    ? Image.memory(
                                        _signatureImage!) // Display the signature
                                    : const Center(child: Text('Tap to Sign')),
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  border: Border.all(
                                      color: orange, width: w * 0.005)),
                              child: Center(
                                child: IconButton(
                                    onPressed: _sharePdf,
                                    icon: const Icon(
                                      Icons.share_rounded,
                                      size: 26,
                                      color: orange,
                                    )),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

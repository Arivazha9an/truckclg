import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customcolorappbar.dart';

class MyPieChart extends StatefulWidget {
  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _datepickController = TextEditingController();
  int combinedexpense = 0;
  int combineincome = 0;

  @override
  void initState() {
    super.initState();
    fetchExpenseData();
    incomeSum();
    expenseSum();
  }

  Future incomeSum() async {
    try {
      // Initialize a combined sum variable
      int combinedIncome = 0;
      // List of collection names
      List<String> collections = [
        'bharathbenzloaddetail',
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
              combinedIncome += int.tryParse(fieldValue1) ?? 0;
            } else if (fieldValue1 is num) {
              combinedIncome += fieldValue1.toInt();
            }
          }
          if (fieldValue2 != null) {
            if (fieldValue2 is String) {
              combinedIncome += int.tryParse(fieldValue2) ?? 0;
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
      int combinedExpense = 0;

      // List of collection names
      List<String> collections = [
        'bharathbenzexpensedetail',
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
              combinedExpense += int.tryParse(fieldValue1) ?? 0;
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

  final Map<String, Color> expenseColors = {
    'Fuel Costs': Colors.green,
    'Lorry Service': Colors.blue,
    'Tyre': Colors.red,
    'Fast tag/Toll': Colors.orange,
    'Insurance': Colors.purple,
    'Road Taxes': Colors.brown,
    'Licensing/Permits': Colors.teal,
    'Parking': Colors.yellow,
    'Food and Lodging': Colors.cyan,
    'Communication': Colors.indigo,
    'Loan Payments': Colors.grey,
    'Fines and Penalties': Colors.lime,
    'Miscellaneous Expenses': Colors.pinkAccent,
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _datepickController.text = DateFormat('dd MMMM yyyy').format(picked);
        print('selected$selectedDate');
        //_retrievePieChartData(); // Fetch pie chart data for the selected date
      });
    }
  }

  Future<double> getSumByExpenseType(String expenseType) async {
    double totalAmount = 0.0;

    // Define the three collections
    List<String> collections = [
      'bharathbenzexpensedetail',
      'taurusexpensedetail'
    ];

    // Iterate over each collection
    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    for (String collection in collections) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('ExpenseType', isEqualTo: expenseType)
          .where('Date', isEqualTo: formattedDate)
          .get();
      // Sum the amounts for the matching expense type
      for (var doc in querySnapshot.docs) {
        // Convert the amount from String to double
        String amountString = doc['Amount'];
        //  Color color =doc['color'];
        double amount = double.tryParse(amountString) ?? 0.0;
        totalAmount += amount;
      }
    }
    return totalAmount;
  }

  Future<Map<String, double>> fetchExpenseData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, double> dataMap = {};

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('expense').get();

      for (var doc in snapshot.docs) {
        String expenseType = doc.data()['expense'];
        double totalAmount = await getSumByExpenseType(expenseType);
        dataMap[expenseType] = totalAmount;
      }
    } catch (e) {
      print('Error fetching expense types: $e');
    }
    return dataMap;
  }

  @override
  Widget build(BuildContext context) {  
    return FutureBuilder<Map<String, double>>(
      future: fetchExpenseData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        Map<String, double> dataMap = snapshot.data!;

        return Scaffold(
          appBar: CustomAppBarcolor(
            height: 175,
            title: '',
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  readOnly: true,
                  style: const TextStyle(color: white),
                  controller: _datepickController,
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: const Icon(
                          Icons.calendar_today,
                          color: white,
                        )),
                    hintText: 'Pick A Date',
                    hintStyle: const TextStyle(color: white),
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.add_circle_outline_rounded,
                              color: white,
                            ),
                            Text(
                              'Income',
                              style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              color: white,
                            ),
                            Text(
                              combineincome.toString(),
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.remove_circle_outline,
                              color: white,
                            ),
                            Text(
                              'Expense',
                              style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              color: white,
                            ),
                            Text(
                              combinedexpense.toString(),
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const Row(
                          children: [
                            RotatedBox(
                              quarterTurns: 5,
                              child: Icon(
                                Icons.pause_circle_outline_outlined,
                                color: white,
                              ),
                            ),
                            Text(
                              'Balance',
                              style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              color: white,
                            ),
                            Text(
                              (combineincome - combinedexpense).toString(),
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Expanded Row to contain Pie Chart and Legend
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    // Pie Chart
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 60, right: 16.0, left: 30.0, bottom: 20),
                        child: PieChart(
                          PieChartData(
                            sections: dataMap.entries.map((entry) {
                              Color color =
                                  expenseColors[entry.key] ?? Colors.grey;
                              return PieChartSectionData(
                                value: entry.value,
                                title: "",
                                color: color,
                                radius: 70,
                                titleStyle: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                  height: 1.5,
                                  letterSpacing: 2.0,
                                  backgroundColor: color,
                                ),
                              );
                            }).toList(),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                          ),
                        ),
                      ),
                    ),

                    // Legend on the Right
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 14, right: 16.0, left: 16.0, bottom: 0),
                        child: SingleChildScrollView(
                          // Allow legend to scroll if needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: dataMap.entries.map((entry) {
                              Color color =
                                  expenseColors[entry.key] ?? Colors.grey;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      // Wrap text in Expanded to prevent overflow
                                      child: Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow
                                            .ellipsis, // Handle overflow
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30), // Adjust spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(width: 25),
                  Text(
                    'Category wise Expense',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500, color: grey),
                  ),
                ],
              ),
              // List View with Details at the Bottom
              Expanded(
                flex: 4,
                child: ListView(
                  padding: const EdgeInsets.only(top: 10), // Adjust padding
                  children: dataMap.entries.map((entry) {
                    Color color = expenseColors[entry.key] ?? Colors.grey;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: color.withOpacity(0.8),
                        ),
                        child: ListTile(
                          title: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: white,
                            ),
                          ),
                          trailing: Text(
                            '₹${entry.value.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14, color: white),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:truckclgproject/calender/syncalenderexpense.dart';
import 'package:truckclgproject/calender/syncalenderincome.dart';
import 'package:truckclgproject/constants/colors.dart';
import 'package:truckclgproject/widgets/customcolorappbar.dart';

class Calenderslide extends StatefulWidget {
  const Calenderslide({super.key});

  @override
  State<Calenderslide> createState() => _CalenderslideState();
}

class _CalenderslideState extends State<Calenderslide> {
  var date =DateTime.now();
    String selectedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  final TextEditingController _datepickController = TextEditingController();
  int combinedexpense = 0;
  int combineincome = 0;
    late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
     incomeSum();
    expenseSum();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }




 Future incomeSum() async {
    try {
      // Initialize a combined sum variable
      int combinedIncome = 0;

      // List of collection names
      List<String> collections = [
        'bharathbenzloaddetail',
        'bharathbenzloaddetail2',
        'taurusloaddetail',
      ];

      // Field names to sum
      String field1 = 'Delivery Amount';
      String field2= 'Delivery Amount1';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBarcolor(
              height: 185,
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
                     
                      hintText:selectedDate.toString() ,
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
                SizedBox(height: 25,),
                 Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTextButton("Income ", 0),
              _buildTextButton("Expense", 1),
            ],
          ),
           SizedBox(
            height: 25,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                LoadDataFromFireStoreIncome(),
                LoadDataFromFireStore(),
               
              ],
            ),
          ),
              ],
            ),
    );
  }
    Widget _buildTextButton(String text, int page) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          page,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        decoration: BoxDecoration(

        ),
        child: AnimatedDefaultTextStyle(
          style: TextStyle(
            
            background: _currentPage == page 
          ? (Paint()..color = orange) 
          : (Paint()..color = Colors.transparent), 
            fontSize: 20,
            color: _currentPage == page ? Colors.blue : Colors.black,
            decoration: _currentPage == page
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
          duration: Duration(milliseconds: 100),
          child: Text(
            text,
            style: TextStyle(fontSize: 22, color: 
             _currentPage == page 
          ?white:orange),
          ),
          
        ),
      ),
    );
  }
}
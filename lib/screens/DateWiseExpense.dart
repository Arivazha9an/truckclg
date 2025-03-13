// ignore: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truckclgproject/constants/colors.dart';


class Datewiseexpense extends StatefulWidget implements PreferredSizeWidget {
  final double height;

  const Datewiseexpense({
    super.key,
    this.height = kToolbarHeight,
  });

  @override
  State<Datewiseexpense> createState() => _DatewiseexpenseState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _DatewiseexpenseState extends State<Datewiseexpense> {
  List<DateTime> _dates = [];
  DateTime? _selectedDate;

  Future<void> _selectMonth(BuildContext context) async {
    final initialDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      
    );

    if (selectedDate != null) {
      setState(() {
        _dates = _generateDatesForMonth(selectedDate);
        _selectedDate = null; // Reset selection on new month selection
      });
    }
  }

  List<DateTime> _generateDatesForMonth(DateTime selectedDate) {
    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDay = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    return List.generate(
        lastDay.day, (index) => firstDay.add(Duration(days: index)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.orange,
            alignment: Alignment.center,
            child: TextField(
              style: const TextStyle(color: white),
              readOnly: true,
              controller: TextEditingController(
                text: _selectedDate != null
                    ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                    : '',
              ),
              decoration: InputDecoration(
                prefixIcon: GestureDetector(
                    onTap: () => _selectMonth(context),
                    child: const Icon(
                      Icons.calendar_today,
                      color: white,
                    )),
                hintText: 'Date',
                hintStyle: const TextStyle(color: white),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            color: lightBrown,
            height: 70,
            child: Stack(fit: StackFit.loose, children: [
              Container(
                height: 45, // Set a fixed height for the date container
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Horizontal scroll direction
                  itemCount: _dates.length,
                  itemBuilder: (context, index) {
                    final date = _dates[index];
                    final isSelected = _selectedDate != null &&
                        _selectedDate!.day == date.day &&
                        _selectedDate!.month == date.month &&
                        _selectedDate!.year == date.year;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                width: 30, // Width for each date item
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  color: isSelected ? orange : white,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                child: Text(
                                  DateFormat('dd').format(
                                      date), // Display only the date (day)
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bharath BENZ V1 -', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      width: 30,
                    ),
                    Text('10', style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bharath BENZ V2 -',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('10', style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Taurus          -', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      width: 30,
                    ),
                    Text('10', style: TextStyle(fontSize: 16))
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.small(
                  onPressed: () {},
                  backgroundColor: orange,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: white,
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

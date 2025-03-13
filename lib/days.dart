import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerExample extends StatefulWidget {
  @override
  _DatePickerExampleState createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  List<DateTime> _datesInMonth = [];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      _generateDatesInMonth(selectedDate);
    }
  }

  void _generateDatesInMonth(DateTime selectedDate) {
    int year = selectedDate.year;
    int month = selectedDate.month;

    // Get the number of days in the selected month
    int daysInMonth = DateTime(year, month + 1, 0).day;

    // Generate all dates in the selected month
    List<DateTime> dates = [];
    for (int i = 0; i < daysInMonth; i++) {
      dates.add(DateTime(year, month, i + 1));
    }

    setState(() {
      _datesInMonth = dates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker Example'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Date'),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _datesInMonth.length,
              itemBuilder: (context, index) {
                DateTime date = _datesInMonth[index];
                return Container(
                  width: 50,
                  height: 100,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

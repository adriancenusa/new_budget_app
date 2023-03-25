import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class MonthYearNavigator extends StatefulWidget {
  @override
  _MonthYearNavigatorState createState() => _MonthYearNavigatorState();
}

class _MonthYearNavigatorState extends State<MonthYearNavigator> {
  DateTime _selectedDate = DateTime.now();

  void _prevMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    });
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        "${DateFormat.MMMM().format(_selectedDate)} ${_selectedDate.year}";
    final bool isCurrentMonth =
        DateTime.now().year == _selectedDate.year &&
            DateTime.now().month == _selectedDate.month;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: _prevMonth,
          ),
          GestureDetector(
            onTap: () => _selectMonth(context),
            child: Text(
              formattedDate,
              style: TextStyle(fontSize: 24),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed:  isCurrentMonth ? null : _nextMonth,
          ),
        ],
      ),
    );
  }
}
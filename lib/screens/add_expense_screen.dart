import 'package:flutter/material.dart';

import '../models/category.dart';


class AddExpenseScreen extends StatefulWidget {
  final Category category;

  AddExpenseScreen({required this.category});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;

  @override
  void initState() {
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _selectedDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${widget.category.name}'),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            // Add more input fields or widgets for other expense properties as needed
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle saving the new expense here
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

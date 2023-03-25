import 'package:flutter/material.dart';


import '../models/category.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  EditExpenseScreen({required this.expense});

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late Category _selectedCategory;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedDate = widget.expense.date;
    _selectedCategory = Category.sampleData().firstWhere((category) => category.id == widget.expense.categoryId);
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
        title: Text('Edit Expense'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Handle saving the edited expense here
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    );
  }
}

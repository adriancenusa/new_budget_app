import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/expense.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class RecurringExpensesScreen extends StatefulWidget {
  @override
  _RecurringExpensesScreenState createState() => _RecurringExpensesScreenState();
}

class _RecurringExpensesScreenState extends State<RecurringExpensesScreen> {
  List<Expense> recurringExpenses = []; // Replace this with your actual data from the database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recurring Expenses'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: recurringExpenses.length,
        itemBuilder: (context, index) {
          Expense expense = recurringExpenses[index];
          return ListTile(
            title: Text(expense.title),
            subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Add your code here to delete the recurring expense from the database
                setState(() {
                  recurringExpenses.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Add your code here to create a new recurring expense and add it to the database
          // Refresh the list of recurring expenses after adding the new one
          setState(() {
            // Update the recurringExpenses list with the new expense
          });
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}

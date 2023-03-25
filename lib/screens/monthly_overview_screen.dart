import 'package:flutter/material.dart';
import 'package:new_budget_app/models/category.dart';
import 'package:new_budget_app/models/expense.dart';
import 'package:new_budget_app/widgets/budget_category_pie_chart.dart';


class OverviewScreen extends StatefulWidget {
  final List<Category> categories = Category.sampleData();
  final List<Expense> expenses= Expense.sampleData();

  OverviewScreen();

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    // Calculate monthly expenses by category
    Map<String, double> expensesByCategory = {};
    widget.categories.forEach((category) {
      double categoryExpenses = widget.expenses
          .where((expense) =>
      expense.categoryId == category.id &&
          expense.date.month == DateTime.now().month)
          .fold(0, (sum, expense) => sum + expense.amount);
      expensesByCategory[category.name] = categoryExpenses;
    });

    // Calculate top expenses by category
    Map<String, List<Expense>> topExpensesByCategory = {};
    widget.categories.forEach((category) {
      List<Expense> categoryExpenses = widget.expenses
          .where((expense) => expense.categoryId == category.id)
          .toList();
      categoryExpenses.sort((a, b) => b.amount.compareTo(a.amount));
      topExpensesByCategory[category.name] =
          categoryExpenses.take(3).toList();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'Expenses by Category',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  BudgetCategoryPieChart(categories: widget.categories, expenses: widget.expenses),
                  SizedBox(height: 32.0),
                  Text(
                    'Top Expenses by Category',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) {
                        Category category = widget.categories[index];
                        List<Expense> categoryExpenses =
                            topExpensesByCategory[category.name] ?? [];


                          return SizedBox.shrink();
                        

                        // return TopExpensesByCategory(
                        //   category: category,
                        //   expenses: categoryExpenses,
                        // );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:new_budget_app/provider/user_provider.dart';
import 'package:new_budget_app/utils/category_service.dart';
import 'package:new_budget_app/utils/expenses_service.dart';
import 'package:new_budget_app/widgets/budget_available_spent_pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../widgets/budget_category_pie_chart.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/month_picker.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   List<Category> _categories = [];
   List<Expense> _expenses =[] ;
   UserProvider? _myProvider;
   bool _setupCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _myProvider = Provider.of<UserProvider>(context, listen: false);
      _initApp(_myProvider?.user);
    });

  }

  Future<void> _initApp(User? user) async {
    if(user == null) {
      return;
    }
    await _loadData(user.uid);
  }

  Future<void> _loadData(String userId) async {
    var categoryList = await CategoryService(userId).getCategories();
    var expenseList = await ExpenseService(userId).getExpenses();
    setState(() {
      print("categoryList");
      print(categoryList);
      _categories =  categoryList;
      print("expenseList");
      print(expenseList);
      _expenses = expenseList;
    });
  }


  @override
  Widget build(BuildContext context) {
    double totalBudget =
        _categories.fold(0, (sum, category) => sum + category.budget);
    double spentAmount = _expenses
        .where((expense) => expense.date.month == DateTime.now().month)
        .fold(0, (sum, expense) => sum + expense.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget App'),
      ),
      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MonthYearNavigator(),
                    BudgetPieChart(
                      totalBudget: totalBudget,
                      spentAmount: spentAmount,
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        Category category = _categories[index];

                        List<Expense> categoryExpenses = _expenses
                            .where(
                                (expense) => expense.categoryId == category.id)
                            .toList();

                        double totalExpenses = categoryExpenses.fold(
                            0.0, (sum, expense) => sum + expense.amount);
                        double remainingBudget =
                            category.budget - totalExpenses;
                        double percentage =
                            1 - (remainingBudget / category.budget);

                        return ExpansionTile(
                          title: Row(
                            children: [
                              if (percentage > 1)  Icon(Icons.warning, color: Colors.red),
                              if (percentage > 1)  SizedBox(width: 4),
                              Text(category.name),

                            ],
                          ),
                          subtitle: Stack(
                            children: [
                              LinearProgressIndicator(
                                value: percentage,
                                // Set the fill-in bar value (0 to 1)
                                minHeight: 15,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    percentage > 1 ? Colors.red : Colors.blue),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: FractionallySizedBox(
                                    widthFactor: 1,
                                    child: Text(
                                      '${totalExpenses.toStringAsFixed(2)}\/${category.budget.toStringAsFixed(2)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          leading: Icon(category.icon),
                          children: categoryExpenses.map<Widget>((expense) {
                            return ListTile(
                              title: Text(expense.title),
                              subtitle: Text(
                                  '${expense.date.day}/${expense.date.month}/${expense.date.year}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      '\$${expense.amount.toStringAsFixed(2)}'),
                                  SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditExpenseScreen(
                                                  expense: expense),
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.edit, size: 20),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ]),
            ),
          ),
        ],
      ),
      floatingActionButton: buildCircleSpeedDial(),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  SpeedDial buildCircleSpeedDial() {
    final double semiCircleRadius = MediaQuery.of(context).size.width /
        (2 * (_categories.length + 1));

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      buttonSize: new Size(56, 56),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 8.0,

      children: _categories.map((category) {
        final int index = _categories.indexOf(category);
        final double angle = (index * 2 * pi) / _categories.length;

        return SpeedDialChild(
          child: Icon(category.icon),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(category: category),
              ),
            );
          },
          visible: true,
          // curve: Curves.bounceIn,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          // heroTag: category.id,
          // transform: Matrix4.translationValues(
          //     semiCircleRadius * cos(angle), semiCircleRadius * sin(angle), 0.0)
          //   ..rotateZ(angle - pi / 2),
        );
      }).toList(),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      buttonSize: new Size(56, 56),
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 8.0,
      children: _categories.map((category) {
        return SpeedDialChild(
          child: Icon(category.icon),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(category: category),
              ),
            );
          },
        );
      }).toList(),
    );
  }

}

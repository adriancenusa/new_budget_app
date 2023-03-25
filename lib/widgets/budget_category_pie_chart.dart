import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/category.dart';
import '../models/expense.dart';

class BudgetCategoryPieChart extends StatelessWidget {

  final List<Category> categories;
  final List<Expense> expenses;

  BudgetCategoryPieChart({
    required this.categories,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {

    List<PieChartData> data = categories.map((category) {
      double spentInCategory = expenses
          .where((expense) => expense.categoryId == category.id)
          .fold(0, (sum, expense) => sum + expense.amount);
      return PieChartData(
        category.name,
        spentInCategory,
        Colors.primaries[categories.indexOf(category)],
      );
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 200,
        child: SfCircularChart(
          series: <CircularSeries>[
            PieSeries<PieChartData, String>(
              dataSource: data,
              pointColorMapper: (datum, _) => datum.color,
              xValueMapper: (datum, _) => datum.category,
              yValueMapper: (datum, _) => datum.amount,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 10),
                labelPosition: ChartDataLabelPosition.outside
              ),
              dataLabelMapper: (datum, _) => datum.category
            )
          ],
        ),
      ),
    );
  }
}

class PieChartData {
  final String category;
  final double amount;
  final Color color;

  PieChartData(this.category, this.amount, this.color);
}

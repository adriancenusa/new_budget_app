import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetPieChart extends StatelessWidget {
  final double totalBudget;
  final double spentAmount;

  BudgetPieChart({required this.totalBudget, required this.spentAmount});

  @override
  Widget build(BuildContext context) {
    double remainingBudget = totalBudget - spentAmount;

    List<_ChartData> chartData = [
      _ChartData('Spent', spentAmount, Colors.red),
      _ChartData('Remaining', remainingBudget, Colors.green),
    ];

    return SfCircularChart(
      legend: Legend(isVisible: true),
      series: <CircularSeries<_ChartData, String>>[
        PieSeries<_ChartData, String>(
            dataSource: chartData,
            pointColorMapper: (_ChartData data, _) => data.color,
            xValueMapper: (_ChartData data, _) => data.label,
            yValueMapper: (_ChartData data, _) => data.value,
            dataLabelMapper: (_ChartData data, _) =>
                data.value.toStringAsFixed(2),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              labelPosition: ChartDataLabelPosition.inside,
            ),
            explode: true,
            explodeAll: true)
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.label, this.value, this.color);

  final Color color;
  final String label;
  final double value;
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String categoryId;

  Expense({required this.id, required this.title, required this.amount, required this.date, required this.categoryId});


  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      title: data['title'],
      categoryId: data['categoryId'],
      date: (data['date'] as Timestamp).toDate(),
      amount: data['amount'].toDouble(),

    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'amount': amount,
    };
  }


  static List<Expense> sampleData() {
    Random random = Random();
    DateTime now = DateTime.now();
    return List<Expense>.generate(20, (index) {
      var categoryNumber = (random.nextInt(5) + 1);
      String categoryId = categoryNumber.toString();
      double amount = random.nextDouble() * 100;
      DateTime date = now.subtract(Duration(days: random.nextInt(30)));
      return Expense(
        id: index.toString(),
        title: 'Expense $index',
        date: date,
        amount: amount,
        categoryId: categoryId,
      );
    });
  }
}
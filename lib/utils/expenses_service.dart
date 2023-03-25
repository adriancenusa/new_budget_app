import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_budget_app/models/expense.dart';

class ExpenseService {

  late final CollectionReference expensesCollection;
  final String userId;

  ExpenseService(this.userId){
    expensesCollection = FirebaseFirestore.instance.collection('users/$userId/expenses');
  }


  Future<List<Expense>> getExpenses() async {
    QuerySnapshot snapshot = await expensesCollection.get();
    return snapshot.docs.map((doc) {
      return Expense.fromFirestore(doc);
    }).toList();
  }

  Future<Expense> addExpense(Expense expense) async {
    DocumentReference ref =
        await expensesCollection.add(expense.toFirestore());
    return Expense(
        id: ref.id,
        title: expense.title,
        amount: expense.amount,
        date: expense.date,
        categoryId: expense.categoryId);
  }

  Future<void> updateExpense(Expense expense) async {
    await expensesCollection
        .doc(expense.id)
        .update(expense.toFirestore());
  }

  Future<void> deleteExpense(String id) async {
    await expensesCollection.doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_budget_app/provider/user_provider.dart';

import '../models/category.dart';
import '../models/expense.dart';



class UserService {
  Future<bool> checkIfUserSetupIsCompleted(User user) async {
    var doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot snapshot = await doc.get();
    if (snapshot.exists) {
      return snapshot.get("setupCompleted");
    }

    doc.set({'name': user.displayName, 'setupCompleted': false});
    return false;
  }


   Future<void> completeSetup({
      required String userId,
      required List<Category> categories,
      required Expense dummyExpense,
    }) async {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final categoriesRef = userRef.collection('categories');
      final expensesRef = userRef.collection('expenses');

      return FirebaseFirestore.instance.runTransaction((transaction) async {
        // Set 'setupCompleted' field to true for the user
        transaction.update(userRef, {'setupCompleted': true});

        // Add categories
        for (final category in categories) {
          final categoryDoc = categoriesRef.doc(category.id);
          transaction.set(categoryDoc, category.toFirestore());
        }

        // Add dummy expense
        final expenseDoc = expensesRef.doc();
        transaction.set(expenseDoc, dummyExpense.toFirestore());
      });
    }
  }

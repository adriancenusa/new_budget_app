import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_budget_app/provider/user_provider.dart';

Future<bool> checkIfUserSetupIsCompleted(User user) async {

  var doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  DocumentSnapshot snapshot = await doc.get();
  if(snapshot.exists) {
    return snapshot.get("setupCompleted");
  }

  doc.set({'name': user.displayName, 'setupCompleted': false});
  return false;

}
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  late final CollectionReference categoriesCollection;
  final String userId;

  CategoryService(this.userId){
    categoriesCollection = FirebaseFirestore.instance.collection('users/$userId/categories');
  }


  Future<List<Category>> getCategories() async {
    QuerySnapshot snapshot = await categoriesCollection.get();
    return snapshot.docs.map((doc) {
      return Category.fromFirestore(doc);
    }).toList();
  }



  Future<Category> addCategory(Category category) async {
    var documentReference = await categoriesCollection.add(category.toFirestore());
    return Category(id: documentReference.id, name: category.name, icon: category.icon, budget: category.budget);
  }

  Future<void> updateCategory(Category category) async {
    await categoriesCollection.doc(category.id).update(category.toFirestore());
  }

  Future<void> deleteCategory(String categoryId) async {
    await categoriesCollection.doc(categoryId).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  final String id;
  String name;
  final IconData icon;
  final double budget;

  Category({required this.id, required this.name, required this.icon, required this.budget});

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'],
      icon: IconData(data['icon'], fontFamily: 'MaterialIcons'),
      budget: data['budget'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'budget': budget,
    };
  }

  static List<Category> sampleData() {
    return [
      Category(id: "1", name: 'Groceries', icon: Icons.shopping_cart, budget: 300),
      Category(id: "2", name: 'Transportation', icon: Icons.directions_car, budget: 150),
      Category(id: "3", name: 'Entertainment', icon: Icons.movie, budget: 200),
      Category(id: "4", name: 'Utilities', icon: Icons.flash_on, budget: 100),
      Category(id: "5", name: 'Eating Out', icon: Icons.restaurant, budget: 250),
    ];
  }
}
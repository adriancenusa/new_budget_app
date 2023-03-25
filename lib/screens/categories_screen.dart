import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = Category.sampleData(); // Replace this with your actual data from the database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(categories[index].icon),
            title: Text(categories[index].name),
            subtitle: Text('Budget: \$${categories[index].budget}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Add your code here to delete the category from the database
                setState(() {
                  categories.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Add your code here to create a new category and add it to the database
          // Refresh the list of categories after adding the new one
          setState(() {
            // Update the categories list with the new category
          });
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}

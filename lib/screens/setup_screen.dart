import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Category {
  String name;
  double budget;
  IconData icon;

  Category({required this.name, required this.budget, required this.icon});
}

class CategoryScreen extends StatelessWidget {

  void _addCategory(BuildContext context) {
    Provider.of<CategoryModel>(context).addCategory(
      Category(
        name: 'New Category',
        budget: 0.0,
        icon: Icons.add_circle_outline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Categories'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Set up your budget categories. You can edit the default categories or add your own.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            CategoryGrid(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _addCategory(context),
                  child: Text('Add Category'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Redirect to the main page
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryModel>(
      builder: (context, model, child) {
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: model.categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: CategoryCard(category: model.categories[index]),
              );
            },
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isEditing = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category.name;
    _budgetController.text = widget.category.budget.toString();
  }

  void _saveChanges() {
    setState(() {
      widget.category.name = _nameController.text;
      widget.category.budget = double.parse(_budgetController.text);
      _isEditing = false;
    });
  }

  void _deleteCategory() {
    Provider.of<CategoryModel>(context, listen: false)
        .removeCategory(widget.category);
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isEditing
                    ? Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    onEditingComplete: _saveChanges,
                    decoration: InputDecoration(
                      hintText: "Category Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
                    : Expanded(
                  child: Text(
                    widget.category.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    _isEditing
                        ? IconButton(
                      onPressed: _deleteCategory,
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    )
                        : Container(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      icon: Icon(_isEditing ? Icons.check : Icons.edit),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isEditing
                    ? InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Select Icon"),
                          // You can create a custom icon picker here
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(widget.category.icon, size: 36),
                  ),
                )
                    : Icon(widget.category.icon, size: 36),
                SizedBox(width: 8.0),
                _isEditing
                    ? Expanded(
                  child: TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    onEditingComplete: _saveChanges,
                    decoration: InputDecoration(
                      hintText: "Budget",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
                    : Expanded(
                  child: Text(
                    'Budget: \$${widget.category.budget}',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class CategoryModel extends ChangeNotifier {
  List<Category> _categories = [
    Category(name: 'Shopping', budget: 0.0, icon: Icons.shopping_cart),
    Category(name: 'Leisure', budget: 0.0, icon: Icons.sports_soccer),
  ];

  List<Category> get categories => _categories;

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(Category category) {
    _categories.remove(category);
    notifyListeners();
  }
}

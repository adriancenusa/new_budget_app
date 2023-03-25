import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Category {
  String name;
  double budget;
  IconData icon;

  Category({required this.name, required this.budget, required this.icon});
}

class CategoryScreen extends StatelessWidget {
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
                'Create a list of categories. Set the name, budget, and select an icon for each category.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            CategoryGrid(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              showModalBottomSheet(
                context: context,
                builder: (context) => CategoryForm(),
              ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class CategoryForm extends StatefulWidget {
  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();

  IconData _selectedIcon = Icons.shopping_cart;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
    child: Form(
    key: _formKey,
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    TextFormField(
    controller: _nameController,
    decoration: InputDecoration(labelText: 'Category Name'),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter a category name';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _budgetController,
    decoration: InputDecoration(labelText: 'Budget'),
    keyboardType: TextInputType.number,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter a budget';
    }
    return null;
    },
    ),
    DropdownButton<IconData>(
    value: _selectedIcon,
    onChanged: (IconData? newValue) {
    setState(() {
    _selectedIcon = newValue!;
    });
    },
    items: [
    DropdownMenuItem<IconData>(
    value: Icons.shopping_cart,
    child: Icon(Icons.shopping_cart),
    ),
    DropdownMenuItem<IconData>(
    value: Icons.sports_soccer,
    child: Icon(Icons.sports_soccer),
    ),
    // Add more icons as needed
    ],
    ),
    ElevatedButton(
    onPressed: () {
    if (_formKey.currentState!.validate()) {
    context.read<CategoryModel>().addCategory(
    Category(
    name: _nameController.text,
    budget: double.parse(_budgetController.text),
      icon: _selectedIcon,
    ),
    );
    _nameController.clear();
    _budgetController.clear();
    Navigator.pop(context);
    }
    },
      child: Text('Add Category'),
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
          child: GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: model.categories.length,
            itemBuilder: (context, index) {
              Category category = model.categories[index];
              return Card(
                elevation: 4.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.icon,
                      size: 48,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      category.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 4.0),
                    Text('Budget: \$${category.budget}'),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CategoryModel with ChangeNotifier {
  List<Category> _categories = [
    Category(name: 'Shopping', budget: 0.0, icon: Icons.shopping_cart),
    Category(name: 'Leisure', budget: 0.0, icon: Icons.sports_soccer),
  ];

  List<Category> get categories => _categories;

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }
}
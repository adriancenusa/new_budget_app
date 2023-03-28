import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_budget_app/models/expense.dart';
import 'package:new_budget_app/utils/user_service.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../provider/user_provider.dart';
import '../utils/category_service.dart';
import 'home_screen.dart';

final GlobalKey<AnimatedListState> _listKey = GlobalKey();

void _addCategory(BuildContext context) {
  var category = Category(
    id: UniqueKey().toString(),
    name: 'New Category',
    budget: 0.0,
    icon: Icons.add_circle_outline,
  );
  var provider = Provider.of<CategoryModel>(context, listen: false);
  provider.addCategory(category);
  _listKey.currentState?.insertItem(0, duration: Duration(milliseconds: 300));
}

Widget _buildDeleteAnimation(
    BuildContext context, Animation<double> animation) {
  return SizeTransition(
    sizeFactor: animation,
    child: Container(
      height: 60,
      color: Colors.red,
    ),
  );
}

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories =
        context.select((CategoryModel model) => model.categories);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Categories'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              var uid =
                  Provider.of<UserProvider>(context, listen: false).user?.uid;
              var expense = Expense(id: UniqueKey().toString(), title: "exampleExpense", amount: 0.1, date: DateTime.now(), categoryId: categories[0].id);
              UserService().completeSetup(userId: uid!, categories: categories, dummyExpense: expense);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Text(
              'Next',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Expanded(
              child: AnimatedList(
            key: _listKey,
            initialItemCount: categories.length,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return _buildAnimatedCategoryCard(
                  categories[index], index, animation);
            },
          )),
          SizedBox(height: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCategory(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAnimatedCategoryCard(
      Category category, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: CategoryCard(
        key: ValueKey(category.id),
        category: category,
        listKey: _listKey,
        index: index,
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final Category category;
  final GlobalKey<AnimatedListState> listKey;
  final int index;

  CategoryCard({
    required Key key,
    required this.category,
    required this.listKey,
    required this.index,
  }) : super(key: key);

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
    widget.category.name == 'New Category'
        ? _isEditing = true
        : _isEditing = false;
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
                            onPressed: () {
                              Provider.of<CategoryModel>(context, listen: false)
                                  .removeCategory(widget.category);
                              widget.listKey.currentState?.removeItem(
                                widget.index,
                                (BuildContext context,
                                    Animation<double> animation) {
                                  return _buildDeleteAnimation(
                                      context, animation);
                                },
                              );
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          )
                        : Container(),
                    IconButton(
                      onPressed: () {
                        _isEditing
                            ? _saveChanges()
                            : setState(() {
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
  final List<Category> _categories = [
    Category(
        id: UniqueKey().toString(),
        name: 'Shopping',
        budget: 0.0,
        icon: Icons.shopping_cart),
    Category(
        id: UniqueKey().toString(),
        name: 'Leisure',
        budget: 0.0,
        icon: Icons.sports_soccer),
  ];

  List<Category> get categories => _categories;

  void addCategory(Category category) {
    _categories.insert(0, category);
    notifyListeners();
  }

  void removeCategory(Category category) {
    _categories.remove(category);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final GlobalKey<AnimatedListState> _listKey = GlobalKey();

void _addCategory(BuildContext context) {
  var category = Category(
    name: 'New Category',
    budget: 0.0,
    icon: Icons.add_circle_outline,
  );
  var provider = Provider.of<CategoryModel>(context, listen: false);
  provider.addCategory(category);
  _listKey.currentState?.insertItem(0, duration: Duration(milliseconds: 300));
}

void _deleteCategory(BuildContext context, Category category) {
  var provider = Provider.of<CategoryModel>(context, listen: false);

  _listKey.currentState?.removeItem(
    provider.categories.indexOf(category),
    (BuildContext context, Animation<double> animation) {
      return _buildDeleteAnimation(context, animation);
    },
  );
  provider.removeCategory(category);
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

class Category {
  String id = UniqueKey().toString();
  String name;
  double budget;
  IconData icon;

  Category({required this.name, required this.budget, required this.icon});
}

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories =
        context.select((CategoryModel model) => model.categories);

    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<CategoryModel>(context, listen: false).addCategory(
            Category(
              name: 'New Category',
              budget: 0.0,
              icon: Icons.add_circle_outline,
            ),
          );
        },
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
  List<Category> _categories = [
    Category(name: 'Shopping', budget: 0.0, icon: Icons.shopping_cart),
    Category(name: 'Leisure', budget: 0.0, icon: Icons.sports_soccer),
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

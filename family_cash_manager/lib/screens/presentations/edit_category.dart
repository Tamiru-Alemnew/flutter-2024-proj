import 'package:family_cash_manager/blocs/category_bloc.dart';
import 'package:family_cash_manager/blocs/user_bloc.dart';
import 'package:family_cash_manager/widgets/presentation/common_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategoryPage extends StatelessWidget {
  const EditCategoryPage({Key? key}) : super(key: key);

Future<String> getUserRole(BuildContext context) async {
  final userBloc = BlocProvider.of<UserBloc>(context);
  final userState = userBloc.state;
  if (userState is UserAuthenticated) {
    return userState.user.role;
  }else{
    return '';
  }
}


@override
Widget build(BuildContext context) {
  return FutureBuilder<String>(
    future: getUserRole(context),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.data != 'parent') {
         WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('You must be a parent to edit categories')),
              );
            });
            
        Navigator.pop(context);
        return Container();

      } else {
    return Scaffold(
      drawer: const CommonSideBar(),
      appBar: AppBar(
        title: const Text('Family Cash Manager'),
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Categories loaded')),
            );
          } else if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: const EditExpense(),
      ),
    );
  }
}
);
}
}

/// The EditExpense class represents the form for editing an expense category in the Family Cash Manager app.
/// It extends StatefulWidget, indicating that the UI of this form can change dynamically based on user interactions
/// and state updates. The class overrides the createState() method to create an instance of _EditExpenseState,
/// which manages the state of the EditExpense form.
class EditExpense extends StatefulWidget {
  const EditExpense({Key? key}) : super(key: key);

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

/// The _EditExpenseState class represents the state of the EditExpense form in the Family Cash Manager app.
/// It manages the dynamic data and user interactions for editing expense categories. This class extends the
/// State class and overrides the build() method to define the UI layout and functionality of the EditExpense form.
/// It includes a list of categories, a text field for adding new categories, and buttons for adding categories and
/// completing the editing process. The state is updated using the setState() method, reflecting changes made by the user.
class _EditExpenseState extends State<EditExpense> {
  TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context, listen: false).add(GetCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'Edit Category',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add categories to help your family members track their expenses",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CategoryLoaded) {
                    return Column(
                      children: state.categories.map((category) {
                        return CategoryItem(
                          category: category,
                          onEdit: (newName) {
                            BlocProvider.of<CategoryBloc>(context,
                                    listen: false)
                                .add(
                              UpdateCategories(
                                id: category['id'] ?? '',
                                newName: newName,
                              ),
                            );
                          },
                          onDelete: () {
                            BlocProvider.of<CategoryBloc>(context,
                                    listen: false)
                                .add(
                              DeleteCategories(id: category['id'] ?? ''),
                            );
                          },
                        );
                      }).toList(),
                    );
                  } else if (state is CategoryError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text("No categories available"));
                  }
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add new category",
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 36, 120, 109))),
                    onPressed: () {
                      String newCategory = _categoryController.text.trim();
                      if (newCategory.isNotEmpty) {
                        BlocProvider.of<CategoryBloc>(context, listen: false)
                            .add(
                          AddCategories(name: newCategory),
                        );
                        _categoryController.clear();
                      }
                    },
                    child: Text(
                      "Add Category",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 36, 120, 109))),
                    onPressed: () {
                      print("Done");
                    },
                    child: Text("Done", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }
}



class CategoryItem extends StatefulWidget {
  final Map category;
  final Function(String)? onEdit;
  final VoidCallback? onDelete;

  const CategoryItem({
    Key? key,
    required this.category,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

/// The _CategoryItemState class represents the state of a CategoryItem widget in the Family Cash Manager app.
/// It manages the dynamic data and user interactions for displaying and interacting with an expense category item.
/// This class extends the State class and overrides the build() method to define the UI layout and functionality
/// of the CategoryItem. It includes a card widget that displays the category name and provides options for editing
/// and deleting the category. The state is updated using the setState() method, reflecting changes made by the user.

class _CategoryItemState extends State<CategoryItem> {
  bool _isEditing = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.category[widget.category['id']]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _isEditing
                  ? TextField(
                      controller: _editingController,
                      autofocus: true,
                      onEditingComplete: () {
                        _submitEdit();
                      },
                      onSubmitted: (_) {
                        _submitEdit();
                      },
                    )
                  : Text(
                      widget.category[widget.category['id']],
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  onPressed: () {
                    if (widget.onDelete != null) {
                      widget.onDelete!();
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitEdit() {
    setState(() {
      _isEditing = false;
    });
    if (widget.onEdit != null) {
      widget.onEdit!(_editingController.text.trim());
    }
    BlocProvider.of<CategoryBloc>(context, listen: false).add(UpdateCategories(id: widget.category["id"], newName: _editingController.text.trim()));
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }
}

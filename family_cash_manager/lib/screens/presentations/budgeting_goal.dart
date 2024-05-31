import 'package:family_cash_manager/widgets/presentation/common_sidebar.dart';
import 'package:flutter/material.dart';

// The BudgetAndGoal class represents the main screen of the Family Cash Manager app,
// displaying the budget and goals. This class extends StatelessWidget and defines the

class BudgetAndGoal extends StatelessWidget {
  const BudgetAndGoal({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CommonSideBar(),
      appBar: AppBar(
        title: const Text('Family Cash Manager'),
      ),
      body: BudgetPage(),
    );
  }
}

/// The BudgetPage class represents the page that displays the budget details and allows
/// users to manage their finances. It extends StatefulWidget, indicating that the UI of
/// this page can change dynamically based on user interactions and state updates. The
/// class overrides the createState() method to create an instance of _BudgetPageState,
/// which manages the state of the BudgetPage.
class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

/// The _BudgetPageState class represents the state of the BudgetPage widget. It manages
/// the dynamic data and user interactions for budgeting and goal setting. This class
/// extends the State class and overrides the build() method to define the UI layout
/// and functionality of the BudgetPage. It includes sliders, input fields, and buttons
/// for managing the overall family budget, child spending limit, and specific goals.
/// The state is updated using the setState() method, reflecting changes made by the user.

class _BudgetPageState extends State<BudgetPage> {
  double overallBudget = 5000.0;
  double childSpendingLimit = 1000.0;
  Map<String, double> specificGoals = {
    'Entertainment': 1000.0,
    'Food': 1500.0,
    'Clothing': 500.0,
    'Transportation': 1000.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budgeting & Goal Setting',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Family Budget Goal:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '\$${overallBudget.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editOverallBudget();
                  },
                ),
              ],
            ),
            Slider(
              value: overallBudget,
              min: 1000.0,
              max: 10000.0,
              activeColor: const Color.fromARGB(255, 32, 31, 31),
              onChanged: (value) {
                setState(() {
                  overallBudget = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Child Spending Limit:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '\$${childSpendingLimit.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editChildSpendingLimit();
                  },
                ),
              ],
            ),
            Slider(
              value: childSpendingLimit,
              min: 100.0,
              max: 2000.0,
              activeColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  childSpendingLimit = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Specific Goals:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: specificGoals.length,
                itemBuilder: (BuildContext context, int index) {
                  String category = specificGoals.keys.elementAt(index);
                  return _buildGoalItem(category, specificGoals[category]);
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addNewGoal();
              },
              child: Text('Add New Goal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String title, double? currentValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  specificGoals.remove(title);
                });
              },
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Text(
              '\$${currentValue?.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editGoal(title, currentValue);
              },
            ),
          ],
        ),
        Slider(
          value: currentValue ?? 0.0,
          min: 0.0,
          max: 2000.0,
          activeColor: Colors.green,
          onChanged: (value) {
            setState(() {
              specificGoals[title] = value;
            });
          },
        ),
      ],
    );
  }

  void _editOverallBudget() {
    _showEditDialog(
      title: 'Edit Overall Budget',
      initialValue: overallBudget,
      onSave: (value) {
        setState(() {
          overallBudget = value;
        });
      },
    );
  }

  void _editChildSpendingLimit() {
    _showEditDialog(
      title: 'Edit Child Spending Limit',
      initialValue: childSpendingLimit,
      onSave: (value) {
        setState(() {
          childSpendingLimit = value;
        });
      },
    );
  }

  void _editGoal(String title, double? currentValue) {
    _showEditDialog(
      title: 'Edit $title Goal',
      initialValue: currentValue ?? 0.0,
      onSave: (value) {
        setState(() {
          specificGoals[title] = value;
        });
      },
    );
  }

  void _addNewGoal() {
    _showAddDialog(
      onSave: (title, value) {
        setState(() {
          specificGoals[title] = value;
        });
      },
    );
  }

  void _showEditDialog({
    required String title,
    required double initialValue,
    required Function(double) onSave,
  }) {
    TextEditingController controller =
        TextEditingController(text: initialValue.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Value'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double newValue = double.parse(controller.text);
                onSave(newValue);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog({
    required Function(String, double) onSave,
  }) {
    TextEditingController titleController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Value'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newTitle = titleController.text;
                double newValue = double.parse(valueController.text);
                onSave(newTitle, newValue);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

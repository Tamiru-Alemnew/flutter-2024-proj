import 'package:family_cash_manager/blocs/expense_bloc.dart';
import 'package:family_cash_manager/blocs/user_bloc.dart';
import 'package:family_cash_manager/blocs/category_bloc.dart';
import 'package:family_cash_manager/widgets/presentation/common_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditExpensePage extends StatelessWidget {
  const EditExpensePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CommonSideBar(),
      appBar: AppBar(
        title: const Text('Family Cash Manager'),
      ),
      body: const ExpensePage(),
    );
  }
}

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

/// The _ExpensePageState class represents the state of the ExpensePage in the Family Cash Manager app.
/// It manages the dynamic data and user interactions for adding and displaying expenses.
/// This class extends the State class and overrides the build() method to define the UI layout and functionality
/// of the ExpensePage. It includes form elements for entering the category, amount, and date of an expense,
/// as well as a button to add the expense. The state is updated using the setState() method, reflecting changes
/// made by the user. The list of expenses is displayed in a DataTable widget, showing the category, amount, and date
/// of each expense.

class _ExpensePageState extends State<ExpensePage> {
  List<Expense> expenses = [];
  DateTime? _selectedDate;
  TextEditingController amountController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategories());
    context.read<ExpenseBloc>().add(GetExpenses());
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ExpenseLoaded) {
          expenses = state.expenses.map((e) => Expense.fromJson(e)).toList();
        }

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            title: Text(
              'Add Expenses',
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is CategoryLoaded) {
                      if (_selectedCategory == null &&
                          state.categories.isNotEmpty) {
                        final idd = state.categories[0]["id"];
                        _selectedCategory = state.categories[0][idd];
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            hint: Text('Select Category'),
                            items: state.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category[category["id"]],
                                child: Text(category[category["id"]]),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            },
                          ),
                        ],
                      );
                    } else {
                      return Text('Failed to load categories');
                    }
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Amount',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter amount',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                DateSelector(
                  onDateSelected: (DateTime date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                      alignment: Alignment.center,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 36, 120, 109)),
                    ),
                    onPressed: () {
                      if (amountController.text.isNotEmpty &&
                          _selectedCategory != null) {
                        final userBloc = BlocProvider.of<UserBloc>(context);
                        final userState = userBloc.state;

                        if (userState is UserAuthenticated) {
                          final userId = userState.user.userId;
                          BlocProvider.of<ExpenseBloc>(context).add(AddExpense(
                            userId: userId,
                            category: _selectedCategory!,
                            amount: amountController.text,
                            date: _selectedDate?.toString() ??
                                DateTime.now().toString(),
                          ));
                        }

                        amountController.clear();
                        _selectedDate = null;
                        setState(() {
                          _selectedCategory = null;
                        });
                      }
                    },
                    child: Text(
                      'Add Expense',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Selected Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.green[300]!),
                      columns: const [
                        DataColumn(
                            label: Text('Category',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Amount',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Date',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: expenses.map((expense) {
                        return DataRow(
                          cells: [
                            DataCell(Text(expense.category)),
                            DataCell(Text(expense.amount.toString())),
                            DataCell(
                                Text(expense.date.toString().split(' ')[0])),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    TextEditingController
                                        editCategoryController =
                                        TextEditingController(
                                            text: expense.category);
                                    TextEditingController editAmountController =
                                        TextEditingController(
                                            text: expense.amount.toString());
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Edit Expense'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              TextField(
                                                controller:
                                                    editCategoryController,
                                                decoration: InputDecoration(
                                                    labelText: 'Category'),
                                              ),
                                              TextField(
                                                controller:
                                                    editAmountController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText: 'Amount'),
                                              ),
                                              DateSelector(
                                                onDateSelected:
                                                    (DateTime date) {
                                                  setState(() {
                                                    expense.date = date;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Save'),
                                              onPressed: () {
                                                final userBloc =
                                                    BlocProvider.of<UserBloc>(
                                                        context);
                                                final userState =
                                                    userBloc.state;
                                                    
                                                if (userState
                                                    is UserAuthenticated) {
                                                  final userId =
                                                      userState.user.userId;

                                                  BlocProvider.of<ExpenseBloc>(
                                                          context)
                                                      .add(UpdateExpense(
                                                    id: expense.id,
                                                    userId: userId,
                                                    category: editCategoryController
                                                          .text,
                                                    amount: editAmountController.text,
                                                    date:
                                                        expense.date.toString(),
                                                  ));
                                                  Navigator.of(context).pop();
                                                  };
                                              }),
                                          ],
                                        );
                                      },
                                    );

                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    BlocProvider.of<ExpenseBloc>(context).add(
                                      DeleteExpense(id: expense.id),
                                    );
                                  },
                                ),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The Expense class represents an expense in the Family Cash Manager app.
/// It encapsulates the properties of an expense, including the category, amount, and date.
/// The category represents the type or category of the expense, such as "Food" or "Transport".
/// The amount represents the monetary value of the expense.
/// The date represents the date and time when the expense was recorded.
///
/// The properties of an expense are final and must be provided when creating a new instance of the Expense class.
/// Once created, the expense object is immutable and its properties cannot be modified.

class Expense {
  int id;
  String category;
  String amount;
  DateTime date;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id : json['id'],
      category: json['category'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}

class DateSelector extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final DateTime? initialDate;

  const DateSelector({Key? key, this.onDateSelected, this.initialDate})
      : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _selectedDate != null
              ? _selectedDate!.toString().split(' ')[0]
              : 'No date selected',
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: widget.initialDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
              });
              if (widget.onDateSelected != null) {
                widget.onDateSelected!(pickedDate);
              }
            }
          },
          child: Text('Select Date'),
        ),
      ],
    );
  }
}

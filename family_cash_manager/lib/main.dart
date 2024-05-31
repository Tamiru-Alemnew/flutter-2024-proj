import 'package:family_cash_manager/screens/presentations/login_page.dart';
import 'package:family_cash_manager/screens/presentations/signup.dart';
import 'package:flutter/material.dart';
import 'package:family_cash_manager/screens/presentations/budgeting_goal.dart';
import 'package:family_cash_manager/screens/presentations/children.dart';
import 'package:family_cash_manager/screens/presentations/edit_category.dart';
import 'package:family_cash_manager/screens/presentations/expenses.dart';
import 'package:family_cash_manager/screens/presentations/home_page.dart';



void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/signUp': (context) => SignUp(),
        '/addExpense': (context) => AddExpense(),
        '/editCategories': (context) => EditCatagoryPage(),
        '/manageChildren': (context) => MangeChildren(),
        '/budgetingGoal': (context) => BudgetAndGoal(),
      },
      title: 'Family Cash Manager',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}

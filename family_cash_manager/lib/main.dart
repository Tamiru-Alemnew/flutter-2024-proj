import 'package:family_cash_manager/blocs/category_bloc.dart';
import 'package:family_cash_manager/blocs/expense_bloc.dart';
import 'package:family_cash_manager/blocs/user_bloc.dart';
import 'package:family_cash_manager/screens/presentations/login_page.dart';
import 'package:family_cash_manager/screens/presentations/signup.dart';
import 'package:flutter/material.dart';
import 'package:family_cash_manager/screens/presentations/budgeting_goal.dart';
import 'package:family_cash_manager/screens/presentations/children.dart';
import 'package:family_cash_manager/screens/presentations/edit_category.dart';
import 'package:family_cash_manager/screens/presentations/expenses.dart';
import 'package:family_cash_manager/screens/presentations/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_cash_manager/blocs/family_members_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc()
        ),
        BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc()
        ),
        BlocProvider<FamilyMembersBloc>(
          create: (context) => FamilyMembersBloc()
        ),
        ],
        
      child: MaterialApp(
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/signUp': (context) => SignUp(),
          '/addExpense': (context) => EditExpensePage(),
          '/editCategories': (context) => EditCategoryPage(),
          '/manageChildren': (context) => ManageChildren(),
          '/budgetingGoal': (context) => BudgetAndGoal(),
        },
        title: 'Family Cash Manager',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}

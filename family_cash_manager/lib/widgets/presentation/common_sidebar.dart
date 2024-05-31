import 'package:family_cash_manager/blocs/user_bloc.dart';
import 'package:family_cash_manager/screens/presentations/budgeting_goal.dart';
import 'package:family_cash_manager/screens/presentations/children.dart';
import 'package:family_cash_manager/screens/presentations/edit_category.dart';
import 'package:family_cash_manager/screens/presentations/expenses.dart';
import 'package:family_cash_manager/screens/presentations/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonSideBar extends StatelessWidget {
  const CommonSideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black54,
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Text(
              '',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.home),
                SizedBox(
                  width: 10,
                ),
                Text('Home'),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.add),
                SizedBox(
                  width: 10,
                ),
                Text('Add Expense'),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/addExpense');
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.edit),
                SizedBox(
                  width: 10,
                ),
                Text('Edit Categories'),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/editCategories');
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.people),
                SizedBox(
                  width: 10,
                ),
                Text('Manage Children'),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/manageChildren');
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.monetization_on),
                SizedBox(
                  width: 10,
                ),
                Text('Budgeting Goal'),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/budgetingGoal');
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text('Logout'),
              ],
            ),
            onTap: () {
              BlocProvider.of<UserBloc>(context).add(Logout());
              Navigator.pushNamed(context, '/');
            },
          ),

        ],
      ),
    );
  }
}

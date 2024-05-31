import 'package:family_cash_manager/blocs/category_bloc.dart';
import 'package:family_cash_manager/blocs/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_cash_manager/widgets/presentation/my_button.dart';
import 'package:family_cash_manager/util/text.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    BlocProvider.of<UserBloc>(context)
        .add(UserLogin(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoading) {
            setState(() {
              _isLoading = true;
              _errorMessage = '';
            });
          } else if (state is UserAuthenticated) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushNamed(context, '/home');
          } else if (state is UserError) {
            setState(() {
              _isLoading = false;
              _errorMessage = state.error;
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    TextWidget(
                      text: 'Log in to FamilyCash Manager',
                      fontWeight: FontWeight.bold,
                      size: 18,
                    ),
                    SizedBox(height: 25),
                    TextWidget(
                      text:
                          'Welcome back! Sign in using your email to continue with us 🥰',
                      family: 'Circular Std',
                      color: Color.fromARGB(255, 121, 124, 123),
                    ),
                    SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1),
                        ),
                        Expanded(
                          child: Divider(thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: TextWidget(
                          text: 'Your email',
                          color: const Color.fromARGB(255, 36, 120, 109),
                          family: 'Circular Std',
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Caros',
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        label: TextWidget(
                          text: 'Password',
                          color: const Color.fromARGB(255, 36, 120, 109),
                          family: 'Circular Std',
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Caros',
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : MyButton(onPressed: _login),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/signUp');
                      },
                      child: TextWidget(
                        text: "Don't have Account? Create Account",
                        family: 'Circular Std',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_cash_manager/blocs/user_bloc.dart';
import '../../styling/colors.dart';
import '../../styling/heights_and_widths.dart';
import '../../styling/paddings_and_margins.dart';
import '../../styling/typography.dart';

class SignUpTextFields extends StatefulWidget {
  const SignUpTextFields({Key? key}) : super(key: key);

  @override
  _SignUpTextFieldsState createState() => _SignUpTextFieldsState();
}

class _SignUpTextFieldsState extends State<SignUpTextFields> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String dropdownValue = 'parent';
  String _errorMessage = '';

  void _createAccount() {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = dropdownValue;

    BlocProvider.of<UserBloc>(context).add(
        UserSignUp(name: name, email: email, password: password, role: role));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          setState(() {
            _errorMessage = state.error;
          });
        } else if (state is UserAuthenticated) {
          setState(() {
            _errorMessage = '';
          });
          Navigator.pushNamed(context, '/home');
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
            top: CustomPaddings.mediumPadding,
            bottom: CustomPaddings.mediumPadding,
            left: CustomPaddings.smallPadding,
            right: CustomPaddings.smallPadding),
        child: Column(
          children: [
            CustomTextField(
              label: 'Name',
              controller: _nameController,
            ),
            CustomTextField(
              label: 'Email',
              controller: _emailController,
            ),
            CustomTextField(
              label: 'Password',
              controller: _passwordController,
            ),
            Row(
              children: [
                RoleSelector(
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // display error message
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: CustomTypography.smallFontSize,
                ),
              ),
            CreateAccountButton(onPressed: _createAccount),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextField(
      {Key? key, required this.label, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CustomMargins.mediumMargin),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: primaryColor,
              fontSize: CustomTypography.smallFontSize,
              fontFamily: CustomTypography.primaryFontFamily),
          disabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                  color: subtitleColor, width: BorderThickness.thick)),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide:
                BorderSide(color: primaryColor, width: BorderThickness.thick),
          ),
        ),
      ),
    );
  }
}

class RoleSelector extends StatelessWidget {
  final ValueChanged<String?> onChanged;
  const RoleSelector({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DropdownButton<String>(
      value: 'parent',
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChanged,
      items: <String>['parent', 'children']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }
}

class CreateAccountButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateAccountButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 36, 120, 109),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Caros',
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

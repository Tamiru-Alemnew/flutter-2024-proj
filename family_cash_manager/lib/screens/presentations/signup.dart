import 'package:flutter/material.dart';
import 'package:family_cash_manager/styling/colors.dart';
import 'package:family_cash_manager/styling/paddings_and_margins.dart';
import 'package:family_cash_manager/styling/typography.dart';
import 'package:family_cash_manager/widgets/presentation/signup_textfeilds.dart';

/// The SignUp class represents the sign-up screen of the Family Cash Manager app.
/// This class extends StatelessWidget and defines the UI layout using MaterialApp and Scaffold.
/// It includes a background color, an app bar with a back button, and a body that consists of various widgets
/// for the sign-up form. The form prompts the user to sign up with an email and fill out the required information
/// to create an account. The UI elements are organized in a column layout and styled using appropriate padding,
/// alignment, and font styles.

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: signUpBackgroundColor,
          appBar: AppBar(
            title: Text(
              "Signup",
              style: TextStyle(
                color: headerColor,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(CustomPaddings.mediumPadding),
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(CustomPaddings.mediumPadding),
                    alignment: Alignment.center,
                    child: Text(
                      "SignUp with Email",
                      style: TextStyle(
                        fontSize: CustomTypography.largeFontSize,
                        fontWeight: CustomTypography().medium,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomPaddings.mediumPadding),
                    alignment: Alignment.center,
                    child: Text(
                      "Please fill the form below to create an account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: CustomTypography.smallFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(child: SignUpTextFeilds()),

                ],
              ),
            ),
          ),
        ));
  }
}


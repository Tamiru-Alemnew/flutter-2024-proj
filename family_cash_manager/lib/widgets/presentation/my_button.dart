import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyButton({super.key, required this.onPressed});

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
              'Login',
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

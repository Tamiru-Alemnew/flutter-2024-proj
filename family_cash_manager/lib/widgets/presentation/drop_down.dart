import 'package:flutter/material.dart';

const List<String> categories = ['School', 'Transport', 'Food', 'Other'];

class DropdownMenus extends StatefulWidget {
  static String dropdownValue = categories.first;

  

  const DropdownMenus({Key? key});


  
  @override
  State<DropdownMenus> createState() => _DropdownMenusState();
}




class _DropdownMenusState extends State<DropdownMenus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),

      
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: DropdownMenus.dropdownValue,
          onChanged: (String? value) {
            setState(() {
              DropdownMenus.dropdownValue = value!;
            });
          },
          items: categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

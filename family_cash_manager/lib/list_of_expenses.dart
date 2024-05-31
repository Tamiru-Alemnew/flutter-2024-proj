import 'package:flutter/material.dart';




void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Cash manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 78, 75, 82),
          title: Text(
            "Family Cash manager",
            selectionColor: Color(0xFFFFFFFF),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: double.tryParse("110"),
                width: double.tryParse("140"),
                color: const Color.fromARGB(255, 124, 122, 115),
                child: Text("List of Expenses"),
              ),
              SizedBox(
                height: double.tryParse("60"),
              ),
              Container(
                alignment: Alignment.center,
                height: double.tryParse("110"),
                width: double.tryParse("140"),
                color: Colors.green,
                child: Text("Edit category"),
                padding: EdgeInsets.all(12),
              ),
              SizedBox(
                height: double.tryParse("60"),
              ),
              Container(
                alignment: Alignment.center,
                height: double.tryParse("110"),
                width: double.tryParse("140"),
                color: const Color.fromARGB(255, 85, 80, 80),
                child: Text("Manage children"),
                padding: EdgeInsets.all(12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:studentperformanceapp/Signup.dart';
import 'package:studentperformanceapp/login.dart';
import 'package:studentperformanceapp/form.dart';
import 'package:studentperformanceapp/stdash.dart'; // Import the dashboard widget
import 'package:studentperformanceapp/admin.dart'; // Import the dashboard widget
import 'package:studentperformanceapp/pie.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (context) => MyLogin(),
        'Signup': (context) => MySignup(),
        'form': (context) => MyForm(),
        'dashboard': (context) => MyDashboard(), // Updated route for the dashboard
        'AdminLogin': (context) => AdminLogin(),
        'Pie': (context)=>Mypie()// Added route for admin login
      },
    );
  }
}

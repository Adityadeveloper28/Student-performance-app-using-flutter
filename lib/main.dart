
import 'package:flutter/material.dart';
import 'package:untitled2/login.dart';
import 'package:untitled2/register.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
    },
  ));
}


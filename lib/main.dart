import 'package:design_pattern/home_screen.dart';
import 'package:design_pattern/login_singup/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'db.dart';

void main() {
  // Initialize database factory for Linux
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(
       MyApp(),
  );
}

class MyApp extends StatelessWidget {
  Db mydb = Db();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(id_customer: 1),
    );
  }
}

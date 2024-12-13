import 'package:design_pattern/admin_package/main_page.dart';
import 'package:design_pattern/login_singup/first_screen.dart';
import 'package:design_pattern/user_package/user_main_page.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainAdminPage(),
    );
  }
}

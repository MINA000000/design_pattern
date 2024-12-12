import 'package:design_pattern/admin_package/main_page.dart';
import 'package:design_pattern/admin_package/transactions_configurations/transactions_configuration.dart';
import 'package:design_pattern/home_page.dart';
import 'package:design_pattern/home_screen.dart';
import 'package:design_pattern/login_singup/first_screen.dart';
import 'package:design_pattern/login_singup/sign_in.dart';
import 'package:design_pattern/login_singup/sign_up.dart';
import 'package:design_pattern/profile/profile_page.dart';
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
      home: MainAdminPage(),
    );
  }
}

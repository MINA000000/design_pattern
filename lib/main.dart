import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'db.dart';

void main() {
  // Initialize database factory for Linux
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Db mydb = Db();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue,title: Text("try DB"),centerTitle: true,),
        body: Column(
          children: [

            ElevatedButton(
              onPressed: () async {
                List<Map> response = await mydb.readData("SELECT * FROM 'categories'");
                print(response);
              },
              child: Text("read data from books"),
            ),


          ],
        ),
      ),
    );
  }
}

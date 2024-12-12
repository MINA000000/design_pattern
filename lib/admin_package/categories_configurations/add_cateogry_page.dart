import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> addCategory() async {
    String categoryName = _controller.text.trim();
    if (categoryName.isNotEmpty) {
      String sql = '''
        INSERT INTO categories (category_name) VALUES ('$categoryName')
      ''';
      await Database.database.insertData(sql);
      Navigator.pop(context); // Go back to categories page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category name cannot be empty")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addCategory,
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}

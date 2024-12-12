import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class EditCategoryPage extends StatefulWidget {
  final int categoryId;
  final String initialName;

  EditCategoryPage({required this.categoryId, required this.initialName});

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  Future<void> updateCategory() async {
    String newName = _controller.text.trim();
    if (newName.isNotEmpty) {
      String sql = '''
        UPDATE categories SET category_name = '$newName' WHERE id_category = ${widget.categoryId}
      ''';
      await Database.database.updateData(sql);
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
      appBar: AppBar(title: Text("Edit Category")),
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
              onPressed: updateCategory,
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}

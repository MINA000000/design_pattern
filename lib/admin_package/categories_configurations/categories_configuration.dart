import 'package:flutter/material.dart';

import '../../single_data_base.dart';
import 'add_cateogry_page.dart';
import 'edit_category_page.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Future<List<Map>> fetchCategories() async {
    String sql = "SELECT * FROM categories";
    List<Map> res = await Database.database.readData(sql);
    print(res);
    return res;
  }

  Future<void> deleteCategory(int categoryId) async {
    String checkSql = '''
      SELECT COUNT(*) AS count FROM books WHERE id_cat = $categoryId
    ''';
    List<Map> result = await Database.database.readData(checkSql);
    if (result[0]['count'] == 0) {
      String deleteSql = '''
        DELETE FROM categories WHERE id_category = $categoryId
      ''';
      await Database.database.deleteData(deleteSql);
      setState(() {}); // Refresh the UI
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot delete: Category in use")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: FutureBuilder(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<Map> categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                Map category = categories[index];
                return Card(
                  child: ListTile(
                    title: Text(category['category_name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteCategory(category['id_category']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCategoryPage(
                                  categoryId: category['id_category'],
                                  initialName: category['category_name'],
                                ),
                              ),
                            ).then((_) => setState(() {})); // Refresh after edit
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No categories available"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCategoryPage()),
          ).then((_) => setState(() {})); // Refresh after add
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

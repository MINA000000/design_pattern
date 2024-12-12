import 'package:design_pattern/admin_package/items/delete_book_item.dart';
import 'package:design_pattern/admin_package/items/edit_book_item.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class DeleteBook extends StatefulWidget {
  @override
  State<DeleteBook> createState() => _DeleteBookState();
}

class _DeleteBookState extends State<DeleteBook> {
  Future<List<Map>> fetchBooks() async {
    List<Map> response = await Database.database.readData("SELECT * FROM 'books'");
    return response;
  }
  void updateMessage() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(future: fetchBooks(), builder:
          (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading state
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Error state
        } else if (snapshot.hasData) {
          final books = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteBookItem(bookItem: books[index],),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/images/${books[index]['cover_URL']}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          books[index]['title'],
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Text('No data available');
        }
      },),
    );
  }
}


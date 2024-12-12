import 'package:design_pattern/book.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

import 'book_detail_page.dart';

class HomePage extends StatefulWidget {
  final int id_customer;

  const HomePage({super.key, required this.id_customer});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks(); // Initialize the Future
  }

  Future<List<Book>> fetchBooks() async {
    try {
      List<Map> response = await Database.database.readData("SELECT * FROM 'books'");
      return response.map((e) {
        return Book(price: e['price'], title: e['title'], author: e['author'], category_id: e['id_cat'], quantity: e['quantity'], cover_URL: "assets/images/${e['cover_URL']}", edition: e['edition'], id_book: e['id_book']);
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch books: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture, // Use the Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if something goes wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show a message if no books are available
            return Center(child: Text("No books found."));
          } else {
            // Display the books once data is available
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
                        builder: (context) => BookDetailPage(book: books[index], id_customer: widget.id_customer,),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            books[index].cover_URL,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            books[index].title,
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
          }
        },
      ),
    );
  }
}



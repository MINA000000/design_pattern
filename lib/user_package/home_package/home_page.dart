import 'package:design_pattern/user_package/book_items/book.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';
import '../book_items/book_detail_page.dart';

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
      List<Book> ans = [];
      for (int i = 0; i < response.length; i++) {
        ans.add(Book(
          price: response[i]['price'],
          title: response[i]['title'],
          author: response[i]['author'],
          category_id: response[i]['id_cat'],
          quantity: response[i]['quantity'],
          cover_URL: "assets/images/${response[i]['cover_URL']}",
          edition: response[i]['edition'],
          id_book: response[i]['id_book'],
        ));
      }
      return ans;
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
                    // Clone the selected book before passing it to the BookDetailPage
                    Book clonedBook = books[index].clone();
                    // Now pass the cloned book to the detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(
                          book: clonedBook,
                          id_customer: widget.id_customer,
                        ),
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

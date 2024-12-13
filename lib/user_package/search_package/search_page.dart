import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';
import '../book_items/book.dart';
import '../book_items/book_detail_page.dart';

class SearchPage extends StatefulWidget {
  int id_Customer;
  SearchPage({required this.id_Customer});
  get id_customer => id_Customer;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Book>> _booksFuture;
  late Future<List<Map>> _categoriesFuture;
  String searchQuery = "";
  String selectedCategory = "All Categories";
  String selectedSortBy = "Price (Low to High)";
  List<Map> categories = [];

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks(); // Fetch books
    _categoriesFuture = fetchCategories(); // Fetch categories
    _categoriesFuture.then((fetchedCategories) {
      setState(() {
        categories = fetchedCategories;
      });
    });
  }

  Future<List<Book>> fetchBooks() async {
    try {
      List<Map> response =
      await Database.database.readData("SELECT * FROM 'books'");
      return response.map((e) {
        return Book(
          price: e['price'],
          title: e['title'],
          author: e['author'],
          category_id: e['id_cat'],
          quantity: e['quantity'],
          cover_URL: "assets/images/${e['cover_URL']}",
          edition: e['edition'],
          id_book: e['id_book'],
        );
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch books: $e");
    }
  }

  Future<List<Map>> fetchCategories() async {
    try {
      return await Database.database.readData("SELECT * FROM 'categories'");
    } catch (e) {
      throw Exception("Failed to fetch categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No books found."));
          } else {
            final books = snapshot.data!;

            // Filter and search logic
            List<Book> filteredBooks = books
                .where((book) =>
            book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                book.author.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            if (selectedCategory != "All Categories") {
              filteredBooks = filteredBooks
                  .where((book) => book.category_id.toString() == selectedCategory)
                  .toList();
            }

            if (selectedSortBy == "Price (Low to High)") {
              filteredBooks.sort((a, b) => a.price.compareTo(b.price));
            } else if (selectedSortBy == "Price (High to Low)") {
              filteredBooks.sort((a, b) => b.price.compareTo(a.price));
            }

            return Column(
              children: [
                SearchElements(
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  onCategoryChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  onSortChanged: (value) {
                    setState(() {
                      selectedSortBy = value;
                    });
                  },
                  selectedCategory: selectedCategory,
                  selectedSortBy: selectedSortBy,
                  categories: categories,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailPage(
                                book: filteredBooks[index],
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
                                  filteredBooks[index].cover_URL,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  filteredBooks[index].title,
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class SearchElements extends StatelessWidget {
  final Function(String) onSearchChanged;
  final Function(String) onCategoryChanged;
  final Function(String) onSortChanged;
  final String selectedCategory;
  final String selectedSortBy;
  final List<Map> categories;

  SearchElements({
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.selectedCategory,
    required this.selectedSortBy,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search by Title or Author',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  onSearchChanged(value);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              items: [
                DropdownMenuItem(
                    value: "All Categories", child: Text("All Categories")),
                ...categories.map(
                      (category) => DropdownMenuItem(
                    value: category['id_category'].toString(),
                    child: Text(category['category_name']),
                  ),
                ),
              ],
              onChanged: (value) {
                onCategoryChanged(value!);
              },
            ),
            SizedBox(width: 20),
            DropdownButton<String>(
              value: selectedSortBy,
              items: [
                DropdownMenuItem(
                    value: "Price (Low to High)", child: Text("Price (Low to High)")),
                DropdownMenuItem(
                    value: "Price (High to Low)", child: Text("Price (High to Low)")),
              ],
              onChanged: (value) {
                onSortChanged(value!);
              },
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../book_items/book.dart';
import '../book_items/book_detail_page.dart';
import 'package:design_pattern/single_data_base.dart';

class SearchPage extends StatefulWidget {
  final int id_Customer;

  SearchPage({required this.id_Customer});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Book>> _booksFuture;
  late Future<List<Pair>> _topBooksFuture;
  late Future<List<Map>> _categoriesFuture;
  String searchQuery = "";
  String selectedCategory = "All Categories";
  String selectedSortBy = "None";
  String selectedFilterBy = "None";

  Future<List<Pair>> fetchTopSoldBooks() async {
    String sql = '''
    SELECT * FROM transactions WHERE id_status=1;
    ''';
    List<Map<String, dynamic>> response = await Database.database.readData(sql);
    Map<int, int> cnt = {};
    for (int i = 0; i < response.length; i++) {
      int bookId = response[i]['id_book'];
      cnt[bookId] = (cnt[bookId] ?? 0) + 1;
    }
    List<Pair> ans = [];
    for (var entry in cnt.entries) {
      int key = entry.key;
      int value = entry.value;
      sql = "SELECT title FROM books WHERE id_book=${key}";
      List<Map> res = await Database.database.readData(sql);
      if (res.isNotEmpty) {
        ans.add(Pair(res[0]['title'], value));
      }
    }
    ans.sort((a, b) => b.value.compareTo(a.value));
    return ans;
  }

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchBooks();
    _categoriesFuture = fetchCategories();
    _topBooksFuture = fetchTopSoldBooks();
  }

  Future<List<Map>> fetchCategories() async {
    try {
      List<Map> response =
      await Database.database.readData("SELECT * FROM 'categories'");
      return response;
    } catch (e) {
      throw Exception("Failed to fetch categories: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No categories found."));
          } else {
            final categories = snapshot.data!;

            return FutureBuilder<List<Book>>(
              future: _booksFuture,
              builder: (context, bookSnapshot) {
                if (bookSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (bookSnapshot.hasError) {
                  return Center(child: Text('Error: ${bookSnapshot.error}'));
                } else if (!bookSnapshot.hasData || bookSnapshot.data!.isEmpty) {
                  return Center(child: Text("No books found."));
                } else {
                  final books = bookSnapshot.data!;

                  List<Book> filteredBooks = books
                      .where((book) =>
                  book.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                      book.author
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

                  if (selectedCategory != "All Categories") {
                    filteredBooks = filteredBooks
                        .where((book) =>
                    book.category_id.toString() == selectedCategory)
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
                        onFilterChanged: (value) {
                          setState(() {
                            selectedFilterBy = value;
                            if (value == "Most Sold Books") {
                              _booksFuture = fetchBooksFromPairs(_topBooksFuture);
                            } else {
                              _booksFuture = fetchBooks();
                            }
                          });
                        },
                        categories: categories,
                        selectedCategory: selectedCategory,
                        selectedSortBy: selectedSortBy,
                        selectedFilterBy: selectedFilterBy,
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
                                      id_customer: widget.id_Customer,
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
  final Function(String) onFilterChanged;
  final List<Map> categories;
  final String selectedCategory;
  final String selectedSortBy;
  final String selectedFilterBy;

  SearchElements({
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onFilterChanged,
    required this.categories,
    required this.selectedCategory,
    required this.selectedSortBy,
    required this.selectedFilterBy,
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
                  value: "All Categories",
                  child: Text("All Categories"),
                ),
                ...categories.map((category) {
                  return DropdownMenuItem(
                    value: category['id_category'].toString(),
                    child: Text(category['category_name']),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                onCategoryChanged(value!);
              },
            ),
            SizedBox(width: 20),
            DropdownButton<String>(
              value: selectedSortBy,
              items: [
                DropdownMenuItem(value: "None", child: Text("No Sorting")),
                DropdownMenuItem(
                    value: "Price (Low to High)",
                    child: Text("Price (Low to High)")),
                DropdownMenuItem(
                    value: "Price (High to Low)",
                    child: Text("Price (High to Low)")),
              ],
              onChanged: (value) {
                onSortChanged(value!);
              },
            ),
            SizedBox(width: 20),
            DropdownButton<String>(
              value: selectedFilterBy,
              items: [
                DropdownMenuItem(value: "None", child: Text("No Filter")),
                DropdownMenuItem(
                    value: "Most Sold Books", child: Text("Most Sold Books")),
              ],
              onChanged: (value) {
                onFilterChanged(value!);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class Pair {
  final String key;
  final int value;

  Pair(this.key, this.value);
}

Future<List<Book>> fetchBooksFromPairs(Future<List<Pair>> pairsFuture) async {
  final pairs = await pairsFuture;
  final books = <Book>[];
  for (final pair in pairs) {
    final bookResponse = await Database.database.readData(
        "SELECT * FROM books WHERE title = '${pair.key}'");
    if (bookResponse.isNotEmpty) {
      final bookData = bookResponse.first;
      books.add(Book(
        price: bookData['price'],
        title: bookData['title'],
        author: bookData['author'],
        category_id: bookData['id_cat'],
        quantity: bookData['quantity'],
        cover_URL: "assets/images/${bookData['cover_URL']}",
        edition: bookData['edition'],
        id_book: bookData['id_book'],
      ));
    }
  }
  return books;
}

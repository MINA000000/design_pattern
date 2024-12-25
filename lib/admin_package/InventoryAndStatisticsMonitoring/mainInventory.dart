import 'package:design_pattern/db.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class Maininventory extends StatelessWidget {
  const Maininventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory & Statistics"),
        centerTitle: true,
        backgroundColor: Colors.teal, // Change the app bar color
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding around the content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                const Text(
                  "Welcome to Inventory & Statistics",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20), // Spacing
                // Top Sold Books Button
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.book, color: Colors.teal),
                    title: const Text(
                      "Top Sold Books",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopSoldBooksScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Popular Categories Button
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.category, color: Colors.teal),
                    title: const Text(
                      "Most Popular Categories",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PopularCategoriesScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Add decorative image or icon (optional)
                const Icon(
                  Icons.analytics_outlined,
                  size: 100,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopSoldBooksScreen extends StatelessWidget {
  const TopSoldBooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch and display top-sold books data here
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Sold Books"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder<List<Pair>>(
            future: fetchTopSoldBooks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text(
                      "Fetching top sold books...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      "Error: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                  "No data available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final book = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            book.key[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          book.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "Sold Quantity: ${book.value}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Text("Sold",style: TextStyle(color: Colors.green,fontSize: 16),)
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );

  }
  Future<List<Pair>> fetchTopSoldBooks() async {
    DatabaseInterface database = ProxyDatabase();

    String sql = '''
      SELECT * FROM transactions WHERE id_status=1;
    ''';

    List<Map> response = await database.readData(sql);
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
      List<Map> res = await database.readData(sql);
      if (res.isNotEmpty) {
        ans.add(Pair(res[0]['title'], value));
      }
    }

    ans.sort((a, b) => b.value.compareTo(a.value));
    return ans;
  }


}
class Pair {
  final String key;
  final int value;

  Pair(this.key, this.value);
}
class PopularCategoriesScreen extends StatelessWidget {
  const PopularCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch and display most popular categories data here
    return Scaffold(
      appBar: AppBar(
        title: const Text("Most Popular Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder<List<Pair>>(
            future: fetchPopularCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text(
                      "Loading popular categories...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      "Error: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                  "No data available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final category = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            category.key[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          category.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "Sold Quantity: ${category.value}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Text("Done",style: TextStyle(color: Colors.green,fontSize: 16),),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );

  }

  Future<List<Pair>> fetchPopularCategories() async {
    DatabaseInterface database = ProxyDatabase();

    String sql = '''
    SELECT * FROM transactions WHERE id_status = 1;
  ''';

    List<Map> response = await database.readData(sql);
    Map<int, int> bookCounts = {};

    print(response);

    for (var entry in response) {
      int bookId = entry['id_book'];
      bookCounts[bookId] = (bookCounts[bookId] ?? 0) + 1;
    }

    Map<int, int> categoryCounts = {};

    for (var entry in bookCounts.entries) {
      int bookId = entry.key;
      int count = entry.value;

      sql = "SELECT id_cat FROM books WHERE id_book = $bookId";
      List<Map> bookResponse = await database.readData(sql);

      if (bookResponse.isNotEmpty) {
        int categoryId = bookResponse[0]['id_cat'];
        categoryCounts[categoryId] = (categoryCounts[categoryId] ?? 0) + count;
      }
    }

    List<Pair> result = [];

    for (var entry in categoryCounts.entries) {
      int categoryId = entry.key;
      int count = entry.value;

      sql = "SELECT category_name FROM categories WHERE id_category = $categoryId";
      List<Map> categoryResponse = await database.readData(sql);

      if (categoryResponse.isNotEmpty) {
        String categoryName = categoryResponse[0]['category_name'];
        result.add(Pair(categoryName, count));
      }
    }

    result.sort((a, b) => b.value.compareTo(a.value));

    return result;
  }

}
abstract class DatabaseInterface {
  Future<List<Map>> readData(String sql);
}

class RealDatabase implements DatabaseInterface {
  static final RealDatabase _instance = RealDatabase._internal();
  RealDatabase._internal();

  static RealDatabase get database => _instance;

  @override
  Future<List<Map>> readData(String sql) async {
    try
    {
      List<Map> res = await Database.database.readData(sql);
      if(res.isNotEmpty)
        return res;
      else
        return [];
    }
    catch(e)
    {
      return [];
    }
  }
}
class ProxyDatabase implements DatabaseInterface {
  final RealDatabase _realDatabase = RealDatabase.database;
   static final Map<String, List<Map>> _cache = {};

  @override
  Future<List<Map>> readData(String sql) async {
    if (_cache.containsKey(sql)) {
      print("Returning cached result for query: $sql");
      return _cache[sql]!;
    }

    print("Querying real database for: $sql");
    List<Map> result = await _realDatabase.readData(sql);

    _cache[sql] = result;
    return result;
  }
}

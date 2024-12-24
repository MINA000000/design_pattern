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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopSoldBooksScreen()),
                );
              },
              child: const Text("Top Sold Books"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PopularCategoriesScreen()),
                );
              },
              child: const Text("Most Popular Categories"),
            ),
          ],
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
    // Access the database instance

    // SQL query to get top-sold books
    String sql = '''
  SELECT * FROM transactions WHERE id_status=1;
  ''';

// Execute the query and return the results
    List<Map<String, dynamic>> response = await Database.database.readData(sql);
    Map<int, int> cnt = {};

// Iterate through the results and count occurrences of id_book
    for (int i = 0; i < response.length; i++) {
      int bookId = response[i]['id_book'];
      cnt[bookId] = (cnt[bookId] ?? 0) + 1; // Increment count, initialize to 0 if null
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
    // cnt.forEach((key, value)async {
    //   sql = "SELECT title FROM books WHERE id_book=${key}";
    //   List<Map> res = await Database.database.readData(sql);
    //   ans.add(Pair(res[0]['title'], value));
    // });
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
    String sql = '''
  SELECT * FROM transactions WHERE id_status=1;
  ''';

// Execute the query and return the results
    List<Map<String, dynamic>> response = await Database.database.readData(sql);
    Map<int, int> cnt = {};
  print(response);
// Iterate through the results and count occurrences of id_book
    for (int i = 0; i < response.length; i++) {
      int bookId = response[i]['id_book'];
      cnt[bookId] = (cnt[bookId] ?? 0) + 1; // Increment count, initialize to 0 if null
    }
    // print(cnt.length);
    Map<int, int> cntCat = {};
    for (var entry in cnt.entries) {
      int key = entry.key;
      int value = entry.value;
      sql = "SELECT id_cat FROM books WHERE id_book=${key}";
      List<Map> res = await Database.database.readData(sql);
      if (res.isNotEmpty) {
        cntCat[res[0]['id_cat']] = (cntCat[res[0]['id_cat']] ?? 0) + value;
      }
    }
    List<Pair> ans = [];
    for (var entry in cntCat.entries) {
      int key = entry.key;
      int value = entry.value;
      sql = "SELECT category_name FROM categories WHERE id_category = ${key}";
      List<Map> res = await Database.database.readData(sql);
      if (res.isNotEmpty) {
        ans.add(Pair(res[0]['category_name'], value));
      }
    }
    // cntCat.forEach((key,value)async{
    //   sql = "SELECT category_name FROM categories WHERE id_category = ${key}";
    //   List<Map> res = await Database.database.readData(sql);
    //   ans.add(Pair(res[0]['category_name'], value));
    // });
    ans.sort((a, b) => b.value.compareTo(a.value));
    return ans;
  }
}

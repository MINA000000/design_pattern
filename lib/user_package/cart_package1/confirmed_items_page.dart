import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';


class ConfirmedItemsPage extends StatelessWidget {
  final int userId;

  ConfirmedItemsPage({required this.userId});

  Future<List<Map>> getConfirmedItems() async {
    String sql = '''
      SELECT t.id_book, t.quantity, b.title, b.author, b.price
      FROM transactions t
      JOIN books b ON t.id_book = b.id_book
      WHERE t.id_customer = $userId AND t.id_status = 1
    ''';
    return await Database.database.readData(sql);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmed Items"),
      ),
      body: FutureBuilder(
        future: getConfirmedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No confirmed items found.'));
          } else {
            List<Map> confirmedItems = snapshot.data as List<Map>;

            return ListView.builder(
              itemCount: confirmedItems.length,
              itemBuilder: (context, index) {
                Map item = confirmedItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("Author: ${item['author']}"),
                        Text("Price: \$${item['price']}"),
                        Text("Quantity: ${item['quantity']}"),
                        SizedBox(height: 10),
                        Text(
                          "Status: Confirmed",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
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

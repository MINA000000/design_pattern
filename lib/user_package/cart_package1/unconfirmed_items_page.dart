import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class UnconfirmedItemsPage extends StatefulWidget {
  final int userId;

  UnconfirmedItemsPage({required this.userId});

  @override
  _UnconfirmedItemsPageState createState() => _UnconfirmedItemsPageState();
}

class _UnconfirmedItemsPageState extends State<UnconfirmedItemsPage> {
  Future<List<Map>> fetchUnconfirmedItems() async {
    String sql = '''
      SELECT t.*, b.title, b.author 
      FROM transactions t 
      JOIN books b ON t.id_book = b.id_book 
      WHERE t.id_customer = ${widget.userId} AND t.id_status = 2
    ''';
    return await Database.database.readData(sql);
  }
  Future<void> cancelSingleTransaction(
      int idCustomer, int idBook, int quantity, BuildContext context) async {
    try {
      // Begin a transaction
      // await Database.database.beginTransaction();

      // Update the book quantity
      String updateBookSql = '''
      UPDATE books
      SET quantity = quantity + $quantity
      WHERE id_book = $idBook
    ''';
      await Database.database.updateData(updateBookSql);

      // Delete the transaction
      String deleteTransactionSql = '''
      DELETE FROM transactions
      WHERE ROWID = (
        SELECT ROWID
        FROM transactions
        WHERE id_customer = $idCustomer
          AND id_book = $idBook
          AND id_status = 2
          AND quantity = $quantity
        LIMIT 1
      )
    ''';
      await Database.database.deleteData(deleteTransactionSql);

      // Commit the transaction
      // await Database.database.commitTransaction();

      // Refresh the page
      setState(() {});

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item canceled successfully")),
      );
    } catch (e) {
      // Rollback the transaction in case of an error
      // await Database.database.rollbackTransaction();

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error canceling item: $e")),
      );
    }
  }


  // Future<void> cancelTransaction(int idCustomer, int idBook) async {
  //   String sql = '''
  //     DELETE FROM transactions
  //     WHERE id_customer = $idCustomer AND id_book = $idBook AND id_status = 2
  //   ''';
  //   await Database.database.deleteData(sql);
  //   setState(() {}); // Refresh the page after deletion
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Item canceled successfully")),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unconfirmed Items"),
      ),
      body: FutureBuilder(
        future: fetchUnconfirmedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Map> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Map item = items[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("Author: ${item['author']}"),
                        Text("Quantity: ${item['quantity']}"),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "Pending",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                cancelSingleTransaction(
                                    item['id_customer'], item['id_book'],item['quantity'],context);
                              },
                              child: Text("Cancel"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No unconfirmed items found."));
          }
        },
      ),
    );
  }
}

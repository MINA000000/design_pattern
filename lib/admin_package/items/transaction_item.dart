import 'package:flutter/material.dart';
import '../../single_data_base.dart';

class TransactionItem extends StatelessWidget {
  Map transaction;
  Function() onMessageChanged;

  TransactionItem({required this.transaction, required this.onMessageChanged});

  Future<List<Map>> fetchData() async {
    String sql = "SELECT * FROM books WHERE id_book=${transaction['id_book']}";
    List<Map> data = await Database.database.readData(sql);
    return data;
  }

  double calcTotalPrice(double priceOfOneBook) {
    return transaction['quantity'] * priceOfOneBook;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading state
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Error state
        } else if (snapshot.hasData) {
          Map mydata = snapshot.data![0];
          return Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.amber,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(mydata['title']),
                  ),
                  Text(
                    "Total: ${calcTotalPrice(mydata['price'])}",
                    style: TextStyle(color: Colors.purple),
                  ),
                  Row(
                    children: [
                      // Cancel Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            // SQL query to delete the transaction
                            String sql = '''
                            DELETE FROM transactions
                            WHERE ROWID = (
                              SELECT ROWID
                              FROM transactions
                              WHERE id_customer = ${transaction['id_customer']}
                                AND id_book = ${transaction['id_book']}
                                AND quantity = ${transaction['quantity']}
                                AND id_status = 2
                              LIMIT 1
                            )
                            ''';
                            print("Running DELETE SQL: $sql");

                            // Execute delete operation
                            int res = await Database.database.deleteData(sql);
                            print("Delete Result: $res");

                            if (res >= 1) {
                              // After deleting the transaction, update the book quantity
                              String updateBookSql = '''
                              UPDATE books
                              SET quantity = quantity + ${transaction['quantity']}
                              WHERE id_book = ${transaction['id_book']}
                              ''';
                              int updateRes = await Database.database
                                  .updateData(updateBookSql);
                              print("Update Book Quantity Result: $updateRes");

                              if (updateRes >= 1) {
                                // Successfully updated the book quantity
                                onMessageChanged(); // Callback to refresh the UI or data
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Transaction canceled and book quantity updated")),
                                );
                              } else {
                                // Handle error in updating book quantity
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Failed to update book quantity")),
                                );
                              }
                            } else {
                              // Handle error in deleting transaction
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Failed to cancel transaction")),
                              );
                            }
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                      // Confirm Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          onPressed: () async {
                            String sql = '''
                            UPDATE transactions
                            SET id_status = 1
                            WHERE ROWID = (
                              SELECT ROWID
                              FROM transactions
                              WHERE id_customer = ${transaction['id_customer']}
                                AND id_book = ${transaction['id_book']}
                                AND quantity = ${transaction['quantity']}
                                AND id_status = 2
                              LIMIT 1
                            )
                            ''';
                            print("Running UPDATE SQL: $sql");
                            int res = await Database.database.updateData(sql);
                            print("Update Result: $res");
                            if (res >= 1) {
                              onMessageChanged(); // Callback to refresh the UI or data
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Transaction confirmed successfully")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Failed to confirm transaction")),
                              );
                            }
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}

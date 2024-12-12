import 'package:design_pattern/single_data_base.dart';
import 'package:design_pattern/user_package/items/edit_Cart_Item_page.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Map item;
  final VoidCallback refreshParent;

  CartItem({required this.item, required this.refreshParent});

  Future<Map> getBookDetails() async {
    String sql = "SELECT * FROM books WHERE id_book = ${item['id_book']}";
    List<Map> res = await Database.database.readData(sql);
    return res[0];
  }

  Future<void> deleteCartItem() async {
    String sql = '''
      DELETE FROM cart WHERE id_customer = ${item['id_customer']} AND id_book = ${item['id_book']}
    ''';
    await Database.database.deleteData(sql);
  }

  Future<void> buyCartItem(BuildContext context) async {
    Map bookDetails = await getBookDetails();

    if (bookDetails['quantity'] >= item['quantity']) {
      // Reduce book quantity
      String updateBookSql = '''
        UPDATE books SET quantity = quantity - ${item['quantity']} WHERE id_book = ${item['id_book']}
      ''';
      await Database.database.updateData(updateBookSql);

      // Insert into transactions
      String insertTransactionSql = '''
        INSERT INTO transactions (id_customer, id_book, id_status, quantity) 
        VALUES (${item['id_customer']}, ${item['id_book']}, 2, ${item['quantity']})
      ''';
      await Database.database.insertData(insertTransactionSql);

      // Delete from cart
      await deleteCartItem();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Purchase successful!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insufficient stock to buy this item")),
      );
    }
    refreshParent(); // Refresh parent after operation
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: getBookDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading state
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Error state
        } else if (snapshot.hasData) {
          Map bookData = snapshot.data!;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookData['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Author: ${bookData['author']}"),
                  Text("Price: \$${bookData['price']}"),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await deleteCartItem();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Item deleted from cart")),
                          );
                          refreshParent();
                        },
                        child: Text("Delete"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCartItemPage(
                                item: item,
                                bookQuantity: bookData['quantity'],
                              ),
                            ),
                          ).then((_) => refreshParent()); // Refresh after edit
                        },
                        child: Text("Edit"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
                      ElevatedButton(
                        onPressed: () => buyCartItem(context),
                        child: Text("Buy"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

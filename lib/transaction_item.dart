
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'book.dart';
import 'cart_provider.dart';
import 'edit_cart_item.dart';

class TransactionItem extends StatefulWidget {
  final Map cartItem;

  const TransactionItem({
    required this.cartItem,
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Book? book;

  @override
  void initState() {
    super.initState();
    _loadBookData();
  }

  // Async method to load book data
  void _loadBookData() async {
    try {
      String sql =
          "SELECT * FROM books WHERE id_book = ${widget.cartItem['id_book']}";
      List<Map> response =
      await Database.database.readData(sql);

      if (response.isNotEmpty) {
        Map e = response[0];
        setState(() {
          book = Book(
              price: e['price'],
              title: e['title'],
              author: e['author'],
              category_id: e['id_cat'],
              quantity: e['quantity'],
              cover_URL: "assets/images/${e['cover_URL']}",
              edition: e['edition'],
              id_book: e['id_book']);
        });
      } else {
        setState(() {
          book = null;
        });
      }
    } catch (e) {
      setState(() {
        book = null;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return Center(child: CircularProgressIndicator()); // Loading state
    }

    CartProvider cartProvider = Provider.of<CartProvider>(context);
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
              child: Text("${book?.title ?? 'Loading...'}"),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Pendding"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

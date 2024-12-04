import 'package:design_pattern/book.dart';
import 'package:design_pattern/cart_provider.dart';
import 'package:design_pattern/edit_cart_item.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:design_pattern/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  final int customer_id;

  const CartPage({required this.customer_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) =>
            CartProvider(customer_id: customer_id),
        child: Column(
          children: [
            Expanded(child: ListViewWidget()),
            Expanded(child: ListViewWidget1()),
          ],
        ),
      ),
    );
  }
}
class ListViewWidget1 extends StatefulWidget {
  @override
  State<ListViewWidget1> createState() => _ListViewWidget1State();
}
class _ListViewWidget1State extends State<ListViewWidget1> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cartProvider = Provider.of<CartProvider>(context);
    cartProvider.loadTransictionData();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return ListView.builder(
      itemCount: cartProvider.transactionsItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartProvider.transactionsItems[index];
        return TransactionItem(cartItem: cartItem);
      },
    );
  }
}

class ListViewWidget extends StatefulWidget {
  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}
class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cartProvider = Provider.of<CartProvider>(context);
    cartProvider.loadCartData();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return ListView.builder(
      itemCount: cartProvider.cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartProvider.cartItems[index];
        return CartItemWidget(
          cartItem: cartItem, // Pass function as callback
        );
      },
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final Map cartItem;

  const CartItemWidget({
    required this.cartItem,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    onPressed: () async {
                      if (book != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCartItem(
                              cartItem: widget.cartItem,
                              book: book!,
                              id_customer: cartProvider.customer_id,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.amber),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      cartProvider.removeCartItem(widget.cartItem);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.amber),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent),
                    onPressed: () {
                      cartProvider.buyCartItem(widget.cartItem);
                    },
                    child: Text(
                      "Buy",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

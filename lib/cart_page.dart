import 'package:design_pattern/book.dart';
import 'package:design_pattern/cart_provider.dart';
import 'package:design_pattern/edit_cart_item.dart';
import 'package:design_pattern/single_data_base.dart';
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
        child: ListViewWidget(),
      ),
    );
  }
}

class ListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.loadCartData();
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

class CartItemWidget extends StatelessWidget {
  final Map cartItem;

  const CartItemWidget({
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Text("book name"),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    onPressed: () async {
                      String sql =
                          "SELECT * FROM books WHERE id_book = ${cartItem['id_book']}";
                      List<Map> response =
                          await Database.database.readData(sql);
                      Map e = response[0];
                      Book book = Book(
                          price: e['price'],
                          title: e['title'],
                          author: e['author'],
                          category_id: e['id_cat'],
                          quantity: e['quantity'],
                          cover_URL: "assets/images/${e['cover_URL']}",
                          edition: e['edition'],
                          id_book: e['id_book']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCartItem(
                              cartItem: cartItem,
                              book: book,
                              id_customer: cartProvider.customer_id,
                            ),
                          ));
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
                      cartProvider.removeCartItem(cartItem);
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
                    onPressed: () {},
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

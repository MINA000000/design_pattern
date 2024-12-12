import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

import '../items/cart_item.dart';

class CartItems extends StatefulWidget {
  final int userId;
  CartItems({required this.userId});

  @override
  State<CartItems> createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  late Future<List<Map>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = getItems();
  }

  Future<List<Map>> getItems() async {
    String sql = "SELECT * FROM cart WHERE id_customer = ${widget.userId}";
    List<Map> res = await Database.database.readData(sql);
    return res;
  }

  void refreshItems() {
    setState(() {
      _itemsFuture = getItems(); // Refresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart Items")),
      body: FutureBuilder<List<Map>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error state
          } else if (snapshot.hasData) {
            List<Map> mydata = snapshot.data!;
            if (mydata.isEmpty) {
              return Center(child: Text("No items in cart"));
            }
            return ListView.builder(
              itemCount: mydata.length,
              itemBuilder: (context, index) {
                return CartItem(
                  item: mydata[index],
                  refreshParent: refreshItems, // Pass refresh function
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

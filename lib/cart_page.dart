import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final int customer_id;

  const CartPage({super.key, required this.customer_id});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // This will store your cart data
  List<Map> cartItems = [];

  @override
  void initState() {
    super.initState();
    // Load your data when the page is opened
    loadCartData();
  }

  // Function to simulate loading data (replace with your database query)
  Future<void> loadCartData() async {
    // Directly insert the customer_id without string interpolation
    String sql =
        "SELECT * FROM cart WHERE id_customer = ${widget.customer_id};";

    List<Map> response = await Database.database.readData(sql);
    print(response.length);

    setState(() {
      cartItems = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return CartItemWidget(cartItem: cartItem);
        },
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  final Map cartItem;

  @override
  Widget build(BuildContext context) {
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
                )),
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
                        backgroundColor: Colors.red
                    ),
                    onPressed: () async{

                    },
                    child: Text("Delete",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.amber),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent
                    ),
                    onPressed: () {},
                    child: Text("Buy",style: TextStyle(fontWeight: FontWeight.bold),),
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

import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Map> _cartItems = [];
  int customer_id;

  List<Map> get cartItems => _cartItems;

  CartProvider({required this.customer_id});

  // Method to load cart data (simulate or fetch from the database)
  Future<void> loadCartData() async {
    // Simulating data fetch (replace with your actual database call)
    String sql = "SELECT * FROM cart WHERE id_customer = $customer_id;";
    List<Map> response = await Database.database.readData(sql); // Database call

    _cartItems = response;
    notifyListeners(); // Notify listeners when data is updated
  }

  // Method to remove a cart item
  Future<void> removeCartItem(Map cartItem) async {
    String sql =
        "DELETE FROM 'CART' WHERE id_customer=${cartItem['id_customer']} AND id_book=${cartItem['id_book']}";
    int response =
        await Database.database.deleteData(sql); // Database delete call
    print(response);
    _cartItems.remove(cartItem); // Remove item from list
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> editCartItem(Map cartItem, int newQuantity) async {
    // Construct the SQL query to update the quantity
    String sql = """
    UPDATE CART 
    SET quantity = $newQuantity 
    WHERE id_customer = ${cartItem['id_customer']} 
    AND id_book = ${cartItem['id_book']};
  """;

    // Execute the update query
    int response = await Database.database
        .updateData(sql); // Assuming `updateData` is the correct method
    print(response);
    if (response > 0) {
      // If the update is successful, modify the local cart item
      cartItem['quantity'] =
          newQuantity; // Update the quantity in the local cart list
      notifyListeners(); // Notify listeners to update the UI
    }
  }
}

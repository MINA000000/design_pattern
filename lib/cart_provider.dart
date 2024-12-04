import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Map> _cartItems = [];

  List<Map> get cartItems => _cartItems;

  // Method to load cart data (simulate or fetch from the database)
  Future<void> loadCartData(int customerId) async {
    // Simulating data fetch (replace with your actual database call)
    String sql = "SELECT * FROM cart WHERE id_customer = $customerId;";
    List<Map> response = await Database.database.readData(sql); // Database call

    _cartItems = response;
    notifyListeners(); // Notify listeners when data is updated
  }

  // Method to remove a cart item
  Future<void> removeCartItem(Map cartItem) async {
    String sql = "DELETE FROM 'CART' WHERE id_customer=${cartItem['id_customer']} AND id_book=${cartItem['id_book']}";
    int response = await Database.database.deleteData(sql); // Database delete call
    print(response);
    _cartItems.remove(cartItem); // Remove item from list
    notifyListeners(); // Notify listeners to update the UI

  }

  // Method to increment (if needed)
  void increment() {
    // Your increment logic
    notifyListeners(); // Notify listeners after updating
  }
}

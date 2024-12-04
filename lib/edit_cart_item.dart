import 'package:design_pattern/book.dart';
import 'package:design_pattern/cart_provider.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCartItem extends StatefulWidget {
  final Map cartItem;
  final Book book;
  final int id_customer;

  EditCartItem(
      {required this.book, required this.id_customer, required this.cartItem});

  @override
  State<EditCartItem> createState() => _EditCartItemState();
}

class _EditCartItemState extends State<EditCartItem> {
  int _selectedQuantity = 1;
  String buttonName = "Confirm";
  Color color = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Cart Item",
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.book.cover_URL),
            const SizedBox(height: 20),
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 24),
            ),
            Text("Price: ${widget.book.price}"),
            Text("Quantity available: ${widget.book.quantity}"),
            Text("Edition: ${widget.book.edition}"),
            const SizedBox(height: 20),
            Text(
              "Select Quantity:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Customized dropdown
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<int>(
                value: _selectedQuantity,
                isExpanded: true,
                underline: SizedBox(),
                // Remove default underline
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                items: List.generate(
                  widget.book.quantity,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onChanged: (value) {
                  _selectedQuantity = value!;
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Construct the SQL query to update the quantity
                  String sql = """
                    UPDATE CART 
                    SET quantity = $_selectedQuantity 
                    WHERE id_customer = ${widget.cartItem['id_customer']} 
                    AND id_book = ${widget.cartItem['id_book']};
                  """;

                  // Execute the update query
                  int response = await Database.database.updateData(
                      sql); // Assuming `updateData` is the correct method
                  print(response);
                  if (response > 0) {
                    buttonName = "Done";
                    color = Colors.green;
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                ),
                child: Text(
                  buttonName,
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

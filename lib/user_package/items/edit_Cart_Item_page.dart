import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class EditCartItemPage extends StatefulWidget {
  final Map item;
  final int bookQuantity;

  EditCartItemPage({required this.item, required this.bookQuantity});

  @override
  _EditCartItemPageState createState() => _EditCartItemPageState();
}

class _EditCartItemPageState extends State<EditCartItemPage> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item['quantity'];
  }

  Future<void> updateCartItemQuantity() async {
    String sql = '''
      UPDATE cart SET quantity = $_quantity 
      WHERE id_customer = ${widget.item['id_customer']} AND id_book = ${widget.item['id_book']}
    ''';
    int res = await Database.database.updateData(sql);
    print(_quantity);
    print(res);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Quantity")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Book: ${widget.item['id_book']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Available: ${widget.bookQuantity}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _quantity > 1
                      ? () => setState(() {
                    _quantity--;
                  })
                      : null,
                ),
                Text(
                  "$_quantity",
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _quantity < widget.bookQuantity
                      ? () => setState(() {
                    _quantity++;
                  })
                      : null,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateCartItemQuantity,
              child: Text("Update Quantity"),
            ),
          ],
        ),
      ),
    );
  }
}

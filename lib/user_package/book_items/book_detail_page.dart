import 'package:flutter/material.dart';
import 'package:design_pattern/user_package/book_items/book.dart';
import 'package:design_pattern/single_data_base.dart';
import 'comments_page.dart'; // Import the CommentsPage file

class BookDetailPage extends StatefulWidget {
  final Book book;
  final int id_customer;

  const BookDetailPage({required this.book, required this.id_customer});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  int _selectedQuantity = 1; // Default selected quantity is 1
  ButtonState _buttonState = AddToCartState(); // Default state is "Add To Cart"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.book.cover_URL,
              width: 183,
              height: 275,
              fit: BoxFit.cover,
            ),
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
                  setState(() {
                    _selectedQuantity = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: _buttonState.isEnabled
                    ? () async {
                  List<Map> response = await Database.database.readData(
                      "SELECT * FROM 'cart' WHERE id_book = ${widget.book.id_book} AND id_customer = ${widget.id_customer}");
                  if (response.isNotEmpty) {
                    int newQuantity =
                        response[0]['quantity'] + _selectedQuantity;
                    String updateSql = '''
                            UPDATE cart
                            SET quantity = $newQuantity
                            WHERE id_customer = ${widget.id_customer}
                            AND id_book = ${widget.book.id_book}
                          ''';
                    int updateRes =
                    await Database.database.updateData(updateSql);
                    if (updateRes >= 1) {
                      setState(() {
                        _buttonState = UpdatedState();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Book quantity updated in cart")),
                      );
                    }
                  } else {
                    String insertSql = '''
                            INSERT INTO cart (id_customer, id_book, quantity)
                            VALUES (${widget.id_customer}, ${widget.book.id_book}, $_selectedQuantity);
                          ''';
                    int insertRes =
                    await Database.database.insertData(insertSql);
                    if (insertRes >= 1) {
                      setState(() {
                        _buttonState = AddedState();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Book added to cart")),
                      );
                    }
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonState.color,
                ),
                child: Text(
                  _buttonState.label,
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CommentsPage(bookId: widget.book.id_book),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  "View Comments",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// Abstract ButtonState class
abstract class ButtonState {
  String get label; // Label for the button
  bool get isEnabled; // Whether the button is enabled
  Color get color; // Button color
}

/// AddToCart state
class AddToCartState implements ButtonState {
  @override
  String get label => "Add To Cart";

  @override
  bool get isEnabled => true;

  @override
  Color get color => Colors.blue;
}

/// Updated state
class UpdatedState implements ButtonState {
  @override
  String get label => "Updated";

  @override
  bool get isEnabled => false;

  @override
  Color get color => Colors.grey;
}

/// Added state
class AddedState implements ButtonState {
  @override
  String get label => "Added";

  @override
  bool get isEnabled => false;

  @override
  Color get color => Colors.green;
}

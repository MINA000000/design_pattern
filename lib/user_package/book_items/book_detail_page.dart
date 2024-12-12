import 'package:design_pattern/user_package/book_items/book.dart';
import 'package:design_pattern/user_package/cart_package/cart_page.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;
  final int id_customer;
  const BookDetailPage({required this.book, required this.id_customer});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  int _selectedQuantity = 1; // Default selected quantity is 1
  String buttonName = "Add To Cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
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
                underline: SizedBox(), // Remove default underline
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
                onPressed: () async {
                  List<Map> response = await Database.database.readData("SELECT * FROM 'cart'");
                  bool exist = false;
                  for(int i=0;i<response.length;i++)
                    {
                      if(response[i]['id_book']==widget.book.id_book&&response[i]['id_customer']==widget.id_customer)
                        {
                          exist = true;
                          break;
                        }
                    }
                  if(exist==true)
                    {
                        setState(() {
                          buttonName = "Already exist";
                        });
                    }
                  else 
                    {
                      String sql ="INSERT INTO cart (id_customer, id_book, quantity) VALUES (${widget.id_customer}, ${widget.book.id_book}, $_selectedQuantity);";
                      int res = await Database.database.insertData(sql);
                      print(res);
                    }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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

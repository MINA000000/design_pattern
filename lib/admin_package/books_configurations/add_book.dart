import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  // Controllers for each text field
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController coverUrlController = TextEditingController();
  final TextEditingController editionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController(); // Category as a string for simplicity

  bool isLoading = false;
  String statusMessage = "";

  // Function to insert a new book into the database
  Future<void> addBookToDatabase() async {
    setState(() {
      isLoading = true;
      statusMessage = "";
    });

    // Get input values
    String title = titleController.text;
    String author = authorController.text;
    double price = double.tryParse(priceController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    String coverUrl = coverUrlController.text;
    String edition = editionController.text;
    int categoryId = int.tryParse(categoryController.text) ?? 0; // Assuming category ID is entered as integer

    // Validate inputs (basic validation)
    if (title.isEmpty || author.isEmpty || price <= 0 || quantity <= 0 || coverUrl.isEmpty || edition.isEmpty || categoryId <= 0) {
      setState(() {
        statusMessage = "Please fill all fields with valid data!";
        isLoading = false;
      });
      return;
    }

    // Open your database

    // Insert new book into the 'books' table
    int result = await Database.database.insertData('''
  INSERT INTO books (price, title, author, id_cat, quantity, cover_URL, edition) 
  VALUES ($price, '$title', '$author', $categoryId, $quantity, '$coverUrl', '$edition')
  ''');


    // Provide feedback to the user
    if (result > 0) {
      setState(() {
        statusMessage = "Book added successfully!";
      });
    } else {
      setState(() {
        statusMessage = "Failed to add the book.";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Book"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Enter Book Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: coverUrlController,
              decoration: InputDecoration(labelText: 'Cover URL'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: editionController,
              decoration: InputDecoration(labelText: 'Edition'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: categoryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Category ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : addBookToDatabase,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Add Book",style: TextStyle(color: Colors.black),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (statusMessage.isNotEmpty)
              Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: statusMessage.contains("successfully")
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

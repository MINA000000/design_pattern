import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController coverUrlController = TextEditingController();
  final TextEditingController editionController = TextEditingController();

  bool isLoading = false;
  String statusMessage = "";
  Map<String, int> categories = {}; // Map to store category names and their IDs
  String? selectedCategory; // To store the currently selected category name

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Load categories when the widget is initialized
  }

  Future<void> fetchCategories() async {
    try {
      // Fetch categories from the database
      List<Map> res = await Database.database.readData("SELECT id_category, category_name FROM categories");
      setState(() {
        categories = {for (var row in res) row['category_name']: row['id_category']};
      });
    } catch (e) {
      setState(() {
        statusMessage = "Failed to load categories: $e";
      });
    }
  }

  Future<void> addBookToDatabase() async {
    setState(() {
      isLoading = true;
      statusMessage = "";
    });

    String title = titleController.text;
    String author = authorController.text;
    double price = double.tryParse(priceController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    String coverUrl = coverUrlController.text;
    String edition = editionController.text;
    int? categoryId = categories[selectedCategory]; // Get the selected category's ID

    if (title.isEmpty || author.isEmpty || price <= 0 || quantity <= 0 || coverUrl.isEmpty || edition.isEmpty || categoryId == null) {
      setState(() {
        statusMessage = "Please fill all fields with valid data!";
        isLoading = false;
      });
      return;
    }

    int result = await Database.database.insertData('''
      INSERT INTO books (price, title, author, id_cat, quantity, cover_URL, edition) 
      VALUES ($price, '$title', '$author', $categoryId, $quantity, '$coverUrl', '$edition')
    ''');

    setState(() {
      statusMessage = result > 0 ? "Book added successfully!" : "Failed to add the book.";
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
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: Text("Select Category"),
              items: categories.keys.map((categoryName) {
                return DropdownMenuItem(
                  value: categoryName,
                  child: Text(categoryName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : addBookToDatabase,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                "Add Book",
                style: TextStyle(color: Colors.black),
              ),
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

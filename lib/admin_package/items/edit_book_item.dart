import 'package:flutter/material.dart';
import '../../single_data_base.dart';
class EditBookItem extends StatefulWidget {
   Map bookItem;
  final Function() onMessageChanged;
  EditBookItem({required this.bookItem,required this.onMessageChanged});

  @override
  _EditBookItemState createState() => _EditBookItemState();
}

class _EditBookItemState extends State<EditBookItem> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _editionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.bookItem['title']);
    _authorController = TextEditingController(text: widget.bookItem['author']);
    _priceController = TextEditingController(
        text: widget.bookItem['price'].toString());
    _quantityController = TextEditingController(
        text: widget.bookItem['quantity'].toString());
    _editionController = TextEditingController(text: widget.bookItem['edition']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _editionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Container(
              height: 250, // Set the desired height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200, // Height for the image
                    child: Image.asset(
                      "assets/images/${widget.bookItem['cover_URL']}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.bookItem['title'],
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _authorController,
                    decoration: InputDecoration(labelText: 'Author'),
                  ),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price'),
                  ),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                  TextField(
                    controller: _editionController,
                    decoration: InputDecoration(labelText: 'Edition'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Save updated book details
                      Map updatedBook = {
                        'id_book': widget.bookItem['id_book'],
                        'title': _titleController.text,
                        'author': _authorController.text,
                        'price': double.tryParse(_priceController.text) ?? 0.0,
                        'quantity': int.tryParse(_quantityController.text) ?? 0,
                        'edition': _editionController.text,
                        'cover_URL': widget.bookItem['cover_URL'],
                        'id_cat': widget.bookItem['id_cat'],
                      };

                      // Create the SQL update query with proper formatting
                      String sql = '''
                        UPDATE books
                        SET
                          price = ${updatedBook['price']},
                          title = '${updatedBook['title']}',
                          author = '${updatedBook['author']}',
                          id_cat = ${updatedBook['id_cat']},
                          quantity = ${updatedBook['quantity']},
                          cover_URL = '${updatedBook['cover_URL']}',
                          edition = '${updatedBook['edition']}'
                        WHERE id_book = ${updatedBook['id_book']};
                      ''';

                      // Execute the update query
                      int res = await Database.database.updateData(sql);
                      // Check if the update was successful
                      if (res >= 1) {
                        widget.bookItem = updatedBook;
                        print("Successfully updated the book.");
                        widget.onMessageChanged();
                        setState(() {

                        });
                      } else {
                        print("Something went wrong while updating the book.");
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

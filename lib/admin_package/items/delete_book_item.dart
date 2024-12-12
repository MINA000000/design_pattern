import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class DeleteBookItem extends StatefulWidget {
  Map bookItem;// Assuming the book ID will be passed to this widget

  DeleteBookItem({required this.bookItem});

  @override
  _DeleteBookItemState createState() => _DeleteBookItemState();
}

class _DeleteBookItemState extends State<DeleteBookItem> {
  bool isLoading = false;
  String statusMessage = "";

  Future<void> deleteBookIfNoTransactions() async {
    setState(() {
      isLoading = true;
      statusMessage = "";
    });

    List<Map> transactions = await Database.database.readData('''
      SELECT * FROM transactions WHERE id_book = ${widget.bookItem['id_book']}
    ''');

    if (transactions.isEmpty) {
      // No transactions, safe to delete the book
      int result = await Database.database.deleteData('''
        DELETE FROM books WHERE id_book = ${widget.bookItem['id_book']}
      ''');

      if (result > 0) {
        setState(() {
          statusMessage = "Book deleted successfully!";
        });
      } else {
        setState(() {
          statusMessage = "Failed to delete the book.";
        });
      }
    } else {
      // Book cannot be deleted because it has related transactions
      setState(() {
        statusMessage = "This book cannot be deleted because it has transactions.";
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
        title: Text("Delete Book"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Delete Book",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : () => deleteBookIfNoTransactions(),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Padding(padding:EdgeInsets.symmetric(horizontal: 5),child: Text("Delete",style: TextStyle(color: Colors.black,fontSize: 20),)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
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
      ),
    );
  }
}

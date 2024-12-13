import 'package:flutter/material.dart';
import '../../single_data_base.dart';

class AddCommentPage extends StatefulWidget {
  final int userId;
  final int bookId;

  AddCommentPage({required this.userId, required this.bookId});

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final TextEditingController _commentController = TextEditingController();
  String? _errorMessage;

  Future<void> saveComment() async {
    String comment = _commentController.text.trim();

    if (comment.isEmpty) {
      setState(() {
        _errorMessage = "Comment cannot be empty.";
      });
      return;
    }

    // Check if a comment already exists for this user and book
    String checkQuery = '''
      SELECT COUNT(*) AS count FROM comments 
      WHERE id_customer = ${widget.userId} AND id_book = ${widget.bookId}
    ''';
    List<Map> result = await Database.database.readData(checkQuery);
    int count = result[0]['count'];

    if (count > 0) {
      setState(() {
        _errorMessage = "You have already added a comment for this book.";
      });
      return;
    }

    // Insert the new comment
    String insertQuery = '''
      INSERT INTO comments (id_customer, id_book, comment)
      VALUES (${widget.userId}, ${widget.bookId}, '$comment')
    ''';
    await Database.database.insertData(insertQuery);

    // Navigate back after saving
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: "Your Comment",
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveComment,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

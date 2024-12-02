import 'package:design_pattern/book.dart';
import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(book.coverURL),
            SizedBox(height: 20),
            Text(
              book.title,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:design_pattern/single_data_base.dart';

class CommentsPage extends StatelessWidget {
  final int bookId;
  final List<String> names = [];
  CommentsPage({required this.bookId});

  Future<List<Map>> fetchComments() async {
    String sql = '''
      SELECT * FROM comments WHERE id_book = $bookId;
    ''';
    List<Map> res = await Database.database.readData(sql);
    for(int i=0;i<res.length;i++)
      {
        Map e = res[i];
        String s = "SELECT * FROM customers WHERE id_customer=${e['id_customer']};";
        List<Map> ans = await Database.database.readData(s);
        names.add(ans[0]['username']);
      }
    print(res);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: FutureBuilder<List<Map>>(
        future: fetchComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No comments found for this book.'));
          } else {
            List<Map> comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                Map comment = comments[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          names[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(comment['comment'].toString()),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

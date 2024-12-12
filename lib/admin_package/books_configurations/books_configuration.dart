import 'package:design_pattern/admin_package/books_configurations/add_book.dart';
import 'package:design_pattern/admin_package/books_configurations/delete_book.dart';
import 'package:design_pattern/admin_package/books_configurations/edit_book.dart';
import 'package:flutter/material.dart';

class BooksConfiguration extends StatelessWidget {
  const BooksConfiguration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books Configuration"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Manage Books",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook(),));
              },
              icon: Icon(Icons.add, size: 24,color: Colors.white,),
              label: Text(
                "Add Books",
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Edit book action
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditBook(),));
              },
              icon: Icon(Icons.edit, size: 24),
              label: Text(
                "Edit Books",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteBook(),));
              },
              icon: Icon(Icons.delete, size: 24),
              label: Text(
                "Delete Books",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// class BooksConfiguration extends StatelessWidget {
//   Future<List<Map>> fetchBooks() async {
//     List<Map> response = await Database.database.readData("SELECT * FROM 'books'");
//     return response;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(future: fetchBooks(), builder:
//       (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Loading state
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}'); // Error state
//         } else if (snapshot.hasData) {
//           final books = snapshot.data!;
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 0.7,
//             ),
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BookItem(bookItem: books[index]),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   elevation: 4,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Image.asset(
//                           books[index].cover_URL,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           books[index].title,
//                           style: TextStyle(fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//           } else {
//           return Text('No data available');
//         }
//       },),
//     );
//   }
// }

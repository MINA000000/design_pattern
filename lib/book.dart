
class Book {
  final int id_book;
  final double price ;
  final String title ;
  final String author ;
  final int category_id;
  final int quantity;
  final String cover_URL;
  final String edition;
  Book({required this.price, required this.title, required this.author, required this.category_id, required this.quantity, required this.cover_URL,required this.edition,required this.id_book});

}
// id_book INTEGER PRIMARY KEY AUTOINCREMENT,
// price REAL NOT NULL,
//     title TEXT NOT NULL,
// author TEXT NOT NULL,
//     id_cat INTEGER NOT NULL,
// quantity INTEGER NOT NULL,
//     cover_URL TEXT NOT NULL,
// edition TEXT NOT NULL,
//     FOREIGN KEY (id_cat) REFERENCES categories(id_category)
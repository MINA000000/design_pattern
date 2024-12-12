// Define the Prototype interface with the clone method
abstract class Prototype {
  Prototype clone();
}

class Book implements Prototype {
   int id_book;
   double price;
   String title;
   String author;
   int category_id;
   int quantity;
   String cover_URL;
   String edition;

  // Constructor for the Book class
  Book({
    required this.id_book,
    required this.price,
    required this.title,
    required this.author,
    required this.category_id,
    required this.quantity,
    required this.cover_URL,
    required this.edition,
  });

  // Implement the clone method
  @override
  Book clone() {
    return Book(
      id_book: this.id_book,
      price: this.price,
      title: this.title,
      author: this.author,
      category_id: this.category_id,
      quantity: this.quantity,
      cover_URL: this.cover_URL,
      edition: this.edition,
    );
  }

  // To represent the object as a string for easy debugging
  @override
  String toString() {
    return "Book(id_book: $id_book, title: $title, author: $author, price: $price, quantity: $quantity, edition: $edition)";
  }
}

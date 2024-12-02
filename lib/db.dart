import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class Db {
  static Database? _db;
  Future<Database?> get db async{
    if(_db==null)
    {
      _db = await initialDb();
    }
    return _db;
  }
  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath,'mina.db');
    Database mydb = await openDatabase(path,onCreate: _onCreate,version: 8,onUpgrade: _onUpgrade);
    return mydb;
  }
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
      await db.execute('PRAGMA foreign_keys = ON;');
      await db.execute('DROP TABLE IF EXISTS notes');
      await db.execute('DROP TABLE IF EXISTS categories');
      await db.execute('DROP TABLE IF EXISTS books');
      await db.execute('DROP TABLE IF EXISTS customers');
      await db.execute('DROP TABLE IF EXISTS cart');
      await db.execute('DROP TABLE IF EXISTS transactions');
      await db.execute('DROP TABLE IF EXISTS status');
      await db.execute('DROP TABLE IF EXISTS comments');

      await db.execute('''
      CREATE TABLE categories (
        id_category INTEGER PRIMARY KEY AUTOINCREMENT,
        category_name TEXT NOT NULL
      );
    ''');

      await db.execute('''
      CREATE TABLE books (
        id_book INTEGER PRIMARY KEY AUTOINCREMENT,
        price REAL NOT NULL,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        id_cat INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        cover_URL TEXT NOT NULL,
        edition TEXT NOT NULL,
        FOREIGN KEY (id_cat) REFERENCES categories(id_category)
      );
    ''');

      await db.execute('''
        CREATE TABLE customers (
          id_customer INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT NOT NULL UNIQUE,  
          username TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          address TEXT NOT NULL,
          phone TEXT NOT NULL
        );
      ''');


      await db.execute('''
      CREATE TABLE cart (
        id_customer INTEGER NOT NULL,
        id_book INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (id_customer) REFERENCES customers(id_customer),
        FOREIGN KEY (id_book) REFERENCES books(id_book)
      );
    ''');

      await db.execute('''
      CREATE TABLE transactions (
        id_customer INTEGER NOT NULL,
        id_book INTEGER NOT NULL,
        id_status INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (id_customer) REFERENCES customers(id_customer),
        FOREIGN KEY (id_book) REFERENCES books(id_book),
        FOREIGN KEY (id_status) REFERENCES status(id_status)
      );
    ''');

      await db.execute('''
      CREATE TABLE status (
        id_status INTEGER PRIMARY KEY AUTOINCREMENT,
        status TEXT NOT NULL
      );
    ''');

      await db.execute('''
      CREATE TABLE comments (
        id_customer INTEGER NOT NULL,
        id_book INTEGER NOT NULL,
        comment TEXT NOT NULL,
        PRIMARY KEY (id_customer, id_book),
        FOREIGN KEY (id_customer) REFERENCES customers(id_customer),
        FOREIGN KEY (id_book) REFERENCES books(id_book)
      );
    ''');

      //////////////////////////////////////////////////////////

      await db.insert('categories', {'category_name': 'Science'});
      await db.insert('categories', {'category_name': 'Fantasy'});
      await db.insert('categories', {'category_name': 'Fiction'});

      //////////////////////////////////////////////////////////

      await db.insert('books', {
        'price': 19.99,
        'title': 'The Fallen Gates',
        'author': 'G. M. GABRIELS',
        'id_cat': 3, // Fiction category
        'quantity': 3,
        'cover_URL': 'fiction1.jpeg',
        'edition': '1st Edition'
      });
      await db.insert('books', {
        'price': 29.99,
        'title': 'The Past Is Rising',
        'author': 'KATHRYN BYWATERS',
        'id_cat': 3, // Fiction category
        'quantity': 10,
        'cover_URL': 'fiction2.jpeg',
        'edition': '1st Edition'
      });
      await db.insert('books', {
        'price': 39.99,
        'title': 'The disguised princess',
        'author': 'ASIS BLYTHE',
        'id_cat': 3, // Fiction category
        'quantity': 17,
        'cover_URL': 'fiction3.jpeg',
        'edition': '1st Edition'
      });
      await db.insert('books', {
        'price': 19.99,
        'title': 'A Short History Of Physics',
        'author': 'KAREN ARMS',
        'id_cat': 1, // Fiction category
        'quantity': 3,
        'cover_URL': 'science1.jpeg',
        'edition': '1st Edition'
      });
      await db.insert('books', {
        'price': 29.99,
        'title': 'Latest Science Discoveries',
        'author': 'KEN ADAMS',
        'id_cat': 1, // Fiction category
        'quantity': 10,
        'cover_URL': 'science2.jpeg',
        'edition': '1st Edition'
      });
      await db.insert('books', {
        'price': 39.99,
        'title': 'A Short History of Biology',
        'author': 'Helena cartis',
        'id_cat': 1, // Fiction category
        'quantity': 17,
        'cover_URL': 'science3.jpeg',
        'edition': '1st Edition'
      });
      await db.insert('books', {
        'price': 19.99,
        'title': 'A court ravens',
        'author': 'layla blue',
        'id_cat': 2, // Fiction category
        'quantity': 3,
        'cover_URL': 'fantasy1.jpeg',
        'edition': '1st Edition'
      });
      await db.insert('books', {
        'price': 29.99,
        'title': 'The TEMPSET',
        'author': 'James Holland',
        'id_cat': 2, // Fiction category
        'quantity': 10,
        'cover_URL': 'fantasy2.jpeg',
        'edition': '2st Edition'
      });
      await db.insert('books', {
        'price': 39.99,
        'title': 'Magic Hour',
        'author': 'Mina Nasser',
        'id_cat': 2, // Fiction category
        'quantity': 17,
        'cover_URL': 'fantasy3.jpeg',
        'edition': '2st Edition'
      });

      //////////////////////////////////////////////////////////

      await db.insert('customers', {
        'email': 'johndoe@example.com',
        'username': 'johndoe',
        'password': 'password123',
        'address': '123 Main St',
        'phone': '123-456-7890'
      });
      await db.insert('customers', {
        'email': 'janesmith@example.com',
        'username': 'janesmith',
        'password': 'password456',
        'address': '456 Elm St',
        'phone': '987-654-3210'
      });

      //////////////////////////////////////////////////////////

      await db.insert('status', {'status': 'Completed'});
      await db.insert('status', {'status': 'Pending'});

      //////////////////////////////////////////////////////////



      print("Database upgraded and insertion complete to version {$newVersion} ==============================");

  }

  _onCreate(Database db,int version) async{
    await db.execute('''
      CREATE TABLE notes(
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "note" TEXT NOT NULL
      )
    ''');
    print("database craeted ==============================");
  }
  readData(String sql) async{
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }
  insertData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }
  updateData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }
  deleteData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}
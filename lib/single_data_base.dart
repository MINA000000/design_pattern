import 'package:design_pattern/db.dart';

class Database {
  static final Database _instance = Database._internal(); // Singleton instance

  // Private constructor
  Database._internal();

  // Factory constructor to return the singleton instance
  factory Database() {
    return _instance;
  }

  static Db database = Db();
}

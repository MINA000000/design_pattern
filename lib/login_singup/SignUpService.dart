import '../db.dart';

abstract class SignUpService {
  final Db database = Db();

  Future<bool> isEmailOrNameTaken(String email, String name);

  Future<int> registerUser(String email, String password, String name, String address, String phone);
}

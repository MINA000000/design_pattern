import 'SignUpService.dart';

class ConcreteSignupProxy extends SignUpService {
  ConcreteSignupProxy();

  @override
  Future<bool> isEmailOrNameTaken(String email, String name) async {
    String sql = "SELECT * FROM customers WHERE email = '$email' OR username = '$name'";
    var result = await database.readData(sql);
    return result.isNotEmpty;
  }

  @override
  Future<int> registerUser(String email, String password, String name, String address, String phone) async {
    String sql = '''
      INSERT INTO customers (email, password, username, address, phone)
      VALUES ('$email', '$password', '$name', '$address', '$phone');
    ''';
    return await database.insertData(sql);
  }
}

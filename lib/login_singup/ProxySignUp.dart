import 'SignUpService.dart';
import 'ConcreteSignupProxy.dart';

class ProxySignUp extends SignUpService {
  final ConcreteSignupProxy concreteProxy = ConcreteSignupProxy();

  @override
  Future<bool> isEmailOrNameTaken(String email, String name) async {
    return await concreteProxy.isEmailOrNameTaken(email, name);
  }

  @override
  Future<int> registerUser(String email, String password, String name, String address, String phone) async {
    if (await isEmailOrNameTaken(email, name)) {
      // print("Email or Name already exists! Please use a different one.");
      return -1;
    }
    return await concreteProxy.registerUser(email, password, name, address, phone);
  }
}

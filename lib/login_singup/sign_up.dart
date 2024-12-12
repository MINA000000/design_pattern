import 'package:design_pattern/user_package/user_main_page.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isEmailTaken = false;
  bool isNameTaken = false;
  bool isFieldEmpty = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Email TextField
          TextFieldWidget(hintText: "Enter your Email", textInputType: TextInputType.emailAddress, controller: _emailController, icon: Icons.email, isTaken: isEmailTaken, isFieldEmpty: isFieldEmpty, labelText: "email"),
          TextFieldWidget(hintText: "Enter your Name", textInputType: TextInputType.text, controller: _nameController, icon: Icons.person, isTaken: isNameTaken, isFieldEmpty: isFieldEmpty, labelText: "name"),
          TextFieldWidget(hintText: "Enter your Password", textInputType: TextInputType.visiblePassword, controller: _passwordController, icon: Icons.password, isTaken: false, isFieldEmpty: isFieldEmpty, labelText: "Password"),
          TextFieldWidget(hintText: "Enter your Address", textInputType: TextInputType.text, controller: _addressController, icon: Icons.location_history, isTaken: false, isFieldEmpty: isFieldEmpty, labelText: "Address"),
          TextFieldWidget(hintText: "Enter your phone number", textInputType: TextInputType.number, controller: _phoneController, icon: Icons.phone, isTaken: false, isFieldEmpty: isFieldEmpty, labelText: "Phone Number"),
          SizedBox(height: 10),
          // Sign Up Button
          Center(
            child: SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // String sql = "SELECT * FROM customers";
                  // List<Map> response = await Database.database.readData(sql);
                  // print(response);
                  // return;
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String name = _nameController.text;
                  String address = _addressController.text;
                  String phone = _phoneController.text;

                  // Step 1: Check if any field is empty
                  setState(() {
                    isFieldEmpty = email.isEmpty || name.isEmpty || password.isEmpty || address.isEmpty || phone.isEmpty;
                  });

                  // Step 2: Check if email or name already exists in the database
                  if (!isFieldEmpty) {
                    String checkEmailSql = "SELECT * FROM customers WHERE email = '$email' OR username = '$name'";
                    var result = await Database.database.readData(checkEmailSql);

                    setState(() {
                      isEmailTaken = result.isNotEmpty && result[0]['email'] == email;
                      isNameTaken = result.isNotEmpty && result[0]['username'] == name;
                    });

                    if (isEmailTaken || isNameTaken) {
                      print(result);
                      print("Email or Name already exists! Please use a different one.");
                      return;
                    }

                    // Step 3: Insert user if no duplicates and no empty fields
                    String sql = '''
                      INSERT INTO customers (email, password, username, address, phone) 
                      VALUES ('$email', '$password', '$name', '$address', '$phone');    
                    ''';

                    int response = await Database.database.insertData(sql);

                    if (response >= 1) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => UserMainPage(id_customer: response)),
                            (Route<dynamic> route) => false, // This removes all previous routes
                      );
                      print("Sign Up successfully");
                    } else {
                      print("Failed to sign up");
                    }
                  }
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  String hintText ;
  String labelText;
  IconData icon ;
  TextInputType textInputType;
   TextEditingController controller;
   bool isTaken;
   bool isFieldEmpty;
  TextFieldWidget({required this.hintText,required this.textInputType,required this.controller,required this.icon,required this.isTaken,required this.isFieldEmpty,required this.labelText});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 50,
        child: TextField(
          obscureText: icon==Icons.password?true:false,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isTaken ? Colors.red : (isFieldEmpty ? Colors.red : Colors.grey),
                width: 1.0,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          keyboardType: textInputType,
        ),
      ),
    );
  }
}

import 'package:design_pattern/home_screen.dart';
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
          Center(
            child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isEmailTaken ? Colors.red : (isFieldEmpty ? Colors.red : Colors.grey),
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
          SizedBox(height: 10),
          // userName TextField
          Center(
            child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isNameTaken ? Colors.red : (isFieldEmpty ? Colors.red : Colors.grey),
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Password TextField
          Center(
            child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  labelText: "Password",
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFieldEmpty ? Colors.red : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ),
          SizedBox(height: 10),
          // address TextField
          Center(
            child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Enter your address",
                  labelText: "Address",
                  prefixIcon: Icon(Icons.location_history),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFieldEmpty ? Colors.red : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          SizedBox(height: 10),
          // phone TextField
          Center(
            child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: "Enter your phone number",
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFieldEmpty ? Colors.red : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Sign Up Button
          Center(
            child: SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
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
                        MaterialPageRoute(builder: (context) => HomeScreen(id_customer: response)),
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

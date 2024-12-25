import 'package:design_pattern/user_package/user_main_page.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

import 'ProxySignUp.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late ProxySignUp _proxySignUp;
  bool isEmailTaken = false;
  bool isNameTaken = false;
  bool isFieldEmpty = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _proxySignUp = ProxySignUp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Email TextField
          TextFieldWidget(
              hintText: "Enter your Email",
              textInputType: TextInputType.emailAddress,
              controller: _emailController,
              icon: Icons.email,
              isTaken: isEmailTaken,
              isFieldEmpty: isFieldEmpty,
              labelText: "email"),
          TextFieldWidget(
              hintText: "Enter your Name",
              textInputType: TextInputType.text,
              controller: _nameController,
              icon: Icons.person,
              isTaken: isNameTaken,
              isFieldEmpty: isFieldEmpty,
              labelText: "name"),
          TextFieldWidget(
              hintText: "Enter your Password",
              textInputType: TextInputType.visiblePassword,
              controller: _passwordController,
              icon: Icons.password,
              isTaken: false,
              isFieldEmpty: isFieldEmpty,
              labelText: "Password"),
          TextFieldWidget(
              hintText: "Enter your Address",
              textInputType: TextInputType.text,
              controller: _addressController,
              icon: Icons.location_history,
              isTaken: false,
              isFieldEmpty: isFieldEmpty,
              labelText: "Address"),
          TextFieldWidget(
              hintText: "Enter your phone number",
              textInputType: TextInputType.number,
              controller: _phoneController,
              icon: Icons.phone,
              isTaken: false,
              isFieldEmpty: isFieldEmpty,
              labelText: "Phone Number"),
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


                  setState(() {
                    isFieldEmpty = email.isEmpty ||
                        name.isEmpty ||
                        password.isEmpty ||
                        address.isEmpty ||
                        phone.isEmpty;
                  });


                  if (!isFieldEmpty) {


                    int response = await _proxySignUp.registerUser(email, password, name, address, phone);
                    if (response >= 1) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => UserMainPage(id_customer: response)),
                            (Route<dynamic> route) => false, // This removes all previous routes
                      );
                      print("Sign Up successfully");
                    } else {
                      print("Email or Name already exists! Please use a different one.");
                      // print("Failed to sign up");
                      setState(() {
                        isEmailTaken = true;
                        isNameTaken = true;
                      });
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
  TextFieldWidget({
    required this.hintText,
    required this.textInputType,
    required this.controller,
    required this.icon,
    required this.isTaken,
    required this.isFieldEmpty,
    required this.labelText
  });


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

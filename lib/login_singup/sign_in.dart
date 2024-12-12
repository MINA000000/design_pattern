import 'package:design_pattern/admin_package/admin_home_page.dart';
import 'package:design_pattern/home_screen.dart';
import 'package:design_pattern/single_data_base.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool fail = false;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the text fields to reset the border color
    _emailController.addListener(() {
      if (fail) {
        setState(() {
          fail = false; // Reset the failed state when user starts typing
        });
      }
    });

    _passwordController.addListener(() {
      if (fail) {
        setState(() {
          fail = false; // Reset the failed state when user starts typing
        });
      }
    });
  }

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
                      color: fail ? Colors.red : Colors.grey,
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
                      color: fail ? Colors.red : Colors.grey,
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

          // Login Button
          Center(
            child: SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  if(email=="admin")
                    {
                      if(password=="admin")
                        {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => AdminHomePage()),
                                (Route<dynamic> route) => false, // This removes all previous routes
                          );
                        }
                      else
                        {
                          setState(() {
                            fail = true;
                          });
                        }
                      return;
                    }
                  // Create the SQL query to check for the email and password
                  String sql = "SELECT * FROM customers WHERE email = '$email' AND password = '$password'";

                  // Call the readData method to execute the query
                  var result = await Database.database.readData(sql);

                  if (result.isNotEmpty) {
                    // The email and password exist in the database
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(id_customer: result[0]['id_customer'])),
                          (Route<dynamic> route) => false, // This removes all previous routes
                    );
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(customer: result[0])),);
                    // You can navigate to another screen or perform other actions here
                  } else {
                    // The email and password do not exist in the database
                    setState(() {
                      fail = true; // Mark login attempt as failed
                    });
                    print("Invalid email or password!");
                  }
                },
                child: Text(
                  "Login in",
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

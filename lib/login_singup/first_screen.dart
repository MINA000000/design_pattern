import 'package:design_pattern/login_singup/sign_in.dart';
import 'package:design_pattern/login_singup/sign_up.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn(),));
                  },
                  child: Text("Login in",style: TextStyle(color: Colors.amber,fontSize: 25,fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
            
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Center(
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp(),));
                },
                child: Text("Sign Up",style: TextStyle(color: Colors.amber,fontSize: 25,fontWeight: FontWeight.bold),),
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

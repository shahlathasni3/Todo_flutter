import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/loginScreen.dart';
import 'package:todo_app/services/auth_services.dart';

import 'home_screen.dart';

class signUpScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        foregroundColor: CupertinoColors.white,
        title: Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text("Welcome",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w700,color: Colors.white),),
              Text("Register Here",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white),),
              SizedBox(height: 25,),
              TextField(
                controller: _emailController,
                style: TextStyle(color: CupertinoColors.white),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white60),
                ),
              ),

              SizedBox(height: 20,),

              TextField(
                controller: _passController,
                style: TextStyle(color: CupertinoColors.white),
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white60),
                ),
              ),
              SizedBox(height: 50,),
              ElevatedButton(onPressed: () async{
                User? user = await _auth.registerWithEmailAndPassword(
                 _emailController.text,
                 _passController.text,
                );
                if(user != null){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => home_screen()));
                }
              }, child: Text("Register",style: TextStyle(color: Colors.indigo),)),
              SizedBox(height: 20,),
              Text("OR",style: TextStyle(color: Colors.white70),),
              SizedBox(height: 20,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
              },
                  child: Text("Login",style: TextStyle(color: Colors.white),),
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}

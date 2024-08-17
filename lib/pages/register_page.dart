import 'package:flutter/material.dart';
import 'package:ver_1/components/google_loginbtn.dart';
import 'package:ver_1/components/my_loginbtn.dart';
import 'package:ver_1/components/my_textfield.dart';
import 'package:ver_1/pages/home_page.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final newusernameController = TextEditingController();
  final newpasswordController = TextEditingController();
  final newpasswordConfirmController = TextEditingController();

  void homeRoute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.lock, color: Colors.black, size: 100),
                const SizedBox(height: 50),
                const Text(
                  'Let\'s get you Registered!',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                MyTextField(
                    controller: newusernameController,
                    hintText: 'Enter your new username',
                    obsecureText: false),
                const SizedBox(height: 10),
                MyTextField(
                    controller: newpasswordController,
                    hintText: 'Enter your new password',
                    obsecureText: false),
                const SizedBox(height: 10),
                MyTextField(
                    controller: newpasswordConfirmController,
                    hintText: 'Confirm your new password',
                    obsecureText: false),
                const SizedBox(height: 25),
                MyLoginBtn(
                  onTap: () => homeRoute(context),
                  buttonText: 'Register',
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400])),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Or Continue with ',
                              style: TextStyle(color: Colors.grey[700]))),
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400])),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                GoogleLoginBtn(
                    onTap: () => Null, buttonText: 'Register with Google'),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

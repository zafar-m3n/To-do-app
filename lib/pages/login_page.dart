import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ver_1/pages/home_page.dart';
import 'package:ver_1/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  late FToast fToast;

  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void _showToast(String message, bool isSuccess) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: isSuccess ? Colors.greenAccent : Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSuccess ? Icons.check : Icons.close, color: Colors.white),
          SizedBox(width: 12.0),
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }

  Future<void> loginUser() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    bool isValid = true;

    if (emailController.text.isEmpty ||
        !RegExp(r'^[\w\.\-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$').hasMatch(emailController.text)) {
      setState(() {
        emailError = 'Invalid email address.';
      });
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Password is required.';
      });
      isValid = false;
    }

    if (!isValid) {
      return;
    }

    final String baseUrl = dotenv.env['BASE_URL']!;
    final url = '$baseUrl/api/authentication/login';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      await secureStorage.write(key: 'user_data', value: jsonEncode(responseData));
      await secureStorage.write(key: 'isLoggedIn', value: 'true');

      _showToast("Login Successful.", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      _showToast("Login Failed. Please check your credentials and try again.", false);
    }
  }

  void registerRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),

                Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.blue.shade400,
                ),

                SizedBox(height: 50),

                Text(
                  'Welcome to To Do',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.blue.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 40),

                // Username TextField
                _buildTextField(
                  controller: emailController,
                  hintText: 'Email',
                  isObscure: false,
                  errorMessage: emailError,
                ),

                SizedBox(height: 20),

                // Password TextField
                _buildTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  isObscure: true,
                  errorMessage: passwordError,
                ),

                SizedBox(height: 10),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                SizedBox(height: 30),

                // Login button
                _buildLoginButton('Login', Colors.blue.shade400, Colors.white, loginUser),

                SizedBox(height: 30),

                // Continue with text
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Or Continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Google and Facebook login buttons
                _buildSocialLoginButton('Login with Google', Icons.account_circle, Colors.white, Colors.black, () {
                  // Google login functionality
                }),
                SizedBox(height: 15),
                _buildSocialLoginButton('Login with Facebook', Icons.facebook, Colors.blue.shade800, Colors.white, () {
                  // Facebook login functionality
                }),

                SizedBox(height: 25),

                // Register now text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () => registerRoute(),
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: Colors.blue.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isObscure,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blue.shade400,
                width: 2.0,
              ),
            ),
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildLoginButton(String text, Color backgroundColor, Color textColor, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildSocialLoginButton(
      String text, IconData icon, Color backgroundColor, Color textColor, VoidCallback onTap) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: textColor, size: 24),
      label: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

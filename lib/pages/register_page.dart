import 'package:flutter/material.dart';
import 'package:ver_1/components/google_loginbtn.dart';
import 'package:ver_1/components/my_loginbtn.dart';
import 'package:ver_1/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final newpasswordController = TextEditingController();

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;

  late FToast fToast;

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

  Future<void> registerUser() async {
    setState(() {
      firstNameError = null;
      lastNameError = null;
      emailError = null;
      passwordError = null;
    });

    bool isValid = true;

    if (firstNameController.text.isEmpty || firstNameController.text.length < 3 || firstNameController.text.length > 15) {
      setState(() {
        firstNameError = 'First name must be at least 3 and at most 15 characters.';
      });
      isValid = false;
    }

    if (lastNameController.text.isEmpty || lastNameController.text.length < 3 || lastNameController.text.length > 15) {
      setState(() {
        lastNameError = 'Last name must be at least 3 and at most 15 characters.';
      });
      isValid = false;
    }

    if (emailController.text.isEmpty || !RegExp(r'^[\w\.\-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$').hasMatch(emailController.text)) {
      setState(() {
        emailError = 'Invalid email address.';
      });
      isValid = false;
    }

    if (newpasswordController.text.isEmpty || 
        newpasswordController.text.length < 6 || 
        newpasswordController.text.length > 15 ||
        !RegExp(r'(?=.*[A-Z])').hasMatch(newpasswordController.text) || 
        !RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(newpasswordController.text) 
    ) {
      setState(() {
        passwordError = 'Password must be at least 6 and at most 15 characters, include at least one uppercase letter and one non-alphanumeric character.';
      });
      isValid = false;
    }

    if (!isValid) {
      return;
    }

    final String baseUrl = dotenv.env['BASE_URL']!;
    final url = '$baseUrl/api/authentication/register';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'password': newpasswordController.text,
      }),
    );

    print("Registration response: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      _showToast("Registration successful", true);
      _showToast("${response.body}", true);
    } else {
      _showToast("Registration unsuccessful", false);
      _showToast("${response.body}", false);
    }
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
                  controller: firstNameController,
                  hintText: 'Enter your first name',
                  obsecureText: false,
                ),
                if (firstNameError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        firstNameError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: lastNameController,
                  hintText: 'Enter your last name',
                  obsecureText: false,
                ),
                if (lastNameError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        lastNameError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  obsecureText: false,
                ),
                if (emailError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        emailError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: newpasswordController,
                  hintText: 'Enter your new password',
                  obsecureText: true,
                ),
                if (passwordError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        passwordError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 25),
                MyLoginBtn(
                  onTap: () => registerUser(),
                  buttonText: 'Register',
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Or Continue with ',
                            style: TextStyle(color: Colors.grey[700])),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                GoogleLoginBtn(
                  onTap: () => Null, 
                  buttonText: 'Register with Google',
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

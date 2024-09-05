import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ver_1/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

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
          const SizedBox(width: 12.0),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
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

    if (firstNameController.text.isEmpty ||
        firstNameController.text.length < 3 ||
        firstNameController.text.length > 15) {
      setState(() {
        firstNameError =
            'First name must be at least 3 and at most 15 characters.';
      });
      isValid = false;
    }

    if (lastNameController.text.isEmpty ||
        lastNameController.text.length < 3 ||
        lastNameController.text.length > 15) {
      setState(() {
        lastNameError =
            'Last name must be at least 3 and at most 15 characters.';
      });
      isValid = false;
    }

    if (emailController.text.isEmpty ||
        !RegExp(r'^[\w\.\-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$')
            .hasMatch(emailController.text)) {
      setState(() {
        emailError = 'Invalid email address.';
      });
      isValid = false;
    }

    if (newpasswordController.text.isEmpty ||
        newpasswordController.text.length < 6 ||
        newpasswordController.text.length > 15 ||
        !RegExp(r'(?=.*[A-Z])').hasMatch(newpasswordController.text) ||
        !RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])')
            .hasMatch(newpasswordController.text)) {
      setState(() {
        passwordError =
            'Password must be at least 6 and at most 15 characters, include at least one uppercase letter and one non-alphanumeric character.';
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

    if (response.statusCode == 200) {
      _showToast("Registration successful", true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      _showToast("Registration unsuccessful", false);
      _showToast(response.body, false);
    }
  }

  Future<void> _signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final user = await _googleSignIn.signIn();
      if (user == null) {
        // User canceled the sign-in process
        return;
      }

      // Retrieve the access token
      final googleAuth = await user.authentication;
      final accessToken = googleAuth.accessToken;
      final userId = user.id;

      if (accessToken != null && userId != null) {
        // Call the backend API to register with third-party credentials
        await _registerWithThirdParty(
          firstName: user.displayName?.split(' ')[0] ?? '',
          lastName: user.displayName?.split(' ')[1] ?? '',
          userId: userId,
          accessToken: accessToken,
          provider: 'google',
        );
      } else {
        _showToast('Failed to retrieve Google access token.', false);
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      _showToast('Error signing in with Google.', false);
    }
  }

  Future<void> _registerWithThirdParty({
    required String firstName,
    required String lastName,
    required String userId,
    required String accessToken,
    required String provider,
  }) async {
    final String baseUrl = dotenv.env['BASE_URL']!;
    final url = '$baseUrl/api/authentication/register-with-third-party';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'userId': userId,
        'accessToken': accessToken,
        'provider': provider,
      }),
    );

    if (response.statusCode == 200) {
      _showToast("Registration successful", true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      _showToast("Registration unsuccessful", false);
      _showToast(response.body, false);
    }
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
                const SizedBox(height: 50),
                const Icon(Icons.lock, color: Colors.blue, size: 100),
                const SizedBox(height: 50),
                const Text(
                  'Let\'s get you Registered!',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),

                // First Name TextField
                _buildTextField(
                  controller: firstNameController,
                  hintText: 'Enter your first name',
                  errorMessage: firstNameError,
                  isObscure: false,
                ),
                const SizedBox(height: 10),

                // Last Name TextField
                _buildTextField(
                  controller: lastNameController,
                  hintText: 'Enter your last name',
                  errorMessage: lastNameError,
                  isObscure: false,
                ),
                const SizedBox(height: 10),

                // Email TextField
                _buildTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  errorMessage: emailError,
                  isObscure: false,
                ),
                const SizedBox(height: 10),

                // Password TextField
                _buildTextField(
                  controller: newpasswordController,
                  hintText: 'Enter your new password',
                  errorMessage: passwordError,
                  isObscure: true,
                ),
                const SizedBox(height: 25),

                // Register button
                _buildButton('Register', Colors.blue.shade400, Colors.white,
                    registerUser),

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

                // Google button
                _buildSocialLoginButton('Register with Google',
                    Icons.account_circle, Colors.white, Colors.black, () {
                  // Google register functionality
                  _signInWithGoogle();
                }),

                const SizedBox(height: 15),

                // Facebook button (copied from login page)
                _buildSocialLoginButton('Register with Facebook',
                    Icons.facebook, Colors.blue.shade800, Colors.white, () {
                  // Facebook register functionality
                }),

                const SizedBox(height: 25),

                // Redirect to Login text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
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
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
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
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildButton(
      String text, Color backgroundColor, Color textColor, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildSocialLoginButton(String text, IconData icon,
      Color backgroundColor, Color textColor, VoidCallback onTap) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      icon: Icon(icon, color: textColor),
      onPressed: onTap,
      label: Text(
        text,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;  // Import the http package
import 'package:flutter_dotenv/flutter_dotenv.dart';  // Import dotenv for environment variables
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
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

  Future<void> resetPassword() async {
    final email = emailController.text;

    if (email.isEmpty || !RegExp(r'^[\w\.\-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$').hasMatch(email)) {
      _showToast('Please enter a valid email address.', false);
      return;
    }

    final String baseUrl = dotenv.env['BASE_URL']!;
    final url = '$baseUrl/api/authentication/forgot-username-or-password/$email';

    print("Making request to $url");

    // API call to reset password
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      _showToast('Email sent successfully to $email. ${response.body}', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      _showToast('${response.body}', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_reset,
              size: 100,
              color: Colors.blue.shade400,
            ),
            SizedBox(height: 20),
            Text(
              'Forgot Password',
              style: TextStyle(fontSize: 26, color: Colors.blue.shade400, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                fillColor: Colors.white,
                filled: true,
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPassword,
              child: Text(
                'Reset Password',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

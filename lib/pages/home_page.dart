import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ver_1/pages/add_task_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ver_1/pages/login_page.dart'; // Import LoginPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String firstName = "";
  String lastName = "";
  bool show = true; // Always show the FAB for now

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load user data from secure storage
  Future<void> _loadUserData() async {
    String? userData = await secureStorage.read(key: 'user_data');
    if (userData != null) {
      final decodedData = jsonDecode(userData);
      setState(() {
        firstName = _capitalize(decodedData['firstName'] ?? '');
        lastName = _capitalize(decodedData['lastName'] ?? '');
      });
      _fetchTaskList();
    }
  }

  // Function to fetch task list from API and show in a dialog box
  Future<void> _fetchTaskList() async {
    try {
      String? token = await secureStorage.read(key: 'user_data');
      if (token != null) {
        final decodedData = jsonDecode(token);
        final jwtToken = decodedData['jwt'];
        final String baseUrl = dotenv.env['BASE_URL']!;
        final url = '$baseUrl/api/services/get-task-list';

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken',
          },
        );

        print("GET response: ${response.statusCode}");
        print("GET Body: ${response.body}");

        if (response.statusCode == 200) {
          _showResponseDialog(response.body);
        } else {
          _showResponseDialog("Failed to load tasks. Status code: ${response.statusCode}");
        }
      }
    } catch (e) {
      _showResponseDialog("Error fetching task list: $e");
    }
  }

  // Function to show the response in a dialog box
  void _showResponseDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Task List Response"),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to capitalize the first letter of a string
  String _capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

  // Function to show profile popup
  void _showProfilePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade400,
                  child: Icon(Icons.person, size: 80, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  '$firstName $lastName',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _logout(); // Call the logout function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Logout', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to handle user logout
  Future<void> _logout() async {
    // Remove user data from secure storage
    await secureStorage.delete(key: 'user_data');
    await secureStorage.delete(key: 'isLoggedIn');
    
    // Redirect to login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove the back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hi $firstName', style: TextStyle(color: Colors.white)),
            GestureDetector(
              onTap: _showProfilePopup, // Show profile popup when tapped
              child: Icon(Icons.account_circle, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Add_Screen()),
          );
        },
        backgroundColor: Colors.blue.shade400,
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text(
          'Welcome to the new HomePage!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

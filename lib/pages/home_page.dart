import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Secure Storage
import 'package:ver_1/pages/add_task_page.dart';

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
      print(userData);
      final decodedData = jsonDecode(userData);
      setState(() {
        firstName = _capitalize(decodedData['firstName'] ?? '');
        lastName = decodedData['lastName'] ?? '';
      });
    }
  }

  // Function to capitalize the first letter of a string
  String _capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

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
            Icon(Icons.account_circle, color: Colors.white, size: 30),
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

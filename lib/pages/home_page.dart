import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ver_1/pages/login_page.dart';
import 'package:ver_1/pages/add_task_page.dart';
import 'package:ver_1/pages/edit_task_page.dart'; // Import Edit_Screen

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String firstName = "";
  String lastName = "";
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load user data and fetch tasks
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

  // Function to fetch task list from API
  Future<void> _fetchTaskList() async {
    try {
      String? token = await secureStorage.read(key: 'user_data');
      if (token != null) {
        final decodedData = jsonDecode(token);
        final jwtToken = decodedData['jwt'];
        final String baseUrl = dotenv.env['BASE_URL']!;
        final url = '$baseUrl/api/services/get-task-list';

        print("Getting Tasks from: $url");

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            tasks = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          });
        } else {
          _showErrorDialog("Failed to load tasks. Status code: ${response.statusCode}");
        }
      }
    } catch (e) {
      _showErrorDialog("Error fetching task list: $e");
    }
  }

  Future<void> _deleteTask(Map<String, dynamic> task) async {
    try {
      String? token = await secureStorage.read(key: 'user_data');
      if (token != null) {
        final decodedData = jsonDecode(token);
        final jwtToken = decodedData['jwt'];
        final String baseUrl = dotenv.env['BASE_URL']!;
        final url = '$baseUrl/api/services/save-task';

        // Prepare the task data for deletion
        Map<String, dynamic> requestData = {
          'SaveStatus': '3', // '3' indicates a delete operation
          'TaskCode': task['Task_Code'],
          'TaskName': task['Task_Name'],
          'TaskDescription': task['Task_Description'],
          'TaskPriority': task['Task_Priority'].toString(),
          'TaskDueDate': task['Task_Due_Date'],
          'TaskCompleteStatus': task['Task_Complete_Status']
        };

        print("Deleting Task: $requestData");

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken',
          },
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          print("Task deleted successfully ${response.body}");
          _fetchTaskList();
        } else {
          _showErrorDialog("Failed to delete task. Status code: ${response.statusCode}");
        }
      }
    } catch (e) {
      _showErrorDialog("Error deleting task: $e");
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
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

  // Function to map priority numbers to text
  String _mapPriority(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
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
    await secureStorage.delete(key: 'user_data');
    await secureStorage.delete(key: 'isLoggedIn');
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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hi $firstName', style: TextStyle(color: Colors.white)),
            GestureDetector(
              onTap: _showProfilePopup,
              child: Icon(Icons.account_circle, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to Add_Screen and refresh task list on return
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Add_Screen()),
          );

          if (result == true) {
            _fetchTaskList();
          }
        },
        backgroundColor: Colors.blue.shade400,
        child: Icon(Icons.add),
      ),
      body: tasks.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return GestureDetector(
                  onTap: () async {
                    // Navigate to Edit_Screen and refresh task list on return
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Edit_Screen(
                          task: task, // Pass the task data to Edit_Screen
                        ),
                      ),
                    );

                    if (result == true) {
                      _fetchTaskList(); // Refresh the task list after editing
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Task code and name on the left
                              Expanded(
                                child: Text(
                                  '${task['Task_Code']}: ${task['Task_Name']}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Completed icon and delete button on the right
                              Row(
                                children: [
                                  Icon(
                                    task['Task_Complete_Status']
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: Colors.blue,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteTask(task); // Call delete task with the entire task data
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Description
                          Text(
                            task['Task_Description'],
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          SizedBox(height: 8),
                          // Priority and due date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: task['Task_Priority'] == 1
                                      ? Colors.red.shade100
                                      : task['Task_Priority'] == 2
                                          ? Colors.orange.shade100
                                          : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _mapPriority(task['Task_Priority']),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: task['Task_Priority'] == 1
                                        ? Colors.red
                                        : task['Task_Priority'] == 2
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                ),
                              ),
                              Text(
                                'Due Date: ${task['Task_Due_Date']}',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

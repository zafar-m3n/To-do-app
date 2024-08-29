import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Add_Screen extends StatefulWidget {
  const Add_Screen({super.key});

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final taskCodeController = TextEditingController(text: ''); // Set as empty string for new task
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  String _selectedPriority = 'Medium';
  DateTime? _selectedDate;
  String _selectedStatus = 'Pending';

  final Color _borderColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text('Add Task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Task Code'),
              _buildTextField(taskCodeController, isEnabled: false),
              SizedBox(height: 20),
              _buildLabel('Title'),
              _buildTextField(titleController, focusNode: _focusNode1),
              SizedBox(height: 20),
              _buildLabel('Description'),
              _buildTextField(
                descriptionController,
                focusNode: _focusNode2,
                maxLines: 3,
              ),
              SizedBox(height: 20),
              _buildLabel('Priority'),
              _buildPriorityDropdown(),
              SizedBox(height: 20),
              _buildLabel('Due Date'),
              _buildDatePicker(),
              SizedBox(height: 20),
              _buildLabel('Status'),
              _buildStatusDropdown(),
              SizedBox(height: 20),
              _buildButtonRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      {bool isEnabled = true, FocusNode? focusNode, int maxLines = 1}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: isEnabled,
      maxLines: maxLines,
      style: TextStyle(fontSize: 18, color: isEnabled ? Colors.black : Colors.grey),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _borderColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _borderColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: DropdownButtonFormField<String>(
        value: _selectedPriority,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        items: ['High', 'Medium', 'Low'].map((String priority) {
          return DropdownMenuItem<String>(
            value: priority,
            child: Text(priority),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedPriority = newValue!;
          });
        },
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        items: ['Pending', 'Completed'].map((String status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedStatus = newValue!;
          });
        },
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _borderColor,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          _selectedDate == null
              ? 'Select Due Date'
              : '${_selectedDate!.toLocal().toString().split(' ')[0]}',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        trailing: Icon(Icons.calendar_today, color: Colors.grey),
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2101),
          );
          if (picked != null && picked != _selectedDate) {
            setState(() {
              _selectedDate = picked;
            });
          }
        },
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade400,
            minimumSize: Size(150, 50),
          ),
          onPressed: () {
            _addTask(); // Call the function to add task
          },
          child: Text('Add Task', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(150, 50),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // Function to handle adding a task
  Future<void> _addTask() async {
    if (_selectedDate == null) {
      _showErrorDialog('Please select a due date.');
      return;
    }

    final String baseUrl = dotenv.env['BASE_URL']!;
    final url = '$baseUrl/api/services/save-task';

    // Prepare the task data
    Map<String, dynamic> taskData = {
      'SaveStatus': '1', // Assuming '1' indicates a new task save operation
      'TaskCode': '', // Empty for a new task
      'TaskName': titleController.text,
      'TaskDescription': descriptionController.text,
      'TaskPriority': _selectedPriority == 'High' ? '1' : _selectedPriority == 'Medium' ? '2' : '3',
      'TaskDueDate': _selectedDate!.toIso8601String(),
      'TaskCompleteStatus': _selectedStatus == 'Completed'
    };

    print("Creating new task. Task Data: $taskData");

    try {
      String? token = await secureStorage.read(key: 'user_data');
      if (token != null) {
        final decodedData = jsonDecode(token);
        final jwtToken = decodedData['jwt'];

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwtToken',
          },
          body: jsonEncode(taskData),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, true); 
        } else {
          _showErrorDialog('Failed to add task. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      _showErrorDialog('Error adding task: $e');
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
}

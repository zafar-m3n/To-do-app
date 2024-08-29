import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Edit_Screen extends StatefulWidget {
  final Map<String, dynamic> task;

  Edit_Screen({Key? key, required this.task}) : super(key: key);

  @override
  State<Edit_Screen> createState() => _Edit_ScreenState();
}

class _Edit_ScreenState extends State<Edit_Screen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController taskCodeController;
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  String _selectedPriority = 'Medium';
  DateTime? _selectedDate;
  String _selectedStatus = 'Pending';

  final Color _borderColor = Colors.grey;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with task data
    titleController = TextEditingController(text: widget.task['Task_Name']);
    descriptionController = TextEditingController(text: widget.task['Task_Description']);
    taskCodeController = TextEditingController(text: widget.task['Task_Code']);
    _selectedPriority = _mapPriority(widget.task['Task_Priority']);
    _selectedStatus = widget.task['Task_Complete_Status'] ? 'Completed' : 'Pending';
    _selectedDate = DateTime.parse(widget.task['Task_Due_Date']);
  }

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

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    taskCodeController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text('Edit Task'),
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
            initialDate: _selectedDate ?? DateTime.now(),
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
            _editTask(); // Call the function to edit task
          },
          child: Text('Save Task', style: TextStyle(color: Colors.white)),
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

  // Function to handle editing a task
  Future<void> _editTask() async {
    if (_selectedDate == null) {
      _showErrorDialog('Please select a due date.');
      return;
    }

    final String baseUrl = dotenv.env['BASE_URL']!;
    final url = '$baseUrl/api/services/save-task';

    // Prepare the task data for editing
    Map<String, dynamic> taskData = {
      'SaveStatus': '2', // '2' indicates an update operation
      'TaskCode': taskCodeController.text, // Use the existing task code
      'TaskName': titleController.text,
      'TaskDescription': descriptionController.text,
      'TaskPriority': _selectedPriority == 'High' ? '1' : _selectedPriority == 'Medium' ? '2' : '3',
      'TaskDueDate': _selectedDate!.toIso8601String(),
      'TaskCompleteStatus': _selectedStatus == 'Completed'
    };

    print("Editing task. Task Data: $taskData");

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
          Navigator.pop(context, true); // Navigate back with success flag
        } else {
          _showErrorDialog('Failed to update task. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      _showErrorDialog('Error updating task: $e');
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

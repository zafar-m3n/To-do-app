import 'package:flutter/material.dart';

class Add_Screen extends StatefulWidget {
  const Add_Screen({super.key});

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final taskCodeController = TextEditingController(text: 'T-001');

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
        child: SingleChildScrollView(  // Makes the content scrollable
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
          border: InputBorder.none, // No default border
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
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey), // Custom dropdown icon
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
          border: InputBorder.none, // No default border
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
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey), // Custom dropdown icon
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
            // Add task functionality
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
}

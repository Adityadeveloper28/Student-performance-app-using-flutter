import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _madController = TextEditingController();
  final TextEditingController _coaController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _webxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Marks'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _rollNoController,
              decoration: InputDecoration(labelText: 'Roll No'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _madController,
              decoration: InputDecoration(labelText: 'MAD Marks'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _coaController,
              decoration: InputDecoration(labelText: 'COA Marks'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ipController,
              decoration: InputDecoration(labelText: 'IP Marks'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _webxController,
              decoration: InputDecoration(labelText: 'WEBX Marks'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitMarks,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitMarks() async {
    final Map<String, dynamic> requestData = {
      'MAD': int.tryParse(_madController.text) ?? 0,
      'COA': int.tryParse(_coaController.text) ?? 0,
      'IP': int.tryParse(_ipController.text) ?? 0,
      'WEBX': int.tryParse(_webxController.text) ?? 0,
      'name': _nameController.text,
      'rollNo': _rollNoController.text,
    };

    final response = await http.post(
      Uri.parse('https://server2-oiod.onrender.com/submit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      // If submission is successful, navigate to the details page
      Navigator.pushNamed(
        context,
        'dashboard',
      );
    } else {
      // If submission fails, print error message
      print('Failed to submit marks. Status code: ${response.statusCode}');
    }
  }
}

class SubmittedDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Details'),
      ),
      body: Center(
        child: Text('Display submitted details here'),
      ),
    );
  }
}

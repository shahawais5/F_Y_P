import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../config_color/constants_color.dart';

class Complaint {
  String complainText;

  Complaint(this.complainText);

  Map<String, dynamic> toJson() {
    return {
      'complainText': complainText,
    };
  }
}

class ComplaintScreen extends StatefulWidget {
  static String routeName='ComplaintScreen';
  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _complaintController = TextEditingController();
  late DatabaseReference _complaintsRef;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _complaintsRef = FirebaseDatabase.instance.reference().child('complaints').child(_currentUser.uid);
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      String complainText = _complaintController.text;
      Complaint complaint = Complaint(complainText);

      _complaintsRef.push().set(complaint.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Complaint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _complaintController,
                maxLines: 5,
                maxLength: 250,
                style: TextStyle(
                    color: Colors.black), // Change the text color to black
                decoration: InputDecoration(
                  labelText:
                  'Complaint (Max 250 words You can write in complain)',
                  labelStyle: TextStyle(
                      color:
                      Colors.black), // Change the label text color to black
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black), // Set the border color to black
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .black), // Set the enabled border color to black
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .black), // Set the focused border color to black
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your complaint.';
                  } else if (value.length > 250) {
                    return 'Complaint should not exceed 250 words.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitComplaint,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue), // Change the color as desired
                ),
                child: Text('Submit Complaint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


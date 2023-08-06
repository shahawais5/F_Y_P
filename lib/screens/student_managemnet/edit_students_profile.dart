import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/config_color/constants_color.dart';
import 'package:final_year_project/provider/student_provider.dart';
import 'package:final_year_project/screens/student_managemnet/student_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditStudentProfile extends StatelessWidget {
  static String routeName = 'EditStudentProfile';
  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Student'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: studentProvider.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: Colors.white,
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String studentId = document.id;
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        // Background color
                        borderRadius: BorderRadius.circular(10),
                        // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: Offset(0, 3), // Shadow offset
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue,
                            Colors.cyanAccent,
                            Colors.green
                          ], // Gradient colors
                        ),
                        border: Border.all(
                          color: Colors.black, // Border color
                          width: 2, // Border width
                        ),
                      ),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('StudentprofileImage')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final data = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  final profileImage =
                                      data['profileImage'] as String?;
                                  if (profileImage != null) {
                                    return CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          NetworkImage(profileImage),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            ListTile(
                              title: Text('Student Name'),
                              trailing: Text(
                                data['studentName'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text('Father Name'),
                              trailing: Text(
                                data['fatherName'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text('Class'),
                              trailing: Text(
                                data['studentClasses'].toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text('Email'),
                              trailing: Text(
                                data['email'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text('Address'),
                              trailing: Text(
                                data['address'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text('Language'),
                              trailing: Text(
                                data['languages'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                          size: 30,
                                        )),
                                    onPressed: () {
                                      _editUser(context, studentProvider,
                                          studentId, data);
                                    }),
                                IconButton(
                                  icon: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 30,
                                      )),
                                  onPressed: () => _deleteUser(
                                      context, studentProvider, studentId),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ])));
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => StudentRegistration()))),
    );
  }

  Future<void> _editUser(BuildContext context, StudentProvider studentProvider,
      String studentId, Map<String, dynamic> studentData) {
    String studentName = studentData['studentName'];
    String fatherName = studentData['fatherName'];
    String? stdClassString = studentData['studentClass'];
    int? stdClass = int.tryParse(stdClassString ?? '');
    String email = studentData['email'];
    String address = studentData['address'];
    String languages = studentData['languages'];
    String DOB = studentData['dob'];

    final TextEditingController studentNameController =
        TextEditingController(text: studentName);
    final TextEditingController fatherNameController =
        TextEditingController(text: fatherName);
    final TextEditingController stdClassController =
        TextEditingController(text: stdClassString ?? '');
    final TextEditingController emailController =
        TextEditingController(text: email);
    final TextEditingController languagesController =
        TextEditingController(text: languages);
    final TextEditingController DOBController =
        TextEditingController(text: DOB);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: studentNameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Father Name'),
                  controller: fatherNameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Class'),
                  controller: stdClassController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: emailController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Languages'),
                  controller: languagesController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'DOB'),
                  controller: DOBController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                studentName = studentNameController.text;
                fatherName = fatherNameController.text;
                stdClass = int.tryParse(stdClassController.text);
                email = emailController.text;
                languages = languagesController.text;
                DOB = DOBController.text;

                // Update the user data correctly
                studentProvider.updateUser(
                  studentId,
                  studentName,
                  fatherName,
                  address, // The correct address value from the database
                  email,
                  languages,
                  stdClass?.toString() ?? '',
                  DOB,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: successColor,
                    content: Text(
                      'Record Edit Successfully',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(
      BuildContext context, StudentProvider studentProvider, String studentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete the student?'),
            content: Text('This action cannot be undone.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  studentProvider.deleteUser(studentId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        //backgroundColor: successColor,
                        content: Text(
                      'Student Deleted !',
                      style: TextStyle(fontSize: 18.0, color: Colors.red),
                    )),
                  );
                },
              ),
            ],
          );
        });
  }
}

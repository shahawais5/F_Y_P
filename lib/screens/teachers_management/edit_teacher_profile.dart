import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/config_color/constants_color.dart';
import 'package:final_year_project/provider/teacher_provider.dart';
import 'package:final_year_project/screens/teachers_management/register_teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTeacherProfile extends StatelessWidget {
  static String routeName='EditTeacherProfile';
  Future<bool> getIsAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdmin') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<TeacherProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Teacher'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: teacherProvider.getUsers(),
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
              String teacherId = document.id;
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor, // Background color
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
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
                                  .collection('TeacherProfileImage')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final data = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  final profileImage =
                                      data['teacherProfile'] as String?;
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
                              title: Text('Teacher Name'),
                              trailing: Text(
                                data['fullName'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text('Teacher Subject'),
                              trailing: Text(
                                data['interests'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text('Teacher Address'),
                              trailing: Text(
                                data['address'],
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
                              title: Text('Language'),
                              trailing: Text(
                                data['languages'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text('SocialAccount'),
                              trailing: Text(
                                data['socialSites'],
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
                                      _editUser(context, teacherProvider,
                                          teacherId, data);
                                    }),
                                IconButton(
                                  icon: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 30,
                                      )),
                                  onPressed: () => _deleteUser(
                                      context, teacherProvider, teacherId),
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
              MaterialPageRoute(builder: (context) => TeacherInformation()))),
    );
  }

  Future<void> _editUser(BuildContext context, TeacherProvider teacherProvider,
      String teacherId, Map<String, dynamic> userData) {
    String fullName = userData['fullName'];
    String address = userData['address'];
    String interest = userData['interests'];
    String email = userData['email'];
    String languages = userData['languages'];
    String SocialSite = userData['socialSites'];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Teacher'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) => fullName = value,
                  controller: TextEditingController(text: fullName),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Subject'),
                  onChanged: (value) => interest = value,
                  controller: TextEditingController(text: interest),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'email'),
                  onChanged: (value) => email = value,
                  controller: TextEditingController(text: email),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'address'),
                  onChanged: (value) => address = value,
                  controller: TextEditingController(text: address),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'languages'),
                  onChanged: (value) => languages = value,
                  controller: TextEditingController(text: languages),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'languages'),
                  onChanged: (value) => SocialSite = value,
                  controller: TextEditingController(text: SocialSite),
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
                teacherProvider.updateUser(teacherId, fullName, address, email,
                    interest, languages, SocialSite);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(
      BuildContext context, TeacherProvider teacherProvider, String teacherId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete the Teacher?'),
            content: Text('This action cannot be undone.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  teacherProvider.deleteUser(teacherId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Student Deleted !',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        )),
                  );
                },
              ),
            ],
          );
        });
  }
}

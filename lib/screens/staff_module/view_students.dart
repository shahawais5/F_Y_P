import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../config_color/constants_color.dart';
import '../student_managemnet/student_profile.dart';


class ViewStudents extends StatefulWidget {
  static String routeName='ViewStudents';
  ViewStudents({Key? key}) : super(key: key);

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  String searchQuery = '';
  final CollectionReference _student =
      FirebaseFirestore.instance.collection('StudentsDetails');

  bool isObsecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: primaryColor,
          title: Text('View Register Students'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: _student.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                  final studentName = doc['studentName'] as String;
                  final fatherName = doc['fatherName'] as String;
                  return studentName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      fatherName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                }).toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'Search Student with their name',
                            hintStyle: TextStyle(color: Colors.black),
                            //labelText: 'Search',
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(70.0),
                            )),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: filteredDocs.length,
                          //streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                filteredDocs[index];
                            // final DocumentSnapshot documentSnapshot =
                            // streamSnapshot.data!.docs[index];
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GetStdProfile()));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor, // Background color
                                        borderRadius: BorderRadius.circular(
                                            10), // Rounded corners
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                                0.5), // Shadow color
                                            spreadRadius: 2, // Spread radius
                                            blurRadius: 5, // Blur radius
                                            offset:
                                                Offset(0, 3), // Shadow offset
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blue,
                                            Colors.green,
                                          ], // Gradient colors
                                        ),
                                        border: Border.all(
                                          color: Colors.black, // Border color
                                          width: 2, // Border width
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            trailing: Icon(Icons.person),
                                            title: Text('Student Name'),
                                            subtitle: Text(
                                              documentSnapshot['studentName'],
                                              style: TextStyle(
                                                  fontSize: 17,color: scaffoldBackgroundColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text('FatherName'),
                                            trailing: Text(
                                              documentSnapshot['fatherName'],
                                              style: TextStyle(
                                                  fontSize: 14,color: scaffoldBackgroundColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      )),
                                ));
                          }),
                    ),
                  ],
                );
              } else {
                return Text('not found!');
              }
            }));
  }
}

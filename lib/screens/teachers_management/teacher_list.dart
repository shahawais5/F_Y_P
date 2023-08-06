import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config_color/constants_color.dart';

class TeachersList extends StatefulWidget {
  TeachersList({Key? key}) : super(key: key);
  static String routeName = 'TeachersList';
  @override
  State<TeachersList> createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  String searchQuery = '';
  final CollectionReference _teacher =
      FirebaseFirestore.instance.collection('TeacherDetails');

  bool isObsecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: primaryColor,
          title: Text('List Of Teachers'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: _teacher.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                final filteredDocs = streamSnapshot.data!.docs.where((doc) {
                  final fullName = doc['fullName'] as String;
                  final address = doc['address'] as String;
                  return fullName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      address.toLowerCase().contains(searchQuery.toLowerCase());
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
                            hintText: 'Search Teacher with their name',
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
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor, // Background color
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded corners
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5), // Shadow color
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
                                          Colors.green,
                                          Colors.cyanAccent
                                        ], // Gradient colors
                                      ),
                                      border: Border.all(
                                        color: Colors.black, // Border color
                                        width: 2, // Border width
                                      ),
                                    ),
                                    child: ListTile(
                                      trailing: Icon(Icons.person),
                                      title: Text(documentSnapshot['fullName']),
                                      subtitle:
                                          Text(documentSnapshot['address']),
                                    )));
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

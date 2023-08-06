import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../config_color/constants_color.dart';

class GetStdProfile extends StatefulWidget {

  static String routeName='GetStdProfile';

  GetStdProfile({Key? key}) : super(key: key);

  @override
  State<GetStdProfile> createState() => _GetStdProfileState();
}

class _GetStdProfileState extends State<GetStdProfile> {
  final CollectionReference _student =
      FirebaseFirestore.instance.collection('StudentsDetails');

  bool isObsecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('View Students Profile'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: _student.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor, // Background color
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
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
                                Colors.pinkAccent,
                                Colors.cyanAccent
                              ], // Gradient colors
                            ),
                            border: Border.all(
                              color: Colors.black, // Border color
                              width: 2, // Border width
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  child: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('StudentprofileImage')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data!.exists) {
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
                                      documentSnapshot['studentName'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Father Name'),
                                    trailing: Text(
                                      documentSnapshot['fatherName'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Student Class'),
                                    trailing: Text(
                                      documentSnapshot['studentClasses'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  ListTile(
                                    title: Text('Address'),
                                    trailing: Text(
                                      documentSnapshot['address'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Email'),
                                    trailing: Text(
                                      documentSnapshot['email'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Language'),
                                    trailing: Text(
                                      documentSnapshot['languages'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Date Of Birth'),
                                    trailing: Text(
                                      documentSnapshot['dob'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Text('not found!');
              }
            }));
  }
}

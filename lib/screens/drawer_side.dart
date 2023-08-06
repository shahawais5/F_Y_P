import 'package:final_year_project/screens/raise_complains.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentications/change_password.dart';
import '../authentications/login_screen.dart';
import '../config_color/constants_color.dart';
import 'My_profile/edit_profile.dart';
import 'My_profile/profile.dart';
import 'bottom_nav_screen/bottom_nav_bar.dart';

class DrawerScreen extends StatefulWidget {

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final CollectionReference _user =
      FirebaseFirestore.instance.collection('UserProfileData');

  Widget Listtile(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        size: 32,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black45),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _user.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return Drawer(
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor, // Background color
                borderRadius: BorderRadius.circular(10), // Rounded corners
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
                  colors: [Colors.blue, Colors.green], // Gradient colors
                ),
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2, // Border width
                ),
              ),
              child: ListView(
                children: [
                  DrawerHeader(
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 42,
                              backgroundColor: primaryColor,
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('UserProfileImage')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
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
                          SizedBox(
                            height: 20,
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(documents[0]['UserName'],style: TextStyle(fontSize: 7),),
                              Text(
                                documents[0]['userEmail'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditUserProfile()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: primaryColor,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: scaffoldBackgroundColor,
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      'Account',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePassword()));
                      },
                      child: Listtile(Icons.key, 'Change Password')),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavigation()));
                    },
                    child: Listtile(Icons.home_outlined, 'Home Screen'),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfile()));
                      },
                      child: Listtile(Icons.person, 'My Profile')),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Listtile(Icons.notification_important, 'Notification'),
                  Listtile(Icons.star_outline, 'Reviews & Rating'),
        InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ComplaintScreen()));
            },
            child: Listtile(Icons.copy_outlined, 'Raise a Complaint')),
                  Listtile(Icons.format_quote_sharp, 'FAQs'),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Listtile(Icons.logout, 'LogOut')),
                  Container(
                    height: 230,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 162),
                          child: Text(
                            'Contact Support',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  'Call Us:',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  '+923135264072',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  'Mail Us:',
                                  style: TextStyle(color: textColor),
                                ),
                                Text('SeharPublicSchool@gmail.com',
                                    style: TextStyle(color: textColor)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/authentications/login_screen.dart';
import 'package:final_year_project/config_color/constants_color.dart';
import 'package:final_year_project/screens/My_profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../drawer_side.dart';
// import 'package:final_year_project/shared_preferences_helper.dart';

 class MyProfile extends StatefulWidget {
   static String routeName = 'MyProfile';

   @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final CollectionReference _user =
      FirebaseFirestore.instance.collection('UserProfileData');


  Widget listTile(IconData icon, String title) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
          leading: Icon(
            icon,
            color: textColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: textColor,
          ),
        )
      ],
    );
  }

  bool _fromBottomNavBar = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fromBottomNavBar =
        ModalRoute.of(context)?.settings.name == Navigator.defaultRouteName;
  }

  bool isFromBottomNavBar(BuildContext context) {
    return _fromBottomNavBar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: Text(
          'My Profile',
          style: TextStyle(fontSize: 20, color: scaffoldBackgroundColor),
        ),
      ),
      // Conditionally show the drawer based on the route source
      drawer: isFromBottomNavBar(context) ? null : DrawerScreen(),
      body: StreamBuilder(
        stream: _user.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 100,
                          color: primaryColor,
                        ),
                        Container(
                          height: 548,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: ListView(
                            children: [
                              // display data from firebase
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 250,
                                    padding: EdgeInsets.only(left: 20),
                                    child: SingleChildScrollView(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['UserName'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  documentSnapshot['userEmail'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: textColor,
                                                  ),
                                                ),
                                              ]),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditUserProfile()));
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: primaryColor,
                                              child: CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    scaffoldBackgroundColor,
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              listTile(Icons.spatial_tracking, 'My Status'),
                              listTile(
                                  Icons.location_on_outlined, 'School Address'),
                              listTile(Icons.person_outline, 'Refer A Friends'),
                              listTile(
                                  Icons.file_copy_outlined, 'Term & Condition'),
                              listTile(
                                  Icons.policy_outlined, 'Privacy & Policy'),
                              listTile(Icons.add_chart, 'About'),
                              GestureDetector(
                                onTap: () {
                                  //await SharedPreferencesHelper.setLoggedIn(false);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: listTile(
                                    Icons.exit_to_app_outlined, 'logOut'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 47,
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
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          } else {
            return Text('Not found!');
          }
        },
      ),
    );
  }
}

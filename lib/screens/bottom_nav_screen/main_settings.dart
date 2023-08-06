import 'package:final_year_project/authentications/utils.dart';
import 'package:final_year_project/config_color/constants_color.dart';
import 'package:final_year_project/screens/student_managemnet/student_profile.dart';
import 'package:final_year_project/screens/student_managemnet/student_registration.dart';
import 'package:final_year_project/screens/teachers_management/edit_teacher_profile.dart';
import 'package:final_year_project/screens/teachers_management/register_teacher.dart';
import 'package:final_year_project/screens/teachers_management/teacher_list.dart';
import 'package:final_year_project/screens/teachers_management/teacher_profile.dart';
import 'package:final_year_project/widgets/data_buttons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fees_management/fees_history.dart';
import '../fees_management/submit_fee.dart';
import '../fees_management/submittedFees.dart';
import '../staff_module/update_std_report.dart';
import '../staff_module/view_students.dart';
import '../student_managemnet/edit_students_profile.dart';

class Setting extends StatelessWidget {
  static String routeName = 'Setting';

  Future<bool> getIsAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdmin') ?? false;
  }

  Future<bool> getIsTeacher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isTeacher') ?? false;
  }

  const Setting({Key? key}) : super(key: key);

  //final pages = [Settings(), HomeScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          //////////Student Module///////////////
          ExpansionTile(
            collapsedTextColor: textColor,
            collapsedBackgroundColor: primaryColor,
            collapsedIconColor: scaffoldBackgroundColor,
            title: Text('Student Management'),
            children: [
              Buttons(
                  Iconsdata: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  title: 'Students Registeration',
                  onTap: () {
                    //Navigator.pushNamedAndRemoveUntil(context, StudentRegistration.routeName, (route) => false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentRegistration()));
                  }),
              Buttons(
                  Iconsdata: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                  ),
                  title: 'View Student Profile',
                  onTap: () {
                    //Navigator.pushNamedAndRemoveUntil(context, GetStdProfile.routeName, (route) => false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GetStdProfile()));
                  }),
              Buttons(
                  Iconsdata: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: 'Edit Profile',
                  onTap: () {
                    //Navigator.pushNamedAndRemoveUntil(context, EditStudentProfile.routeName, (route) => false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditStudentProfile()));
                  }),
              Buttons(
                  Iconsdata: const Icon(
                    Icons.stream_sharp,
                    color: Colors.white,
                  ),
                  title: 'View Student Report',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserPage()));
                  }),
            ],
          ),

          SizedBox(
            height: 15,
          ),

          /////////////////////Staff Module////////////////////

          ExpansionTile(
            collapsedTextColor: textColor,
            collapsedBackgroundColor: primaryColor,
            collapsedIconColor: scaffoldBackgroundColor,
            title: Text('Staff Management'),
            children: [
              FutureBuilder<bool>(
                future: getIsAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: Colors.white,
                    );
                  } else {
                    bool isAdmin = snapshot.data ?? false;
                    if (isAdmin) {
                      return Buttons(
                          Iconsdata: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          title: 'Add Teacher',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherInformation()));
                            Utils().toastMessage(
                                'only admin & Teacher can access this feature');
                          });
                    } else {
                      return Text(
                        '',
                      );
                    }
                  }
                },
              ),
              FutureBuilder<bool>(
                future: getIsAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: Colors.white,
                    );
                  } else {
                    bool isAdmin = snapshot.data ?? false;
                    if (isAdmin) {
                      return Buttons(
                          Iconsdata: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          title: 'Edit Teacher',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditTeacherProfile()));
                            Utils().toastMessage(
                                'only admin & Teacher can access this feature');
                          });
                    } else {
                      return Text(
                        '',
                        // style: TextStyle(fontSize : 18),
                      );
                    }
                  }
                },
              ),
              Buttons(
                  Iconsdata: const Icon(
                    Icons.perm_identity,
                    color: Colors.white,
                  ),
                  title: 'Teacher Profile',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherProfile()));
                  }),
              Buttons(
                  Iconsdata: const Icon(
                    Icons.list_alt,
                    color: Colors.white,
                  ),
                  title: 'Teachers List',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeachersList()));
                  }),
            ],
          ),

          SizedBox(
            height: 15,
          ),

          ExpansionTile(
            collapsedTextColor: textColor,
            collapsedBackgroundColor: primaryColor,
            collapsedIconColor: scaffoldBackgroundColor,
            title: Text('Staff Module'),
            children: [
              Buttons(
                  Iconsdata: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                  ),
                  title: 'View Student',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewStudents()));
                  }),
              FutureBuilder<bool>(
                future: getIsTeacher().then((isTeacher) {
                  if (isTeacher) {
                    return true;
                  } else {
                    return getIsAdmin();
                  }
                }),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: Colors.white,
                    );
                  } else {
                    bool canAccess = snapshot.data ?? false;

                    if (canAccess) {
                      return Buttons(
                        Iconsdata: const Icon(
                          Icons.report,
                          color: Colors.white,
                        ),
                        title: 'Update Student Report',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TeacherPage()),
                          );
                          Utils().toastMessage('Only admin & teachers can access this feature');
                        },
                      );
                    } else {
                      return Text('');
                    }
                  }
                },
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),

          ////////////////////Fees Module////////////////////////

          ExpansionTile(
            collapsedTextColor: textColor,
            collapsedBackgroundColor: primaryColor,
            collapsedIconColor: scaffoldBackgroundColor,
            title: Text('Fees Management'),
            children: [
              Buttons(
                  Iconsdata: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  title: 'Submit Fee Online',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentFormScreen()));
                  }),
              Buttons(
                  Iconsdata: const Icon(
                    Icons.done_all,
                    color: Colors.white,
                  ),
                  title: 'Students with Fee',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubmittedFee()));
                  }),
              Buttons(
                  Iconsdata: const Icon(
                    Icons.book_online_outlined,
                    color: Colors.white,
                  ),
                  title: 'Submit Fee History',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubmittedFeesRecords()));
                  }),
              // Buttons(
              //     Iconsdata: const Icon(
              //       Icons.running_with_errors_outlined,
              //       color: Colors.red,
              //     ),
              //     title: 'Student without Fee',
              //     onTap: () {}),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          // ExpansionTile(
          //   collapsedTextColor: textColor,
          //   collapsedBackgroundColor: primaryColor,
          //   collapsedIconColor: scaffoldBackgroundColor,
          //   title: Text('Attendance'),
          //   children: [
          //     Buttons(
          //         Iconsdata: const Icon(
          //           Icons.calendar_month,
          //           color: Colors.white,
          //         ),
          //         title: 'Mark Attendance',
          //         onTap: () {}),
          //     Buttons(
          //         Iconsdata: const Icon(
          //           Icons.person_add,
          //           color: Colors.white,
          //         ),
          //         title: 'Present Student List',
          //         onTap: () {}),
          //     Buttons(
          //         Iconsdata: const Icon(
          //           Icons.person_add,
          //           color: Colors.white,
          //         ),
          //         title: 'Absent Student List',
          //         onTap: () {}),
          //   ],
          // ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    ));
  }
}

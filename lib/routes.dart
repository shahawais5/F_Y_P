import 'package:final_year_project/authentications/change_password.dart';
import 'package:final_year_project/authentications/reset_password.dart';
import 'package:final_year_project/authentications/signup_screen.dart';
import 'package:final_year_project/screens/My_profile/profile.dart';
import 'package:final_year_project/screens/bottom_nav_screen/bottom_nav_bar.dart';
import 'package:final_year_project/screens/bottom_nav_screen/home_screen/home_screen.dart';
import 'package:final_year_project/screens/bottom_nav_screen/main_settings.dart';
import 'package:final_year_project/screens/date_sheet/date_sheet.dart';
import 'package:final_year_project/screens/fees_management/fees_history.dart';
import 'package:final_year_project/screens/fees_management/submit_fee.dart';
import 'package:final_year_project/screens/fees_management/submittedFees.dart';
import 'package:final_year_project/screens/staff_module/update_std_report.dart';
import 'package:final_year_project/screens/staff_module/view_students.dart';
import 'package:final_year_project/screens/student_managemnet/edit_students_profile.dart';
import 'package:final_year_project/screens/student_managemnet/student_profile.dart';
import 'package:final_year_project/screens/student_managemnet/student_registration.dart';
import 'package:final_year_project/screens/teachers_management/edit_teacher_profile.dart';
import 'package:final_year_project/screens/teachers_management/register_teacher.dart';
import 'package:final_year_project/screens/teachers_management/teacher_list.dart';
import 'package:final_year_project/screens/teachers_management/teacher_profile.dart';
import 'package:flutter/cupertino.dart';
import 'authentications/login_screen.dart';


Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  // SplashScreen.routeName: (context) => SplashScreen(),
  ResetPassword.routeName: (context) => ResetPassword(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SignupScreen.routeName: (context) => SignupScreen(),
  ChangePassword.routeName: (context) => ChangePassword(),
  HomeScreen.routeName: (context) => HomeScreen(),
  BottomNavigation.routeName: (context) => BottomNavigation(),
  Setting.routeName: (context) => Setting(),
  MyProfile.routeName: (context) => MyProfile(),
  TeacherPage.routeName: (context) => TeacherPage(),
  ViewStudents.routeName: (context) => ViewStudents(),
  StudentRegistration.routeName: (context) => StudentRegistration(),
  EditStudentProfile.routeName: (context) => EditStudentProfile(),
  GetStdProfile.routeName: (context) => GetStdProfile(),
  //StudentRegistration.routeName: (context) => StudentRegistration(),
  SubmittedFeesRecords.routeName: (context) => SubmittedFeesRecords(),
  StudentFormScreen.routeName: (context) => StudentFormScreen(),
  SubmittedFee.routeName: (context) => SubmittedFee(),
  TeacherProfile.routeName: (context) => TeacherProfile(),
  TeachersList.routeName: (context) => TeachersList(),
  TeacherInformation.routeName: (context) => TeacherProfile(),
  EditTeacherProfile.routeName: (context) => EditTeacherProfile(),
  DateSheetScreen.routeName: (context) => DateSheetScreen(),
};

import 'package:final_year_project/authentications/reset_password.dart';
import 'package:final_year_project/authentications/signup_screen.dart';
import 'package:final_year_project/authentications/utils.dart';
import 'package:final_year_project/screens/bottom_nav_screen/bottom_nav_bar.dart';
import 'package:final_year_project/widgets/custom_textfields.dart';
import 'package:final_year_project/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void login(BuildContext context) async {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailcontroller.text.toString(),
            password: passwordcontroller.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomNavigation()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
    });
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    // Perform login validation based on email and password
    // ...

    // Simulating admin login
    if (email == 'admin@gmail.com' && password == 'admin123') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAdmin', true);

      Navigator.pushNamedAndRemoveUntil(
          context, BottomNavigation.routeName, (route) => false);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => BottomNavigation()));
    } else if (email == 'teacher@gmail.com' && password == 'teacher123') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isTeacher', true);
      Navigator.pushNamedAndRemoveUntil(
          context, BottomNavigation.routeName, (route) => false);
      // Navigator.push(
      //      context, MaterialPageRoute(builder: (context) => BottomNavigation()));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAdmin', false);
      await prefs.setBool('isTeacher', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover),
        ),
        child: WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop();
              return true;
            },
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                body: Stack(children: [
                  //Container(),
                  Container(
                    padding: const EdgeInsets.only(left: 35, top: 80),
                    child: const Text(
                      'Welcome\nBack',
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.4),
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustemTxtField(
                                    hintText: 'Email',
                                    keyboardType: TextInputType.text,
                                    labtext: 'Enter Your Email',
                                    controller: emailcontroller,
                                    icondata: const Icon(Icons.mail),
                                    ObsecureText: false,
                                    validator: '',
                                  ),
                                  CustemTxtField(
                                    hintText: 'Password',
                                    keyboardType: TextInputType.text,
                                    labtext: 'Enter Your Password',
                                    controller: passwordcontroller,
                                    icondata: const Icon(Icons.lock),
                                    ObsecureText: true,
                                    validator: '',
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 25,
                          ),
                          RoundButton(
                            title: 'Login',
                            loading: loading,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                // _login();
                                login(context);
                              }
                            },
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        ResetPassword.routeName,
                                        (route) => false);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ResetPassword()));
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.grey),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'SignUp to create account',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  SignupScreen.routeName, (route) => false);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SignupScreen()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Center(
                                child: Text(
                                  'SignUp',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 25),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ]))));
  }
}

// void plogin(BuildContext context) async {
//   String email = emailcontroller.text.trim();
//   String password = passwordcontroller.text.trim();
//
//   // Perform login validation based on email and password
//   // ...
//
//   // Simulating admin login
//   if (email == 'Admin@gmail.com' && password == 'admin123') {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isAdmin', true);
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => HomePage()),
//     );
//   } else {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isAdmin', false);
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => HomePage()),
//     );
//   }
// }

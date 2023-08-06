import 'package:final_year_project/authentications/login_screen.dart';
import 'package:final_year_project/authentications/utils.dart';
import 'package:final_year_project/config_color/constants_color.dart';
import 'package:final_year_project/widgets/custom_textfields.dart';
import 'package:final_year_project/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'SignupScreen';
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final phoneController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    phoneController.dispose();
  }

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
      email: emailcontroller.text.toString(),
      password: passwordcontroller.text.toString(),
    )
        .then((value) {
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(children: [
              Container(
                padding: EdgeInsets.only(left: 35, top: 30),
                child: Text(
                  'Create\nAccount',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustemTxtField(
                                      hintText: 'First Name',
                                      keyboardType: TextInputType.text,
                                      labtext: 'Enter Your First Name',
                                      controller: firstnamecontroller,
                                      icondata: Icon(Icons.person),
                                      ObsecureText: false,
                                      validator: '',
                                    ),
                                    CustemTxtField(
                                      hintText: 'Last Name',
                                      keyboardType: TextInputType.text,
                                      labtext: 'Enter Your Last Name',
                                      controller: lastnamecontroller,
                                      icondata: Icon(Icons.person),
                                      ObsecureText: false,
                                      validator: '',
                                    ),
                                    CustemTxtField(
                                      hintText: 'Email',
                                      keyboardType: TextInputType.text,
                                      labtext: 'Enter Your Email',
                                      icondata: Icon(Icons.email),
                                      controller: emailcontroller,
                                      ObsecureText: false,
                                      validator: '',
                                    ),
                                    CustemTxtField(
                                      hintText: 'Password',
                                      keyboardType: TextInputType.text,
                                      labtext: 'Enter Your password',
                                      controller: passwordcontroller,
                                      icondata: Icon(Icons.lock),
                                      ObsecureText: true,
                                      validator: '',
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 25,
                            ),
                            RoundButton(
                              title: 'Sign Up',
                              loading: loading,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  signUp();
                                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => LoginScreen()));
                                }
                              },
                            ),
                            // SizedBox(
                            //   height: 33,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: kInputTextStyle
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             LoginScreen()));
                                    },
                                    child: Text(
                                      'Login',
                                      style: kInputTextStyle
                                    )),
                              ],
                            ),
                            SizedBox(height: 20,)
                          ],
                        ),
                      ),
                    ]),
              ))
            ])));
  }
}

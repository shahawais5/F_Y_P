import 'package:final_year_project/authentications/signup_screen.dart';
import 'package:final_year_project/config_color/constants_color.dart';
import 'package:final_year_project/widgets/custom_textfields.dart';
import 'package:final_year_project/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = 'ResetPassword';
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  var email = '';

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: successColor,
            content: Text(
              'Password Reset Email has been sent !',
              style: TextStyle(fontSize: 18.0),
            )),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: failiarColor,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  // void login() {
  //   setState(() {
  //     loading = true;
  //   });
  //   _auth
  //       .signInWithEmailAndPassword(
  //           email: emailcontroller.text.toString(),
  //           password: passwordcontroller.text.toString())
  //       .then((value) {
  //     Utils().toastMessage(value.user!.email.toString());
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //     setState(() {
  //       loading = false;
  //     });
  //   }).onError((error, stackTrace) {
  //     setState(() {
  //       loading = false;
  //     });
  //     debugPrint(error.toString());
  //     Utils().toastMessage(error.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover),
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
                  'Forget Password',
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
                                      hintText: 'Email',
                                      keyboardType: TextInputType.text,
                                      labtext: 'Enter Your Email',
                                      controller: emailcontroller,
                                      icondata: Icon(Icons.mail),
                                      ObsecureText: false,
                                      validator: '',
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 55,
                            ),
                            RoundButton(
                              title: 'Send Request',
                              loading: loading,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    email = emailcontroller.text;
                                  });
                                  resetPassword();
                                }
                              },
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context, SignupScreen.routeName, (route) => false);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => SignupScreen()));
                              },
                              child: Container(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'SignUp',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              ))
            ])));
  }
}

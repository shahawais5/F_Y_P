import 'package:final_year_project/authentications/login_screen.dart';
import 'package:final_year_project/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config_color/constants_color.dart';
import '../widgets/custom_textfields.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  static const String routeName = 'ChangePassword';

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  var newPassword = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: successColor,
          content: Text(
            'Your Password has been Changed. Login again !',
            style: TextStyle(fontSize: 18.0),
          )));
    } catch (e) {}
  }

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
                  'Change Your Password\n & Remember please',
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
                            SizedBox(
                              height: 200,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustemTxtField(
                                      hintText: 'new password',
                                      keyboardType: TextInputType.text,
                                      labtext: 'Enter new password',
                                      controller: newPasswordController,
                                      icondata: Icon(
                                        Icons.new_label,
                                        color: Colors.black,
                                      ),
                                      ObsecureText: false,
                                      validator: '',
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 25,
                            ),
                            RoundButton(
                              title: 'Password Change',
                              loading: loading,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    newPassword = newPasswordController.text;
                                  });
                                  changePassword();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
              ))
            ])));
  }
}

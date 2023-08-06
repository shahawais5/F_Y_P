import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileProvider with ChangeNotifier{
  bool isLoading=false;
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();

  validator(context) async {
    if (userName.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add user Name');
    } else if (email.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please add email');
    } else {
      isLoading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection('UserProfileData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'UserName': userName.text,
        'userEmail': email.text,

      }).then((value) async {
        isLoading = false;
        notifyListeners();
        await Fluttertoast.showToast(msg: 'Profile edit Succesfully');
        Navigator.of(context as BuildContext).pop();
        notifyListeners();
      });
      notifyListeners();
    }
  }

}
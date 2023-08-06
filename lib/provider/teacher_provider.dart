import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/teacher_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherProvider with ChangeNotifier {
  bool isLoading = false;

  //late String imageUrl;
  //late PickedFile _imageFile;
  TextEditingController fullName = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController languages = TextEditingController();
  TextEditingController otherAbilities = TextEditingController();
  TextEditingController interest = TextEditingController();
  TextEditingController socialSites = TextEditingController();

  //final ImagePicker picker=ImagePicker();

  validator(context, _myType) async {
    if (fullName.text.isEmpty) {
      Fluttertoast.showToast(msg: 'firstname is empty');
    } else if (nationality.text.isEmpty) {
      Fluttertoast.showToast(msg: 'nationality is empty');
    } else if (address.text.isEmpty) {
      Fluttertoast.showToast(msg: 'address is empty');
    } else if (email.text.isEmpty) {
      Fluttertoast.showToast(msg: 'email is empty');
    } else if (occupation.text.isEmpty) {
      Fluttertoast.showToast(msg: 'occupation is empty');
    } else if (dob.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Date of Birth is empty');
    } else if (languages.text.isEmpty) {
      Fluttertoast.showToast(msg: 'field is empty');
    } else if (otherAbilities.text.isEmpty) {
      Fluttertoast.showToast(msg: 'other skills is empty');
    } else if (interest.text.isEmpty) {
      Fluttertoast.showToast(msg: 'field is empty');
    } else if (socialSites.text.isEmpty) {
      Fluttertoast.showToast(msg: 'field is empty');
    } else {
      isLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('TeacherDetails')
          // .doc(FirebaseAuth.instance.currentUser!.uid)
          .add({
        'fullName': fullName.text,
        'nationality': nationality.text,
        'address': address.text,
        'email': email.text,
        'occupation': occupation.text,
        'dob': dob.text,
        'languages': languages.text,
        'otherAbilities': otherAbilities.text,
        'interests': interest.text,
        'socialSites': socialSites.text,
        //'imageUrl':imageUrl,
        'AddresType': _myType.toString()
      }).then((value) async {
        isLoading = false;
        notifyListeners();
        await Fluttertoast.showToast(msg: 'Teacher Added Succesfully');
        Navigator.of(context as BuildContext).pop();
        notifyListeners();
      });
      notifyListeners();
    }
  }

  Stream<QuerySnapshot<Object?>> getUsers() {
    return teacherDetails.snapshots();
  }

  List<TeacherDetailModel> teacherDetailList = [];

  getTeacherDetails() async {
    List<TeacherDetailModel> newlist = [];
    TeacherDetailModel teacherDetailModel;
    DocumentSnapshot _db = await FirebaseFirestore.instance
        .collection('TeacherDetails')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (_db.exists) {
      teacherDetailModel = TeacherDetailModel(
          fullName: _db.get('fullName'),
          nationality: _db.get('nationality'),
          address: _db.get('address'),
          email: _db.get('email'),
          occupation: _db.get('occupation'),
          dob: _db.get('dob'),
          languages: _db.get('languages'),
          otherAbilities: _db.get('otherAbilities'),
          interest: _db.get('interest'),
          socialSites: _db.get('socialSites'),
          //imageUrl:_db.get('imageUrl'),
          AddresType: _db.get('AddressType'));
      newlist.add(teacherDetailModel);
      notifyListeners();
    }
    newlist = teacherDetailList;
    notifyListeners();
  }

  List<TeacherDetailModel> get getTeacherDetailModel {
    return teacherDetailList;
  }

  final CollectionReference teacherDetails =
      FirebaseFirestore.instance.collection('TeacherDetails');

  Future<void> updateUser(String teacherId, String newName, String newAddress,
      String newEmail, String Subject, String Language,String SocialSite) async {
    try {
      await teacherDetails.doc(teacherId).update({
        'fullName': newName,
        'address': newAddress,
        'email': newEmail,
        'interest': Subject,
        'languages': Language,
        'socialSites':SocialSite,
      });
      print('teacher updated');
    } catch (error) {
      print('Failed to update user: $error');
    }
  }

  Future<void> deleteUser(String teacherId) async {
    try {
      await teacherDetails.doc(teacherId).delete();
      print('Teacher deleted');
    } catch (error) {
      print('Failed to delete user: $error');
    }
  }
}

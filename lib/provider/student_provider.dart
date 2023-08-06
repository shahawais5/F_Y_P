import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/sudent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';



class StudentProvider with ChangeNotifier {
  bool isLoading = false;
  //late String imageUrl;
  //late PickedFile _imageFile;
  TextEditingController studentName = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController Class = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController languages = TextEditingController();
  TextEditingController interest = TextEditingController();
  List<String> classOptions = ['Class 1', 'Class 2', 'Class 3','Class 4', 'Class 5', 'Class 6']; // Add available class options
  String? selectedClass; // Track the selected class

  //final ImagePicker picker=ImagePicker();

  validator(context, _myType) async {
    if (studentName.text.isEmpty) {
      Fluttertoast.showToast(msg: 'firstname is empty');
    } else if (fatherName.text.isEmpty) {
      Fluttertoast.showToast(msg: 'fatherName is empty');
    } else if (email.text.isEmpty) {
      Fluttertoast.showToast(msg: 'email is empty');
    // } else if (Class.text.isEmpty) {
    //   Fluttertoast.showToast(msg: 'Class is empty');
    } else if (dob.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Date of Birth is empty');
    } else if (address.text.isEmpty) {
      Fluttertoast.showToast(msg: 'address is empty');
    } else if (languages.text.isEmpty) {
      Fluttertoast.showToast(msg: 'field is empty');
    } else if (interest.text.isEmpty) {
      Fluttertoast.showToast(msg: 'field is empty');
    } else {
      isLoading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection('StudentsDetails')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'studentName': studentName.text,
        'fatherName': fatherName.text,
        'address': address.text,
        'email': email.text,
        'dob': dob.text,
        'studentClasses': selectedClass,
        'languages': languages.text,
        //'studentClass': Class.text,
        'interests': interest.text,
        // 'imageUrl':imageUrl,
        'AddresType': _myType.toString()
      }).then((value) async {
        isLoading = false;
        notifyListeners();
        await Fluttertoast.showToast(msg: 'Register Succesfully');
        Navigator.of(context as BuildContext).pop();
        notifyListeners();
      });
      notifyListeners();
    }
  }

  List<StudentDetailModel> studentDetailList = [];

  getStudentDetails() async {
    List<StudentDetailModel> newlist = [];
    StudentDetailModel studentDetailModel;
    DocumentSnapshot _db = await FirebaseFirestore.instance
        .collection('StudentsDetails')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (_db.exists) {
      studentDetailModel = StudentDetailModel(
          fatherName: _db.get('fullName'),
          studentName: _db.get('studentName'),
          address: _db.get('address'),
          email: _db.get('email'),
          dob: _db.get('dob'),
          Class: _db.get('selectedClass'),
          languages: _db.get('languages'),
          interest: _db.get('interest'),
          AddresType: _db.get('AddresType'));
      newlist.add(studentDetailModel);
      notifyListeners();
    }
    newlist = studentDetailList;
    notifyListeners();
  }

  List<StudentDetailModel> get getStudentDetailList {
    return studentDetailList;
  }

  final CollectionReference studentDetails =
      FirebaseFirestore.instance.collection('StudentsDetails');

  Future<void> updateUser(
      String studentId,
      String studentName,
      String fatherName,
      String selectedClass,
      String Email,
      String Language,
      String newAddress,
      String DateOfBirth) async {
    try {
      await studentDetails.doc(studentId).update({
        'studentName': studentName,
        'fatherName': fatherName,
        'studentClasses': selectedClass,
        'email': Email,
        'languages': Language,
        'address': newAddress,
        'dob': DateOfBirth,
      });
      print('Student updated');
    } catch (error) {
      print('Failed to update user: $error');
    }
  }

  Future<void> deleteUser(String studentId) async {
    try {
      await studentDetails.doc(studentId).delete();
      print('StudentsDetails deleted');
    } catch (error) {
      print('Failed to delete user: $error');
    }
  }

  Stream<QuerySnapshot<Object?>> getUsers() {
    return studentDetails.snapshots();
  }
}

// File? _image;
//
// String? _imageUrl;
//
// final picker = ImagePicker();
// final firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref();
//
// File? get image => _image;
// String? get imageUrl => _imageUrl;
//
// Future<void> getImageCamera() async {
//   final pickedFile = await picker.getImage(source: ImageSource.camera);
//
//   if (pickedFile != null) {
//     _image = File(pickedFile.path);
//     notifyListeners();
//   } else {
//     print('No image selected.');
//   }
// }
//
// Future<void> getImageGallery() async {
//   final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//   if (pickedFile != null) {
//     _image = File(pickedFile.path);
//     notifyListeners();
//   } else {
//     print('No image selected.');
//   }
// }
//
// void dialog(context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             content: Container(
//               height: 120,
//               decoration: BoxDecoration(
//                 color: primaryColor,
//               ),
//               child: Column(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       getImageCamera();
//                       Navigator.pop(context);
//                       notifyListeners();
//                     },
//                     child: ListTile(
//                       leading: Icon(Icons.camera),
//                       title: Text('Camera'),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       getImageGallery();
//                       Navigator.pop(context);
//                       notifyListeners();
//                     },
//                     child: ListTile(
//                       leading: Icon(Icons.photo_library),
//                       title: Text('Upload from gallery'),
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//       });
// }
//
//
// Future<String> _uploadImage(File imageFile) async {
//   final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('profile_images');
//   final uploadTask = storageRef.putFile(imageFile);
//   final snapshot = await uploadTask.whenComplete(() {});
//   if (snapshot.state == firebase_storage.TaskState.success) {
//     final downloadURL = await snapshot.ref.getDownloadURL();
//     return downloadURL;
//   }
//   throw Exception('Image upload failed.');
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import '../../config_color/constants_color.dart';
import '../../widgets/textfields_teacher.dart';
import '../../provider/teacher_provider.dart';

class TeacherInformation extends StatefulWidget {
  static String routeName='TeacherInformation';
  const TeacherInformation({Key? key}) : super(key: key);

  @override
  State<TeacherInformation> createState() => _TeacherInformationState();
}

enum AddressType {
  Home,
  Work,
  Others,
}

class _TeacherInformationState extends State<TeacherInformation> {
  var _myType = AddressType.Home;
  bool showspinner = false;
  File? _image;

  Future<void> getCameraImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> getGalleryImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    final storageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Teacher_image/${user!.uid}');
    // final storageRef =
    //     firebase_storage.FirebaseStorage.instance.ref().child('profile_images');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    if (snapshot.state == firebase_storage.TaskState.success) {
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    }
    throw Exception('Image upload failed.');
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getGalleryImage();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: Icon(Icons.camera),
                        title: Text('Camera'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getCameraImage();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Upload from gallery'),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    TeacherProvider teacherProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Teacher'),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: Container(
          height: 50,
          width: 150,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: teacherProvider.isLoading == false
              ? MaterialButton(
                  child: Text('Add Teacher'),
                  onPressed: () async {
                    teacherProvider.validator(context, _myType);
                    if (_image != null) {
                      final downloadURL = await _uploadImage(_image!);
                      final user = FirebaseAuth.instance.currentUser;
                      //
                      await FirebaseFirestore.instance
                          .collection('TeacherProfileImage')
                          .doc(user!.uid)
                          .set({
                        'teacherProfile': downloadURL,
                      });
                      setState(() {
                        _image = null;
                      });
                    }
                  },
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 27.0, horizontal: 20),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: InkWell(
                    onTap: () {
                      dialog(context);
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueGrey[300],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _image==null?
                          CircleAvatar(
                            radius: 55,
                            child: Icon(
                              Icons.person,
                              size: 40,
                            ),
                            backgroundColor: primaryColor,
                            //backgroundImage: AssetImage('assets/profile_image.jpg'),
                          ):
                            CircleAvatar(
                              radius: 55,
                              child: Container(),
                              backgroundImage: FileImage(_image!)
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  dialog(context);
                                  // Perform action when the icon is clicked
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.blueGrey[300],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TeachTxtField(
              labtext: 'Enter fullName',
              keyboardType: TextInputType.text,
              controller: teacherProvider.fullName,
            ),
            TeachTxtField(
              labtext: 'nationality',
              controller: teacherProvider.nationality,
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: teacherProvider.address,
              labtext: 'address',
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              labtext: 'email ',
              controller: teacherProvider.email,
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: teacherProvider.occupation,
              labtext: 'occupation',
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: teacherProvider.dob,
              labtext: 'dob',
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: teacherProvider.languages,
              labtext: 'languages ',
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              labtext: 'otherAbilities',
              controller: teacherProvider.otherAbilities,
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: teacherProvider.interest,
              labtext: 'Subject',
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: teacherProvider.socialSites,
              labtext: 'socialSites',
              keyboardType: TextInputType.text,
            ),
            ListTile(
              title: Text('Address Type'),
            ),
            RadioListTile(
                value: AddressType.Home,
                title: const Text('Home'),
                groupValue: _myType,
                secondary: Icon(
                  Icons.home,
                  color: primaryColor,
                ),
                onChanged: (value) {
                  setState(() {
                    _myType = value!;
                  });
                }),
            RadioListTile(
                value: AddressType.Work,
                title: const Text('Work'),
                groupValue: _myType,
                secondary: Icon(
                  Icons.work,
                  color: primaryColor,
                ),
                onChanged: (onChanged) {
                  setState(() {
                    _myType = onChanged!;
                  });
                }),
            RadioListTile(
                value: AddressType.Others,
                groupValue: _myType,
                title: const Text('Others'),
                secondary: Icon(
                  Icons.devices_other,
                  color: primaryColor,
                ),
                onChanged: (values) {
                  setState(() {
                    _myType = values!;
                  });
                }),
          ],
        ),
      ),
    );
  }
}

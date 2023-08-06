import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/provider/student_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import '../../config_color/constants_color.dart';
import '../../widgets/textfields_teacher.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({Key? key}) : super(key: key);
  static String routeName='StudentRegistration';

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

enum AddressType {
  Home,
  Others,
}

class _StudentRegistrationState extends State<StudentRegistration> {
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
        .child('Student_profiles/${user!.uid}');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshots = await uploadTask.whenComplete(() {});
    if (snapshots.state == firebase_storage.TaskState.success) {
      final downloadURL = await snapshots.ref.getDownloadURL();
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
    StudentProvider studentProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: Container(
          height: 50,
          width: 150,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: studentProvider.isLoading == false
              ? MaterialButton(
                  child: Text('Add Student'),
                  onPressed: () async {
                    studentProvider.validator(context, _myType);
                    if (_image != null) {
                      final downloadURL = await _uploadImage(_image!);
                      final user = FirebaseAuth.instance.currentUser;
                      //
                      await FirebaseFirestore.instance
                          .collection('StudentprofileImage')
                          .doc(user!.uid)
                          .set({
                        'profileImageStd': downloadURL,
                      });
                      // setState(() {
                      //   _image = null;
                      // });
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
                          if (_image == null) // If no image is selected, show default icon
                            CircleAvatar(
                              radius: 55,
                              child: Icon(
                                Icons.person,
                                size: 40,
                              ),
                              backgroundColor: primaryColor,
                            )
                          else // If an image is selected, show it as the background of the CircleAvatar
                            CircleAvatar(
                              radius: 55,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.transparent,
                              ),
                              backgroundColor: primaryColor,
                              backgroundImage: FileImage(_image!),
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
              controller: studentProvider.studentName,
            ),
            TeachTxtField(
              labtext: 'Father Name',
              controller: studentProvider.fatherName,
              keyboardType: TextInputType.text,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Class'),
              hint: Text('Select Class'),
              value: studentProvider.selectedClass,
              onChanged: (value) {
                studentProvider.selectedClass = value; // Update the selected class
              },
              items: studentProvider.classOptions.map((classItem) {
                return DropdownMenuItem(
                  value: classItem,
                  child: Text(classItem),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a class.';
                }
                return null;
              },
            ),
            TeachTxtField(
              labtext: 'email ',
              controller: studentProvider.email,
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: studentProvider.address,
              labtext: 'Address',
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: studentProvider.dob,
              labtext: 'Date Of Birth',
              keyboardType: TextInputType.number,
            ),
            TeachTxtField(
              controller: studentProvider.languages,
              labtext: 'languages ',
              keyboardType: TextInputType.text,
            ),
            TeachTxtField(
              controller: studentProvider.interest,
              labtext: 'Hobbies',
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

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import '../../config_color/constants_color.dart';
import '../../widgets/textfields_teacher.dart';
import '../../provider/profile_data_provider.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  bool showSpinner = false;
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
        .child('profile_images/${user!.uid}');
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) => Scaffold(
        appBar: AppBar(
          title: Text('Profile Update'),
          backgroundColor: primaryColor,
        ),
        bottomNavigationBar: Container(
          height: 50,
          width: 150,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: profileProvider.isLoading == false
              ? MaterialButton(
                  child: Text('Edit Profile'),
                  onPressed: () async {
                    profileProvider.validator(context);
                    if (_image != null) {
                      final downloadURL = await _uploadImage(_image!);
                      final user = FirebaseAuth.instance.currentUser;
                      await FirebaseFirestore.instance
                          .collection('UserProfileImage')
                          .doc(user!.uid)
                          .set({
                        'userprofileImage': downloadURL,
                      });
                    }
                  },
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
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
                            CircleAvatar(
                              radius: 55,
                              child: Icon(
                                Icons.person,
                                size: 40,
                              ),
                              backgroundColor: primaryColor,
                              //backgroundImage: AssetImage('assets/profile_image.jpg'),
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
                controller: profileProvider.userName,
              ),
              TeachTxtField(
                labtext: 'Enter email',
                controller: profileProvider.email,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:math';
// import 'package:final_year_project/authentications/utils.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import '../../widgets/round_button.dart';
//
// class AddStd extends StatefulWidget {
//   const AddStd({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<AddStd> createState() => _AddStdState();
// }
//
// class _AddStdState extends State<AddStd> {
//   File? image;
//
//   bool showspinner = false;
//
//   final prepclass = FirebaseDatabase.instance.ref('Prep Class');
//   FirebaseAuth auth = FirebaseAuth.instance;
//   final picker = ImagePicker();
//   Future getImageGallery() async {
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     setState(() {
//       if (pickedFile != null) {
//         image = File(pickedFile.path);
//       } else {
//         Icon(Icons.person);
//       }
//     });
//   }
//
//   Future getImageCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     setState(() {
//       if (pickedFile != null) {
//         image = File(pickedFile.path);
//       } else {
//         Icon(Icons.person);
//       }
//     });
//   }
//
//   void dialog(context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               content: Container(
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade100,
//                 ),
//                 child: Column(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         getImageCamera();
//                         Navigator.pop(context);
//                       },
//                       child: ListTile(
//                         leading: Icon(Icons.camera),
//                         title: Text('Camera'),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         getImageGallery();
//                         Navigator.pop(context);
//                       },
//                       child: ListTile(
//                         leading: Icon(Icons.photo_library),
//                         title: Text('Upload from gallery'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ));
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ModalProgressHUD(
//         inAsyncCall: showspinner,
//         child: Scaffold(
//           backgroundColor: Colors.deepPurple.shade100,
//           appBar: AppBar(
//             centerTitle: true,
//             title: const Text('Add Student Detail'),
//           ),
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 27.0,
//                 ),
//                 child: Center(
//                   child: CircleAvatar(
//                     radius: 82,
//                     backgroundColor: Colors.deepPurple,
//                     child: InkWell(
//                       onTap: () {
//                         dialog(context);
//                       },
//                       child: CircleAvatar(
//                         radius: 80,
//                         child: Icon(Icons.person),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                   child: Column(
//                     children: [
//                       Form(
//                           child: Column(
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 60.0),
//                             child: RoundButton(
//                                 title: 'Add',
//                                 onTap: () async {
//                                   setState(() {
//                                     showspinner = true;
//                                   });
//                                   try {
//                                     firebase_storage.Reference dp_ref =
//                                         firebase_storage
//                                             .FirebaseStorage.instance
//                                             .ref('BlogApp');
//                                     UploadTask uplodetask =
//                                         dp_ref.putFile(image!.absolute);
//                                     await Future.value(uplodetask);
//                                     var newurl = await dp_ref.getDownloadURL();
//                                     final User? user = auth.currentUser;
//                                     prepclass.set({
//                                       'student_dp': newurl.toString(),
//                                     });
//                                     setState(() {
//                                       showspinner = false;
//                                     });
//                                     Utils().toastMessage('student added');
//                                   } catch (value) {
//                                     Utils().toastMessage(e.toString());
//                                   }
//
//                                   // Navigator.push(context, MaterialPageRoute(builder: ((context) => StudentList())));
//                                 }),
//                           )
//                         ],
//                       )),
//                     ],
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
// // Future<void> _addUser(BuildContext context, TeacherProvider teacherProvider) {
// //   String fullName = '';
// //   String address = '';
// //   return showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         title: Text('Add User'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               decoration: InputDecoration(labelText: 'Name'),
// //               onChanged: (value) => fullName = value,
// //             ),
// //             TextField(
// //               decoration: InputDecoration(labelText: 'Email'),
// //               onChanged: (value) => address = value,
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             child: Text('Cancel'),
// //             onPressed: () => Navigator.of(context).pop(),
// //           ),
// //           TextButton(
// //             child: Text('Add'),
// //             onPressed: () {
// //               //teacherProvider.addUser(fullName, address);
// //               Navigator.of(context).pop();
// //             },
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
//
//
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// //
// // class EditProfile extends StatefulWidget {
// //   const EditProfile({Key? key}) : super(key: key);
// //
// //   @override
// //   State<EditProfile> createState() => _EditProfileState();
// // }
// //
// // class _EditProfileState extends State<EditProfile> {
// //
// //   final CollectionReference _teacher =
// //   FirebaseFirestore.instance.collection('TeacherDetails');
// //
// //
// //   TextEditingController firstController=TextEditingController();
// //   TextEditingController secondController=TextEditingController();
// //
// //
// //   Future<void> _update([DocumentSnapshot? documentSnapshot])async{
// //     if(documentSnapshot !=null){
// //       firstController.text=documentSnapshot['fullName'];
// //       secondController.text=documentSnapshot['address'];
// //     }
// //     await showModalBottomSheet(
// //         isScrollControlled: true,
// //         context: context, builder: (BuildContext ctx){
// //       return Padding(padding: EdgeInsets.only(
// //           top: 20,
// //           left: 20,
// //           right: 20,
// //           bottom: MediaQuery.of(ctx).viewInsets.bottom + 20
// //       ),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: firstController,
// //               decoration:const InputDecoration(labelText: 'Name'),
// //             ),
// //             TextField(
// //               controller: secondController,
// //               decoration:const InputDecoration(labelText: 'address'),
// //             ),
// //             SizedBox(height: 20,),
// //             ElevatedButton(onPressed: ()async{
// //               final String fullName=firstController.text;
// //               final String address=secondController.text;
// //               if(fullName==null){
// //                 await _teacher.doc(documentSnapshot!.id).update({"fullName":fullName,'address':address});
// //                 _create();
// //                 firstController.text='';
// //                 secondController.text='';
// //               }
// //             }, child: Text('update'))
// //           ],
// //         ),
// //       );
// //     });
// //   }
// //   Future<void> _create([DocumentSnapshot? documentSnapshot])async{
// //     if(documentSnapshot !=null){
// //       firstController.text=documentSnapshot['fullName'];
// //       secondController.text=documentSnapshot['address'];
// //     }
// //     await showModalBottomSheet(
// //         isScrollControlled: true,
// //         context: context, builder: (BuildContext ctx){
// //       return Padding(padding: EdgeInsets.only(
// //           top: 20,
// //           left: 20,
// //           right: 20,
// //           bottom: MediaQuery.of(ctx).viewInsets.bottom + 20
// //       ),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: firstController,
// //               decoration:const InputDecoration(labelText: 'Name'),
// //             ),
// //             TextField(
// //               controller: secondController,
// //               decoration:const InputDecoration(labelText: 'address'),
// //             ),
// //             SizedBox(height: 20,),
// //             ElevatedButton(onPressed: ()async{
// //               final String fullName=firstController.text;
// //               final String address=secondController.text;
// //               if(fullName!=null){
// //                 await _teacher.add({"fullName":fullName,'address':address});
// //                 firstController.text='';
// //                 secondController.text='';
// //               }
// //             }, child: Text('Add'))
// //           ],
// //         ),
// //       );
// //     });
// //   }
// //
// //   Future<void> _delete(String teacherId)async{
// //     await _teacher.doc(teacherId).delete();
// //
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted Successfully')));
// //
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: (){
// //           _create();
// //         },
// //         child: const Icon(Icons.add),
// //       ),
// //       body: StreamBuilder(
// //           stream: _teacher.snapshots(),
// //           builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
// //             if (streamSnapshot.hasData) {
// //               return ListView.builder(
// //                   itemCount: streamSnapshot.data!.docs.length,
// //                   //streamSnapshot.data!.docs.length,
// //                   itemBuilder: (context, index) {
// //                     final DocumentSnapshot documentSnapshot =
// //                     streamSnapshot.data!.docs[index];
// //                     return Card(
// //                       child: Column(
// //                         children: [
// //                           ListTile(
// //                             title: Text(documentSnapshot['fullName']),
// //                             subtitle: Text(documentSnapshot['address']),
// //                             trailing: SizedBox(
// //                               width: 100,
// //                               child: Row(
// //                                 children: [
// //                                   IconButton(onPressed: (){
// //                                     _update(documentSnapshot);
// //                                   }, icon: Icon(Icons.edit)),
// //                                   IconButton(onPressed: (){
// //                                     _delete(documentSnapshot.id);
// //                                   }, icon: Icon(Icons.delete))
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   });
// //             } else {
// //               return Text('not found!');
// //             }
// //           }),
// //     );
// //   }
// // }

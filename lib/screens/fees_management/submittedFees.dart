import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SubmittedFee extends StatefulWidget {
  const SubmittedFee({Key? key}) : super(key: key);
  static const String routeName = 'SubmittedFee';

  @override
  State<SubmittedFee> createState() => _SubmittedFeeState();
}

class _SubmittedFeeState extends State<SubmittedFee> {
  late Future<List<Map<String, dynamic>>> _fetchDataFromFirestore;
  List<Map<String, dynamic>> _fetchedData = [];
  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore = _fetchData();
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('students').get();

      // Process the retrieved data
      List<Map<String, dynamic>> data = [];
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic>? documentData = doc.data() as Map<String, dynamic>?;

        if (documentData != null) {
          data.add(documentData);
        }
      }

      setState(() {
        _fetchedData = data;
        _filteredData = data;
      });

      return data;
    } catch (error) {
      // Handle any errors that occur during fetching
      print('Error fetching data: $error');
      return [];
    }
  }

  List<Map<String, dynamic>> _filterData(String query) {
    if (query.isEmpty) {
      return _fetchedData; // Show all data when the query is empty
    } else {
      // Filter data based on the search query (case-insensitive)
      return _fetchedData.where((itemData) {
        String name = itemData['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student With Fee'),
        backgroundColor: Colors.blue, // Replace this with your desired color
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _filteredData = _filterData(query);
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> itemData = _filteredData[index];
                final Timestamp timestamp = itemData['paymentDate'];
                final DateTime paymentDateTime = timestamp.toDate();

                final formattedDate = DateFormat('MMMM d, y h:mm a').format(paymentDateTime);

                return Column(
                  children: [
                    ListTile(
                      title: Text('Name: ${itemData['name']}'),
                      subtitle: Text('Father Name: ${itemData['fatherName']}'),
                      trailing: Text('Class: ${itemData['class']}'),
                    ),
                    Text('Payment Date and Time: $formattedDate'),
                    Divider(color: Colors.black),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:final_year_project/config_color/constants_color.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:io';
//
// class SubmittedFees extends StatefulWidget {
//   const SubmittedFees({Key? key}) : super(key: key);
//
//   @override
//   State<SubmittedFees> createState() => _SubmittedFeesState();
// }
//
// class _SubmittedFeesState extends State<SubmittedFees> {
//   late Future<List<Map<String, dynamic>>> _fetchDataFromFirestore;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDataFromFirestore = _fetchData();
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchData() async {
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('students').get();
//
//       // Process the retrieved data
//       List<Map<String, dynamic>> data = [];
//       for (QueryDocumentSnapshot doc in snapshot.docs) {
//         Map<String, dynamic>? documentData =
//             doc.data() as Map<String, dynamic>?;
//
//         if (documentData != null) {
//           data.add(documentData);
//         }
//       }
//
//       return data;
//     } catch (error) {
//       // Handle any errors that occur during fetching
//       print('Error fetching data: $error');
//       return [];
//     }
//   }
//
//   Future<void> _generatePDF(String name, String fatherName, String rollNo,
//       String shift, String email, String selectedClass) async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.MultiPage(
//         build: (context) => [
//           pw.Text(
//             'Name: $name',
//           ),
//           pw.Text('Father Name: $fatherName'),
//           pw.Text('Roll No: $rollNo'),
//           pw.Text('Shift: $shift'),
//           pw.Text('Email: $email'),
//           pw.Text('Class: $selectedClass'),
//         ],
//       ),
//     );
//
//
//     final output = await getTemporaryDirectory();
//     final file = File('${output.path}/SubmittedFeesVoucher.pdf');
//     await file.writeAsBytes(await pdf.save());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student With Fee'),
//         backgroundColor: primaryColor,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _fetchDataFromFirestore,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error fetching data'),
//             );
//           } else {
//             final List<Map<String, dynamic>> data = snapshot.data ?? [];
//
//             if (data.isEmpty) {
//               return Center(
//                 child: Text('No data found'),
//               );
//             }
//
//             return ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final Map<String, dynamic> itemData = data[index];
//                 final String name = itemData['name'];
//                 final String fatherName = itemData['fatherName'];
//                 final String rollNo = itemData['RollNo'];
//                 final String shift = itemData['Shift'];
//                 final String email = itemData['email'];
//                 final String selectedClass = itemData['class'];
//
//                 return ListTile(
//                   title: Text('Name: $name',style: TextStyle(fontFamily: 'Raleway'),),
//                   subtitle: Text('Father Name: $fatherName',style: TextStyle(fontFamily: 'Raleway'),),
//                   trailing: ElevatedButton(
//                     onPressed: () {
//                       _generatePDF(name, fatherName, rollNo, shift, email,
//                           selectedClass);
//                     },
//                     child: Text('Download Voucher'),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

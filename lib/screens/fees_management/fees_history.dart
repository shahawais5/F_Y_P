import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/config_color/constants_color.dart';
import 'package:flutter/material.dart';

class SubmittedFeesRecords extends StatefulWidget {
  static String routeName='SubmittedFeesRecords';
  const SubmittedFeesRecords({Key? key}) : super(key: key);

  @override
  State<SubmittedFeesRecords> createState() => _SubmittedFeesRecordsState();
}

class _SubmittedFeesRecordsState extends State<SubmittedFeesRecords> {
  late Future<List<Map<String, dynamic>>> _fetchDataFromFirestore;

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore = _fetchData();
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('students').get();

      // Process the retrieved data
      List<Map<String, dynamic>> data = [];
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic>? documentData =
        doc.data() as Map<String, dynamic>?;

        if (documentData != null) {
          data.add(documentData);
        }
      }

      return data;
    } catch (error) {
      // Handle any errors that occur during fetching
      print('Error fetching data: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Fee History'),
        backgroundColor: Colors.blue, // Replace with your desired color
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchDataFromFirestore,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            final List<Map<String, dynamic>> data = snapshot.data ?? [];

            if (data.isEmpty) {
              return Center(
                child: Text('No data found'),
              );
            }

            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                final Map<String, dynamic> itemData = data[index];
                return ListTile(
                  title: Text('Submitted Fees'),
                  subtitle: Text('History'),
                  trailing: ElevatedButton(
                    child: Text('Check'),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => FeeHistoryScreen(feeRecords: data),));
                    },
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => FeeHistoryScreen(feeRecords: data),
                    //   ),
                    // );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FeeHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> feeRecords;

  const FeeHistoryScreen({Key? key, required this.feeRecords}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fee History'),
        backgroundColor: Colors.blue, // Replace with your desired color
      ),
      body: ListView.builder(
        itemCount: feeRecords.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> itemData = feeRecords[index];
          return ListTile(
            title: Text('Name: ${itemData['name']}'),
            subtitle: Text('Father Name: ${itemData['fatherName']}',),
            trailing: Text('Class: ${itemData['class']}',style: kInputTextStyle,),
          );
        },
      ),
    );
  }
}



import 'package:final_year_project/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../config_color/constants_color.dart';

class TeacherPage extends StatefulWidget {
  static String routeName = 'TeacherPage';

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _rollNumberController = TextEditingController();

  final TextEditingController _englishController = TextEditingController();

  final TextEditingController _mathController = TextEditingController();

  final TextEditingController _urduController = TextEditingController();

  final TextEditingController _computerController = TextEditingController();

  final TextEditingController _islamiyatController = TextEditingController();

  final TextEditingController _pakStudyController = TextEditingController();

  void addResult() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String rollNumber = _rollNumberController.text;
      final double englishResult = double.parse(_englishController.text);
      final double mathResult = double.parse(_mathController.text);
      final double urduResult = double.parse(_urduController.text);
      final double computerResult = double.parse(_computerController.text);
      final double islamiyat = double.parse(_computerController.text);
      final double pakStudy = double.parse(_computerController.text);

      final Map<String, dynamic> resultData = {
        'name': name,
        'rollNumber': rollNumber,
        'english': englishResult,
        'math': mathResult,
        'urdu': urduResult,
        'computer': computerResult,
        'islamiyat': islamiyat,
        'pakStudy': pakStudy,
      };

      firestore.collection('results').add(resultData).then((_) {
        print('Result added successfully');
      }).catchError((error) {
        print('Error adding result: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Teacher Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Student Name',
                  ),
                ),
                TextFormField(
                  controller: _rollNumberController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid roll number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Roll Number',
                  ),
                ),
                TextFormField(
                  controller: _englishController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid English result';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'English Result',
                  ),
                ),
                TextFormField(
                  controller: _mathController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Math result';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Math Result',
                  ),
                ),
                TextFormField(
                  controller: _urduController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Urdu result';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Urdu Result',
                  ),
                ),
                TextFormField(
                  controller: _computerController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Computer result';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Computer Result',
                  ),
                ),
                TextFormField(
                  controller: _pakStudyController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid PakStudy result';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Pakstudy Result',
                  ),
                ),
                TextFormField(
                  controller: _islamiyatController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Islamiyat result';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Islamiyat Result',
                  ),
                ),
                SizedBox(height: 16.0),
                RoundButton(
                  title: 'Add Results',
                  //loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      addResult();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Result Added Successfully')));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  double englishTotal = 100;
  double mathTotal = 100;
  double computerTotal = 100;
  double urduTotal = 100;
  double islTotal = 100;
  double pakTotal = 100;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? _stream;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// a Timer is used to delay the execution of the search logic by 3 seconds.
  /// If the user enters a new search query within that 3-second window,
  /// the previous timer is canceled, and a new timer is set with the updated query.
  /// This ensures that the search logic is only triggered after 3 seconds of inactivity.

  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _stream = getResultStream();
  }

  Stream<QuerySnapshot> getResultStream() {
    return firestore.collection('results').snapshots();
  }

  void search() {
    final String query = _searchController.text.trim();

    if (query.isNotEmpty) {
      if (_searchTimer != null && _searchTimer!.isActive) {
        _searchTimer!.cancel();
      }

      setState(() {
        _searchQuery = query;
      });

      _searchTimer = Timer(Duration(seconds: 3), () {
        setState(() {
          _searchQuery = query;
        });
      });
    }
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Student Results'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: search,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final data = snapshot.data?.docs;

                if (data == null || data.isEmpty) {
                  return Text('No data available');
                }

                final filteredData = data.where((doc) {
                  final result = doc.data() as Map<String, dynamic>;
                  final name = result['name'] ?? '';
                  final rollNumber = result['rollNumber'] ?? '';
                  return name.toLowerCase() == _searchQuery.toLowerCase() ||
                      rollNumber.toLowerCase() == _searchQuery.toLowerCase();
                }).toList();

                if (_searchQuery.isNotEmpty && filteredData.isEmpty) {
                  return Text('No results found');
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final result = filteredData[index].data()
                              as Map<String, dynamic>;
                          final name = result['name'];
                          final rollNumber = result['rollNumber'];
                          final englishResult = result['english'];
                          final mathResult = result['math'];
                          final urduResult = result['urdu'];
                          final computerResult = result['computer'];
                          final islamiyatResult = result['islamiyat'];
                          final pakStudyResult = result['pakStudy'];

                          return Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(
                                      'Sahar Public School Rawalpindi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          'Name: ${name ?? 'Unknown'}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Roll Number: ${rollNumber ?? 'Unknown'}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'English: ${englishResult ?? '-'}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Math: ${mathResult ?? '-'}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Urdu: ${urduResult ?? '-'}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Computer: ${computerResult ?? '-'}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Islamiyat: ${islamiyatResult ?? '-'}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'pakStudy: ${pakStudyResult ?? '-'}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 8),
                                        if (englishResult != null &&
                                            mathResult != null &&
                                            urduResult != null &&
                                            computerResult != null)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Obtained Marks: ${englishResult + mathResult + urduResult + computerResult + islamiyatResult + pakStudyResult}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                'Total Marks: ${englishTotal + mathTotal + urduTotal + computerTotal + islTotal + pakTotal}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                'Percentage: ${(englishResult + mathResult + urduResult + computerResult + islamiyatResult + pakStudyResult) / (englishTotal + mathTotal + urduTotal + computerTotal + islTotal + pakTotal) * 100}%',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  )),
                              Divider(
                                height: 2,
                                color: primaryColor,
                                thickness: 2,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

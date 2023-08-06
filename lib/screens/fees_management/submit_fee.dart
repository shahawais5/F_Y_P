import 'dart:convert';
import 'package:final_year_project/config_color/constants_color.dart';
import 'package:final_year_project/widgets/round_button.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class StudentFormScreen extends StatefulWidget {
  static String routeName='StudentFormScreen';
  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? paymentIntentData;

  String? _selectedClass;
  int _selectedClassFee = 0;

  List<String> _classes = [
    'Class 1 (Fee 200)',
    'Class 2(Fee 250)',
    'Class 3(Fee 300)',
    'Class 4(Fee 400)',
    'Class 5(Fee 500+350Tax)',
  ];

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name.';
    }
    return null;
  }

  String? _validatefatherName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Fathername.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email.';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  int getClassFee(String? selectedClass) {
     if (selectedClass == 'Class 1 (Fee 200)') {
      return 200;
    }
    else if (selectedClass == 'Class 2(Fee 250)') {
      return 250;
    } else if (selectedClass == 'Class 3(Fee 300)') {
      return 300;
    } else if (selectedClass == 'Class 4(Fee 400)') {
      return 400;
    } else if (selectedClass == 'Class 5(Fee 500)+Tax') {
      return 500+350;
    }
    return 0;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save the form data to Firestore
      Map<String, dynamic> formData = {
        'name': _name,
        'fatherName': _fatherName,
        'RollNo': _rollNo,
        'Shift': _shift,
        'email': _email,
        'class': _selectedClass,
        'paymentDate': Timestamp.now(), // Store the current date and time
      };

      FirebaseFirestore.instance.collection('students').add(formData);
      makePayment(_selectedClassFee);
    }
  }

  String? _name;
  String? _fatherName;
  String? _rollNo;
  String? _shift;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Fees Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: _validateName,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'FatherName'),
                validator: _validatefatherName,
                onSaved: (value) => _fatherName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Roll No'),
                validator: _validateName,
                onSaved: (value) => _rollNo = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Shift'),
                validator: _validateName,
                onSaved: (value) => _shift = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: _validateEmail,
                onSaved: (value) => _email = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Class'),
                hint: Text('Select Class'),
                value: _selectedClass,
                onChanged: (value) {
                  setState(() {
                    _selectedClass = value;
                    _selectedClassFee = getClassFee(value);
                  });
                },
                items: _classes.map((String classItem) {
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
              SizedBox(
                height: 25,
              ),
              RoundButton(
                title: 'Pay Your Fee $_selectedClass',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await makePayment(_selectedClassFee);
                      _submitForm();
                    } catch (e) {
                      // Handle any errors that occurred during payment
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment failed. Please try again later.')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter required data')),
                    );
                  }
                },
              )

              // ElevatedButton(
              //     child: Text(''),
              //     onPressed: () {
              //       makePayment();
              //       _submitForm();
              //       //_showPaymentDialog();
              //     }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(int feeAmount) async {
    try {
      paymentIntentData = await createPaymentIntent(
          feeAmount, 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  setupIntentClientSecret:
                      'sk_test_51NIBZGGP6SirLqJgeBfPj3Sdm0QeE7gzskLMqIvlat2KjxIX9KXde26mW8eqW5ISED2hEGLYMeJftxHS1HFSBrs900vhl3yKE2',
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  //applePay: PaymentSheetApplePay.,
                  //googlePay: true,
                  //testEnv: true,
                  customFlow: true,
                  style: ThemeMode.dark,
                  // merchantCountryCode: 'US',
                  merchantDisplayName: 'Kashif'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('Payment exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              //       parameters: PresentPaymentSheetParameters(
              // clientSecret: paymentIntentData!['client_secret'],
              // confirmPayment: true,
              // )
              )
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['feeAmount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(int feeAmount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(feeAmount.toString()),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51NIBZGGP6SirLqJgeBfPj3Sdm0QeE7gzskLMqIvlat2KjxIX9KXde26mW8eqW5ISED2hEGLYMeJftxHS1HFSBrs900vhl3yKE2',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}

import 'package:flutter/material.dart';

class TeachTxtField extends StatelessWidget {
  final TextEditingController controller;
  final String labtext;
  final TextInputType keyboardType;
  TeachTxtField(
      {required this.keyboardType,
      required this.labtext,
      required this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(labelText: labtext),
      ),
    );
  }
}

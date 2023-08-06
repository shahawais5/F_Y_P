import 'package:final_year_project/config_color/constants_color.dart';
import 'package:flutter/material.dart';

class CustemTxtField extends StatelessWidget {
  final TextEditingController controller;
  final String labtext;
  final String hintText;
  final String validator;
  bool ObsecureText;
  Icon icondata;
  final TextInputType keyboardType;
  CustemTxtField(
      {required this.validator,
      required this.icondata,
      required this.hintText,
      required this.keyboardType,
      required this.labtext,
      required this.controller,
      required this.ObsecureText});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 22,
        ),
        TextFormField(
          style: TextStyle(color: kTextBlackColor,fontSize: 14,fontWeight: FontWeight.w500),
          onChanged: (value) {},
          keyboardType: keyboardType,
          controller: controller,
          obscureText: ObsecureText,
          decoration: InputDecoration(
            fillColor: Colors.grey.shade100,
            filled: true,
            helperStyle: TextStyle(color: Colors.black),
            prefixIcon: icondata,
            iconColor: Colors.black,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(color: Colors.black),
            labelText: labtext,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.blue),
              borderRadius: BorderRadius.circular(10),
            ),
            // Set border for focused state
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.blue),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return labtext;
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}

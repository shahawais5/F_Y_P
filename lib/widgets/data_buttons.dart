import 'package:final_year_project/config_color/constants_color.dart';
import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String title;
  Icon Iconsdata;
  final VoidCallback onTap;
  final bool loading;
  Buttons(
      {Key? key,
      required this.Iconsdata,
      required this.title,
      required this.onTap,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Container(
          height: 53,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.green,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Iconsdata,
              ),
              Center(
                  child: loading
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            title,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}

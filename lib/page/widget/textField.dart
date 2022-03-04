import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFields extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType type;
  final bool obscureText;
  TextFields(this.text, this.controller, this.type, this.obscureText);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          )
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            keyboardType: type,
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.only(left: 10.0),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetPopUpItems extends StatelessWidget {
  final String title;
  final IconData icon;
  const WidgetPopUpItems(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon
        ),
        SizedBox(width: 10),
        Text(
            title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey
          ),
        )
      ],
    );
  }
}

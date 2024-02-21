import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_back_button.dart';

class CustomAppBar extends StatefulWidget {
  String? title;
  bool? showLeadICon;
  PreferredSizeWidget? bottom;

  CustomAppBar({super.key, this.title, this.showLeadICon, this.bottom});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: widget.showLeadICon == true ? const CustomBackButton() : null,
      title: Text(
        widget.title ?? '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontFamily: GoogleFonts.urbanist().fontFamily,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottom: widget.bottom,
    );
  }
}

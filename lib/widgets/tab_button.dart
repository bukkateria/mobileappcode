import 'package:bukateria/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabButton extends StatelessWidget {
  final String text;
  final int selectedpage;
  final int pageNum;
  final VoidCallback onPressed;
  TabButton({
    required this.pageNum,
    required this.onPressed,
    required this.selectedpage,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              onPrimary: dark,
              elevation: 0,
              primary: selectedpage == pageNum ? grey : white),
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.montserrat(
                color: selectedpage == pageNum ? white : dark),
          )),
    );
  }
}

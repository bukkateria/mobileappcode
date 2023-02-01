import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.radius,
      required this.height,
      required this.onPressed,
      required this.width,
      this.color,
      required this.text})
      : super(key: key);

  final double radius;
  final double height;
  final double width;
  final String text;
  final Color? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius))),
          onPressed: onPressed,
          child: Text(
            text,
            style: title5.copyWith(color: white),
          )
          // controller.isLoading.value
          //     ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          //         SizedBox(
          //             height: 20,
          //             width: 20,
          //             child: CircularProgressIndicator(
          //               color: white,
          //               strokeWidth: 3,
          //             )),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text(
          //           "Please ...",
          //           style: GoogleFonts.openSans(color: white),
          //         )
          //       ]) :
          ),
    );
  }
}

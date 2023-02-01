import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/slide_bg_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/onboarding_controller.dart';

class SlideThreeView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideBG(image: "assets/images/ck1.jpg"),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  bottom: 250,
                  left: 20,
                  child: Text(
                      "To Our Talented Chefs\nYet To Be Discovered\nHere's Your Opportunity\nTo Struit Your Stuff.",
                      textAlign: TextAlign.left,
                      style: title1.copyWith(color: white, fontSize: 27))),
              Positioned(
                  bottom: 170,
                  left: 20,
                  child: Text(
                      "Simply upload your menus that will be \npublished to foodies within walking \ndistance from you.",
                      style: body2.copyWith(color: white))),
            ],
          ),
        )
      ],
    );
  }
}

import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/slide_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/onboarding_controller.dart';

class SlideTwoView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideBG(
          image: "assets/images/ck2.jpg",
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  bottom: 250,
                  left: 20,
                  child: Text("Think Global \nEat Local.",
                      textAlign: TextAlign.left,
                      style: title1.copyWith(color: white, fontSize: 27))),
              Positioned(
                  bottom: 160,
                  left: 20,
                  child: Text(
                      "Order delicious meals on Bukkateria \nfrom chefs within walking distance \nfrom you",
                      style: body2.copyWith(color: white))),
            ],
          ),
        )
      ],
    );
  }
}

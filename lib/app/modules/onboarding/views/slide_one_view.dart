import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/slide_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/onboarding_controller.dart';

class SlideOneView extends GetView<OnboardingController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideBG(
          image: "assets/images/ck3.jpg",
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  bottom: 250,
                  left: 20,
                  child: Text("Thousands \nOf Recipes \nJust For You.",
                      textAlign: TextAlign.left,
                      style: title1.copyWith(color: white, fontSize: 27))),
              Positioned(
                  bottom: 160,
                  left: 20,
                  child: Text(
                      "View recipes from around the world \nand also share your favorite recipes and \nfood adventures with your followers",
                      style: body2.copyWith(color: white))),
            ],
          ),
        )
      ],
    );
  }
}

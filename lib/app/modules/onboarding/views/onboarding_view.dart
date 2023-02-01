import 'dart:ui';
import 'package:bukateria/app/modules/login/views/login_view.dart';
import 'package:bukateria/app/modules/onboarding/views/slide_one_view.dart';
import 'package:bukateria/app/modules/onboarding/views/slide_three_view.dart';
import 'package:bukateria/app/modules/onboarding/views/slide_two_view.dart';
import 'package:bukateria/app/modules/register/views/register_view.dart';
import 'package:bukateria/app/modules/register/views/social_register_view.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../cubit/onboarding_cubit/onboard_cubit.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends StatefulWidget {
  // const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  PageController _controller = PageController();
  bool isLast = false;
  @override
  Widget build(BuildContext context) {

    return BlocListener<OnboardCubit, OnboardState>(listener: (context,state){
      print("-----------------${state.status}");
      if(state.status == OnboardStatus.success){
        Get.offAll(() => RegisterView());
      }
    },child: BlocBuilder<OnboardCubit, OnboardState>(
        builder: (context, state) {
    return Stack(
      children: [
        PageView(
          onPageChanged: ((index) => {
                setState(() => {isLast = index == 2})
              }),
          controller: _controller,
          children: [SlideTwoView(), SlideOneView(),  SlideThreeView()],
        ),
        Container(
            alignment: Alignment(0, 0.9),
            child: !isLast
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            context.read<OnboardCubit>().setOnboard("YES");
                          },
                          child: Text("Skip",
                              style: GoogleFonts.openSans(
                                  color: white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700))),
                      SmoothPageIndicator(controller: _controller, count: 3),
                      TextButton(
                          onPressed: () => {
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn)
                              },
                          child: InkWell(
                              child: Text("Next",
                                  style: GoogleFonts.openSans(
                                      color: white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)))),
                    ],
                  )
                : Container(
                    width: Get.width,
                    height: 45,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<OnboardCubit>().setOnboard("YES");
                      },
                      child: Text("Proceed"),
                      style: ElevatedButton.styleFrom(primary: primary),
                    ),
                  ))
      ],
    );
        },
    ),);
  }
}

import 'dart:developer';

import 'package:bukateria/app/modules/dashboard/views/vendor_dashboard.dart';
import 'package:bukateria/app/modules/onboarding/views/onboarding_view.dart';
import 'package:bukateria/app/modules/register/views/user_info_view.dart';
import 'package:bukateria/app/modules/verifyEmail/verify_email.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../cubit/splash_cubit/splash_cubit.dart';
import '../../../../repository/auth_repository.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../register/views/register_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

/*    MyPref myPref = MyPref.getInstance();
    myPref.getData();

    Future.delayed(const Duration(seconds: 5),(){
      FirebaseAuth.instance.currentUser == null
          ? myPref.result == "NO" || myPref.result == "Splash"
          ? AppPages.INITIAL
          : AppPages.REGISTER_VIEW
          : userData.data.get("userType").toString() == "foodie" ? AppPages
          .USER_DASHBOARD : AppPages.VENDOR_DASHBOARD,
    });*/
  }

  final user = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    log('user id is : $user');
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        log("-----------------${state.status}");

        if (state.status == SplashStatus.emailVerified) {
          Get.offAll(() => VerifyEmail());
        } else if (state.status == SplashStatus.userInfoVerify) {
          Get.offAll(() => UserInfoView());
        } else if (state.status == SplashStatus.signup) {
          Get.offAll(() => RegisterView());
        } else if (state.status == SplashStatus.onboard) {
          Get.offAll(() => OnboardingView());
        } else if (state.status == SplashStatus.home) {
          Get.offAll(() => DashboardView());
        } else if (state.status == SplashStatus.vendorHome) {
          Get.offAll(() => VendorDashboard());
        }
      },
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          if (FirebaseAuth.instance.currentUser != null) {
            log('user not null in splash screen');
            return StreamBuilder<DocumentSnapshot?>(
                stream: AuthRepository().userDetails,
                builder: (context, result) {
                  if (result.hasData) {
                    log('user has data');
                    log('user type in splash is : ${result.data?.get("userType") ?? ""}');
                    log('user uid in splash is : ${result.data?.get("uid") ?? ""}');
                    context.read<SplashCubit>().checkCredentials(
                        result.data?.get("userType") ?? "",
                        result.data?.get("uid") ?? "");
                  }
                  return Scaffold(
                    backgroundColor: primary,
                    body: Center(
                      child: Image.asset(
                        "assets/images/splash.png",
                        height: 100,
                        width: 100,
                      ),
                    ),
                  );
                });
          } else {
            log('user is null in splash screen');
            context.read<SplashCubit>().checkCredentials("", "");
            return Scaffold(
              backgroundColor: primary,
              body: Center(
                child: Image.asset(
                  "assets/images/splash.png",
                  height: 100,
                  width: 100,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

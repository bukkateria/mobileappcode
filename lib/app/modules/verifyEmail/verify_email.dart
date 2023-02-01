import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/colors.dart';
import '../../../themes/text.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input.dart';
import '../login/views/login_view.dart';

class VerifyEmail extends StatefulWidget {
  VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Verify Email",
              style: title3,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 30),
              child: Image.asset(
                'assets/images/Bukkateria_Logomark_Colour.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            loader
                ? const Center(child: CircularProgressIndicator(color: primary))
                : CustomButton(
                    width: Get.width,
                    radius: 30,
                    height: 50,
                    text: "Verify Email",
                    color: primary,
                    onPressed: () async {
                      // await FirebaseAuth.instance.signOut();
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        setState(() {
                          loader = true;
                        });
                        await user.sendEmailVerification().then((value) {
                          setState(() {
                            loader = false;
                          });
                          Get.showSnackbar(const GetSnackBar(
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.green,
                            message: 'Email Verification sent',
                          ));

                          Get.offAll(() => LoginView());
                        }).catchError((e) {
                          setState(() {
                            loader = false;
                          });
                          print('error is : $e');
                        });
                      }
                    },
                  ),
          ],
        ),
      ),
    ));
  }
}

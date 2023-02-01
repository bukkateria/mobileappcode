import 'dart:developer';

import 'package:bukateria/app/modules/login/views/role_view_view.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/cubit/reset_password/reset_cubit.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class ForgotPasswordView extends GetView<LoginController> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetCubit, ResetState>(
      listener: (context, state) {
        print("-----------------${state.status}");
        if (state.status == ResetStatus.success) {
          Get.back();
          Get.back();
          Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            message: 'password sent to your email',
          ));
        } else if (state.status == ResetStatus.submitting) {
          CommonViews.showProgressDialog(context);
        } else if (state.status == ResetStatus.error) {
          Get.back();
          Get.back();
          Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            message: 'password sending failed',
          ));
        }
      },
      child: BlocBuilder<ResetCubit, ResetState>(
        builder: (context, state) {
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
                    "Reset Password",
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
                  CustomInput(
                    height: 70,
                    controller: _emailController,
                    hintText: "Email",
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    borderRadius: 10,
                    onChanged: (value) {
                      context.read<ResetCubit>().emailChanged(value);
                    },
                  ),
                  CustomButton(
                    width: Get.width,
                    radius: 30,
                    height: 50,
                    text: "Reset Password",
                    color: primary,
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter Email")));
                      } else {
                        log(('reset clicked'));
                        context.read<ResetCubit>().resetPassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}

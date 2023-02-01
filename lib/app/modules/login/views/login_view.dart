import 'package:bukateria/app/modules/dashboard/views/dashboard_view.dart';
import 'package:bukateria/app/modules/dashboard/views/vendor_dashboard.dart';
import 'package:bukateria/app/modules/login/views/forgot_password_view.dart';
import 'package:bukateria/app/modules/login/views/role_view_view.dart';
import 'package:bukateria/app/modules/register/views/register_view.dart';
import 'package:bukateria/app/modules/register/views/user_info_view.dart';
import 'package:bukateria/app/modules/verifyEmail/verify_email.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../cubit/signin_cubit.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninCubit, SigninState>(
      listener: (context, state) {
        print("-----------------${state.status}");
        if (state.status == SigninStatus.emailVerified) {
          Get.offAll(() => VerifyEmail());
        } else if (state.status == SigninStatus.userInofVerify) {
          Get.offAll(() => UserInfoView());
        } else if (state.status == SigninStatus.success) {
          Get.offAll(() => const RoleRedirectWidget());
        } else if (state.status == SigninStatus.submitting) {
          CommonViews.showProgressDialog(context);
        } else if (state.status == SigninStatus.error) {
          Get.back();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Error")));
        }
      },
      child: BlocBuilder<SigninCubit, SigninState>(
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
                    "Sign In",
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
                      context.read<SigninCubit>().emailChanged(value);
                    },
                  ),
                  CustomInput(
                    height: 70,
                    hintText: "Password",
                    labelText: "Password",
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    isPassword: true,
                    prefixIcon: Icons.lock,
                    borderRadius: 10,
                    onChanged: (value) {
                      context.read<SigninCubit>().passwordChanged(value);
                    },
                  ),
                  CustomButton(
                    width: Get.width,
                    radius: 30,
                    height: 50,
                    text: "Sign In",
                    color: primary,
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter Email first")));
                      } else if (_passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please enter password first")));
                      } else {
                        context.read<SigninCubit>().signinWithCredentials();
                      }
                    },
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => ForgotPasswordView()),
                        child: Text(
                          "Forgot Password?",
                          style: body3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => Get.to(() => RegisterView()),
                    child: Text(
                      "Don't have an account yet? signup",
                      style: body3,
                    ),
                  )
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}

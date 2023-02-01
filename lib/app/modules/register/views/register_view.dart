import 'dart:developer';

import 'package:bukateria/app/modules/login/views/login_view.dart';
import 'package:bukateria/app/modules/login/views/social_login_view.dart';
import 'package:bukateria/app/modules/register/views/user_info_view.dart';
import 'package:bukateria/app/modules/verifyEmail/verify_email.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/cubit/signup_cubit.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';

import '../../login/views/role_view_view.dart';
import '../../pages/google_places_search.dart';

class RegisterView extends StatefulWidget {
  RegisterView({Key? key, this.selectedCountry}) : super(key: key);
  String? selectedCountry;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String selectedLocation = "";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  FocusNode _userFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  bool check = false;
  bool checkEmail = false;
  bool showError = false;
  bool showEmailError = false;
  @override
  void initState() {
    _userFocus.addListener(() {
      if (_userFocus.hasFocus) {
        check = true;
      } else {
        if (check) {
          FirebaseFirestore.instance
              .collection("User")
              .where("username", isEqualTo: _usernameController.text)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              setState(() {
                showError = true;
              });
            } else {
              setState(() {
                showError = false;
              });
            }
          });

          print("--------------------focus out $showError");
        }
      }
    });

    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        checkEmail = true;
      } else {
        if (checkEmail) {
          FirebaseFirestore.instance
              .collection("User")
              .where("email", isEqualTo: _emailController.text)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              setState(() {
                showEmailError = true;
              });
            } else {
              setState(() {
                showEmailError = false;
              });
            }
          });

          print("--------------------focus out $showEmailError");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        log('my bloc state is : $state');
        if (state.status == SignupStatus.emailVerified) {
          Get.offAll(() => VerifyEmail());
        } else if (state.status == SignupStatus.success) {
          // Get.offAll(() => UserInfoView());
          Get.offAll(() => const RoleRedirectWidget());
        } else if (state.status == SignupStatus.submitting) {
          CommonViews.showProgressDialog(context);
        }
      },
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          return Scaffold(
              body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/big_logo.png"),
                        colorFilter: ColorFilter.mode(
                            white.withOpacity(0.1), BlendMode.modulate))),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 30),
                      child: Image.asset(
                        'assets/images/Bukkateria_Logomark_Colour.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomInput(
                        height: 70,
                        hintText: "Email",
                        labelText: "Email",
                        controller: _emailController,
                        focusNode: _emailFocus,
                        errorText:
                            showEmailError ? "email is already taken" : null,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        borderRadius: 10,
                        onChanged: (value) {
                          context.read<SignupCubit>().emailChanged(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomInput(
                        height: 70,
                        hintText: "Username",
                        labelText: "Username",
                        errorText:
                            showError ? "Username is already taken" : null,
                        focusNode: _userFocus,
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.person,
                        borderRadius: 10,
                        onChanged: (value) {
                          context.read<SignupCubit>().usernameChanged(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomInput(
                        height: 70,
                        hintText: "Password",
                        labelText: "Password",
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        prefixIcon: Icons.lock,
                        onChanged: (value) {
                          context.read<SignupCubit>().passwordChanged(value);
                        },
                        borderRadius: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomInput(
                        height: 70,
                        hintText: "Confirm Password",
                        labelText: "Confirm Password",
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        prefixIcon: Icons.lock,
                        borderRadius: 10,
                        onChanged: (value) {
                          context
                              .read<SignupCubit>()
                              .confirmPasswordChanged(value);
                        },
                      ),
                    ),
                    /* GestureDetector(
                        onTap:  () => Get.to(() =>  PlaceSearch(onSelection: (location){
                          setState((){
                            selectedLocation = location;
                          });
                        },)),
                        child: Container(
                            color: greyLight.withOpacity(0.3),
                            child: ListTile(
                              title: Text(
                                selectedLocation,
                                style: body3,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                            )),
                      ),*/
                    CustomButton(
                        width: Get.width / 2,
                        radius: 30,
                        height: 50,
                        text: "Create Account",
                        color: primary,
                        // onPressed: () => Get.offAll(() => SocialLoginView())),
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter Email first")));
                          } else if (_passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter password first")));
                          } else if (_usernameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter password first")));
                          } else if (_confirmPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter password first")));
                          } else if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Password and confirm password must match!")));
                          } else {
                            if (!showError && !showEmailError) {
                              context
                                  .read<SignupCubit>()
                                  .signupWithCredentials();
                            }
                          }
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => LoginView()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: body3,
                          ),
                          Text(
                            "login",
                            style: body3.copyWith(color: primary),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}

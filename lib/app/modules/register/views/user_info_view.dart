import 'dart:developer';

import 'package:bukateria/app/modules/login/views/login_view.dart';
import 'package:bukateria/app/modules/login/views/social_login_view.dart';
import 'package:bukateria/app/modules/verifyEmail/verify_email.dart';
import 'package:bukateria/common_views.dart';
import 'package:bukateria/cubit/user_info/userinfo_cubit.dart';
import 'package:bukateria/repository/auth_repository.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import 'package:get/get.dart';

import '../../login/views/role_view_view.dart';
import '../../pages/google_places_search.dart';

class UserInfoView extends StatefulWidget {
  UserInfoView({Key? key, this.selectedCountry}) : super(key: key);
  String? selectedCountry;

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  String selectedLocation = "";
  TextEditingController _ageController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  AuthRepository _authRepository = AuthRepository();
  bool check = false;
  Future<void> getCurrentPosition() async {
    var position = await _authRepository.determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //print(placemarks);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      // String address =  '${place.locality}, ${place.administrativeArea}, ${place.country}';
      String address =
          '${place.subAdministrativeArea}, ${place.administrativeArea}';
      Map<String, dynamic> map = {};
      map["lat"] = position.latitude;
      map["long"] = position.longitude;
      map["address"] = address;
      log('address is : $address');
      setState(() {
        _locationController.text = address;
      });
    }
  }

  @override
  void initState() {
    getCurrentPosition();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoCubit, UserInfoState>(
      listener: (context, state) {
        if (state.status == UserInfoStatus.error) {
          Get.offAll(() => LoginView());
        } else if (state.status == UserInfoStatus.success) {
          Get.offAll(() => const RoleRedirectWidget());
        } else if (state.status == UserInfoStatus.submitting) {
          CommonViews.showProgressDialog(context);
        }
      },
      child: BlocBuilder<UserInfoCubit, UserInfoState>(
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
                        image: const AssetImage("assets/images/big_logo.png"),
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
                        hintText: "Age",
                        labelText: "Age",
                        controller: _ageController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.person,
                        borderRadius: 10,
                        onChanged: (value) {
                          context.read<UserInfoCubit>().ageChanged(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomInput(
                        height: 70,
                        hintText: "Sex",
                        labelText: "Sex",
                        controller: _sexController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.person_outline,
                        borderRadius: 10,
                        onChanged: (value) {
                          context.read<UserInfoCubit>().sexChanged(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomInput(
                        height: 70,
                        hintText: "Location",
                        labelText: "Location",
                        controller: _locationController,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.location_on,
                        onChanged: (value) {
                          context.read<UserInfoCubit>().locationChanged(value);
                        },
                        borderRadius: 10,
                      ),
                    ),
                    CustomButton(
                        width: Get.width / 2,
                        radius: 30,
                        height: 50,
                        text: "Update Account",
                        color: primary,
                        // onPressed: () => Get.offAll(() => SocialLoginView())),
                        onPressed: () {
                          context
                              .read<UserInfoCubit>()
                              .locationChanged(_locationController.text);
                          if (_ageController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter age first")));
                          } else if (_locationController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter location first")));
                          } else if (_sexController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please enter gender first")));
                          } else {
                            log('update method');
                            context.read<UserInfoCubit>().updateUserData();
                          }
                        }),
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

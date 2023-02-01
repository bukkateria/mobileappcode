import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:bukateria/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../../../common_views.dart';
import '../../../../cubit/account_cubit/account_cubit.dart';
import '../../../../cubit/post_cubit/post_cubit.dart';

class PickupInfo extends StatelessWidget {
  PickupInfo({Key? key}) : super(key: key);

  static const phoneKey = 'phone-key';
  static const nameKey = 'name-key';

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocListener<AccountCubit, AccountState>(listener: (context,state){

    if(state.status == AccountStatus.contactSuccess){
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully updated!")));
    }else if(state.status == AccountStatus.contactSubmitting){
      CommonViews.showProgressDialog(context);
    }else if (state.status == AccountStatus.error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong!")));
    }else if (state.status == AccountStatus.missingField){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter something!")));
    }
  },child: BlocBuilder<AccountCubit, AccountState>(
  builder: (context, state)
  {
  return StreamBuilder<firestore.DocumentSnapshot>(
  stream: context.read<PostCubit>().getSpecificUser(FirebaseAuth.instance.currentUser?.uid ?? ""),
  builder: (context,snap){

    phoneController.text = snap.data?["phone"] ?? "";
    addressController.text = snap.data?["address"] ?? "";

    return SimpleSettingsTile(
      title: "Contact Settings",
      subtitle: "Phone, Address ",
      leading: Icon(Icons.settings),
      onTap: () {},
      child: SettingsScreen(title: "Contact Settings", children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: TextFormField(
                  //onChanged: (val) => context.read<AccountCubit>().phoneChanged(val),
                  autofocus: true,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Phone Number',
                    hintStyle: body3,
                    labelStyle: body3,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE5E5E5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE5E5E5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: greyLight.withOpacity(0.2),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: TextFormField(
                  //onChanged: (val) => context.read<AccountCubit>().addressChanged(val),
                  autofocus: true,
                  obscureText: false,
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Enter your pick address',
                    hintText: 'Enter your pick address',
                    hintStyle: body3,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: greyLight.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: greyLight.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: greyLight.withOpacity(0.2),
                  ),
                  maxLines: 3,
                ),
              ),
              CustomButton(
                width: Get.width,
                radius: 30,
                height: 50,
                text: "Save",
                color: dark,
                onPressed: ()  {
                  print("----------------- ${state.phone != null} ${(state.phone ?? "").isNotEmpty} ${state.address != null} ${ (state.address ?? "").isNotEmpty}");

                  context.read<AccountCubit>().addressChanged(addressController.text);
                  context.read<AccountCubit>().phoneChanged(phoneController.text);

                  context.read<AccountCubit>().updateContactInfo();

                },
              ),
            ],
          ),
        )
      ]),
    );
  },);
  }),
  );
  }

  Widget buildPrivacy() => SimpleSettingsTile(
        title: "Privacy",
        subtitle: "",
        leading: Icon(Icons.privacy_tip),
        onTap: () {},
      );

  Widget buildTOS() => SimpleSettingsTile(
        title: "Terms & Conditions",
        subtitle: "",
        leading: Icon(Icons.document_scanner),
        onTap: () {},
      );
}

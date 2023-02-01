import 'package:bukateria/app/modules/menus/views/create_menu_view.dart';
import 'package:bukateria/app/modules/pages/holder.dart';
import 'package:bukateria/app/modules/recipes/views/create_recipe_view.dart';
import 'package:bukateria/app/modules/vlog/views/add_vlog_view.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:bukateria/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CreateView extends StatelessWidget {
  CreateView({Key? key}) : super(key: key);

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/cooking.png",
                width: 100,
                height: 100,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Create something interesting",
                style: title3,
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                "Share your knowledge, inspire others",
                style: body4,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: context.read<PostCubit>().getSpecificUser(
                          FirebaseAuth.instance.currentUser?.uid ?? ""),
                      builder: (context, snapshot) {
                        return CustomButton(
                            radius: 10,
                            color: dark,
                            height: 35,
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("User")
                                  .doc(FirebaseAuth.instance.currentUser?.uid ??
                                      "")
                                  .get()
                                  .then((value) {
                                if (value["address"] != "" &&
                                    value["phone"] != "") {
                                  Get.to(() => AddMenu());
                                } else {
                                  showAddDialog(context, _phoneController,
                                      _addressController);
                                }
                              });
                            },
                            width: 90,
                            text: "menu");
                      }),
                  const SizedBox(width: 10),
                  CustomButton(
                      radius: 10,
                      color: dark,
                      height: 35,
                      onPressed: () {
                        Get.to(() => AddRecipe());
                      },
                      width: 90,
                      text: "Recipe"),
                  SizedBox(width: 10),
                  CustomButton(
                      radius: 10,
                      color: dark,
                      height: 35,
                      onPressed: () {
                        Get.to(() => AddVlog());
                      },
                      width: 90,
                      text: "Explore"),
                ],
              )
            ],
          ),
        ),
        Container()
      ],
    );
  }
}

showAddDialog(BuildContext context, _phoneController, _addressController) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 12,
                ),
                Text("Add Pickup Contact Detail",
                    style: title5.copyWith(color: primary)),
                SizedBox(
                  height: 12,
                ),
                Text("Please fill the details to proceed",
                    style: title7.copyWith(color: grey)),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: _phoneController,
                      onChanged: (_) {},
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        // labelText: 'Description',
                        hintText: 'Enter your phone number',
                        hintStyle: body3.copyWith(color: grey),
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
                      maxLines: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      controller: _addressController,
                      onChanged: (_) {},
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        // labelText: 'Description',
                        hintText: 'Enter your address',
                        hintStyle: body3.copyWith(color: grey),
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
                      maxLines: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primary)),
                      onPressed: () async {
                        if (_phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter phone number")));
                        } else if (_addressController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter address")));
                        } else {
                          Map<String, dynamic> map = {};
                          map["phone"] = _phoneController.text;
                          map["address"] = _addressController.text;
                          FirebaseFirestore.instance
                              .collection("User")
                              .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
                              .update(map)
                              .then((value) {
                            Navigator.pop(context);
                            Get.to(() => AddMenu());
                          });
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: Text("Add")))),
                )
              ],
            ),
          ),
        );
      });
}

import 'dart:io';

import 'package:bukateria/app/modules/account/views/edit_profile.dart';
import 'package:bukateria/app/modules/account/views/carousel_image_view.dart';
import 'package:bukateria/app/modules/account/views/pickup_info_page.dart';
import 'package:bukateria/app/modules/account/views/security_settings_page.dart';
import 'package:bukateria/app/modules/account/views/settings_page.dart';
import 'package:bukateria/app/modules/dashboard/views/dashboard_view.dart';
import 'package:bukateria/app/modules/dashboard/views/vendor_dashboard.dart';
import 'package:bukateria/app/modules/login/views/login_view.dart';
import 'package:bukateria/app/modules/notifications/views/notifications_view.dart';
import 'package:bukateria/app/modules/pause_posts/views/pause_post_view.dart';
import 'package:bukateria/app/modules/splash/views/splash_view.dart';
import 'package:bukateria/cubit/account_cubit/account_cubit.dart';
import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common_views.dart';
import '../../../../themes/text.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  TextEditingController? myBioController;
  TextEditingController? yourNameController1;
  TextEditingController? yourNameController2;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool mode = false;
  var userType = "";

  @override
  void initState() {
    super.initState();
    myBioController = TextEditingController();
    yourNameController1 = TextEditingController();
    yourNameController2 = TextEditingController();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      context.read<AccountCubit>().statusChange(AccountStatus.submitting);
      context.read<AccountCubit>().imageChanged(image.path);
      context
          .read<AccountCubit>()
          .updateImage(FirebaseAuth.instance.currentUser?.uid ?? "", "profile");

      /*setState(() {
          imagePath = image.path;
      });*/

    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state.status == AccountStatus.success) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully updated!")));
        } else if (state.status == AccountStatus.submitting) {
          CommonViews.showProgressDialog(context);
        } else if (state.status == AccountStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong!")));
        } else if (state.status == AccountStatus.missingField) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter something!")));
        }
      },
      child: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
        return StreamBuilder<firestore.DocumentSnapshot>(
          stream: context
              .read<PostCubit>()
              .getSpecificUser(FirebaseAuth.instance.currentUser?.uid ?? ""),
          builder: (context, snap) {
            return Scaffold(
              key: scaffoldKey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: const Color(0xFFDBE2E7),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    2, 2, 2, 2),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: (snap.data?["image"].toString() ?? "")
                                          .isEmpty
                                      ? Image.asset(
                                          'assets/images/square.jpg',
                                          fit: BoxFit.fitWidth,
                                        )
                                      : FadeInImage(
                                          fit: BoxFit.fitWidth,
                                          image: NetworkImage(
                                              //widget.product[Constants.image]
                                              '${snap.data!["image"].toString()}'),
                                          placeholder: const AssetImage(
                                            "assets/images/big_logo.png",
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        snap.data?["name"].toString() ?? "",
                        textAlign: TextAlign.center,
                        style: title3,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: ListTile(
                      //     onTap: () {
                      //       Get.to(() => CarouselImagesView());
                      //     },
                      //     leading: Icon(Icons.image),
                      //     subtitle: Text('Add carousel'),
                      //     title: Text('Carousel'),
                      //     trailing: Padding(
                      //       padding: const EdgeInsets.only(right: 17),
                      //       child: Icon(Icons.arrow_forward_ios, size: 16),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: SettingsGroup(title: "", children: [
                          const SizedBox(height: 15),
                          const SettingsPage(),
                          const SizedBox(height: 15),
                          const EditProfile(),
                          const SizedBox(
                            height: 15,
                          ),
                          PickupInfo(),
                          buildChefSwitch(snap.data?["userType"] ?? ""),
                          const SizedBox(
                            height: 15,
                          ),
                          const SecuritySettingsPage(),
                          const SizedBox(
                            height: 15,
                          ),
                          buildPause(),
                          const SizedBox(
                            height: 15,
                          ),
                          buildNotifications(),
                          const SizedBox(
                            height: 15,
                          ),
                          buildLogout(),
                          const SizedBox(
                            height: 15,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildsettings() => SimpleSettingsTile(
        title: "Setting",
        subtitle: "",
        leading: const Icon(Icons.settings),
        onTap: () {},
      );

  Widget buildEditProfile() => SimpleSettingsTile(
        title: "Edit Profile",
        subtitle: "",
        leading: const Icon(Icons.person),
        onTap: () {},
      );

  Widget buildOrders() => SimpleSettingsTile(
        title: "Business Info",
        subtitle: "",
        leading: const Icon(Icons.food_bank),
        onTap: () {},
        child: Container(),
      );

  Widget buildPause() => SimpleSettingsTile(
        title: "Paused Posts",
        subtitle: "",
        leading: const Icon(Icons.pause),
        onTap: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context)=> PausePostView()));
        },
        child: PausePostView(),
      );

  Widget buildNotifications() => SimpleSettingsTile(
        title: "Notifications",
        subtitle: "",
        leading: const Icon(Icons.notifications),
        onTap: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context)=> PausePostView()));
        },
        child: NotificationView(),
      );

  Widget buildChefSwitch(String userType) {
    print("-------------${userType == "foodie" ? true : false}");

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 16,
          ),
          Icon(
            Icons.switch_access_shortcut,
            size: 24,
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
              child: Text(
            "chef-switch",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          )),
          CupertinoSwitch(
              value: userType == "foodie" ? false : true,
              onChanged: (val) {
                context
                    .read<AccountCubit>()
                    .userTypeChanged(!val ? "foodie" : "vendor");
                context.read<AccountCubit>().updateUserType();
                if (val == true) {
                  Get.offAll(() => const VendorDashboard());
                } else {
                  Get.offAll(() => DashboardView());
                }
              }),
          SizedBox(
            width: 16,
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
    return SwitchSettingsTile(
      title: "chef-switch",
      settingKey: userType == "foodie" ? "chef-switch" : "Foodie Mode",
      subtitle: "",
      leading: const Icon(Icons.switch_access_shortcut),
      onChange: (val) {
        context
            .read<AccountCubit>()
            .userTypeChanged(!val ? "foodie" : "vendor");
        context.read<AccountCubit>().updateUserType();
        if (val == true) {
          Get.offAll(() => const VendorDashboard());
        } else {
          Get.offAll(() => DashboardView());
        }
      },
    );
  }

  Widget buildLogout() => SimpleSettingsTile(
        title: "Logout",
        subtitle: "",
        leading: const Icon(Icons.logout),
        onTap: () {
          FirebaseAuth.instance.signOut();
          //  context.read<AccountCubit>().statusChange(AccountStatus.submitting);
          Settings.clearCache();
          Get.offAll(() => LoginView());
        },
      );
}

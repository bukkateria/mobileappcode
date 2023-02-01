import 'package:bukateria/app/modules/account/views/edit_profile.dart';
import 'package:bukateria/app/modules/account/views/pickup_info_page.dart';
import 'package:bukateria/app/modules/account/views/security_settings_page.dart';
import 'package:bukateria/app/modules/account/views/settings_page.dart';
import 'package:bukateria/app/modules/dashboard/views/dashboard_view.dart';
import 'package:bukateria/app/modules/dashboard/views/vendor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';

class ChefAccountView extends StatefulWidget {
  const ChefAccountView({Key? key}) : super(key: key);

  @override
  _ChefAccountViewState createState() => _ChefAccountViewState();
}

class _ChefAccountViewState extends State<ChefAccountView> {
  TextEditingController? myBioController;
  TextEditingController? yourNameController1;
  TextEditingController? yourNameController2;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    myBioController = TextEditingController();
    yourNameController1 = TextEditingController();
    yourNameController2 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFDBE2E7),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                      child: Container(
                        width: 90,
                        height: 90,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/square.jpg',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SettingsGroup(title: "", children: [
                  SettingsPage(),
                  SizedBox(
                    height: 15,
                  ),
                  EditProfile(),
                  SizedBox(
                    height: 15,
                  ),
                  PickupInfo(),
                  buildChefSwitch(),
                  SizedBox(
                    height: 15,
                  ),
                  SecuritySettingsPage(),
                  SizedBox(
                    height: 15,
                  ),
                  buildLogout(),
                  SizedBox(
                    height: 15,
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildsettings() => SimpleSettingsTile(
        title: "Setting",
        subtitle: "",
        leading: Icon(Icons.settings),
        onTap: () {},
      );

  Widget buildEditProfile() => SimpleSettingsTile(
        title: "Edit Profile",
        subtitle: "",
        leading: Icon(Icons.person),
        onTap: () {},
      );

  Widget buildOrders() => SimpleSettingsTile(
        title: "Business Info",
        subtitle: "",
        leading: Icon(Icons.food_bank),
        onTap: () {},
        child: Container(),
      );

  Widget buildChefSwitch() => SwitchSettingsTile(
        title: "Chef Mode",
        settingKey: "chef-switch",
        subtitle: "",
        leading: Icon(Icons.switch_access_shortcut),
        onChange: (val) {
          if (val == true) {
            Get.offAll(() => VendorDashboard());
          } else {
            Get.offAll(() => DashboardView());
          }
        },
      );

  Widget buildLogout() => SimpleSettingsTile(
        title: "LogOut",
        subtitle: "",
        leading: Icon(Icons.logout),
        onTap: () {
          Settings.clearCache();
        },
      );
}

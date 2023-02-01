import 'package:bukateria/app/modules/pages/privacy.dart';
import 'package:bukateria/app/modules/pages/tos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: "Security",
      subtitle: "Privacy, TOS ",
      leading: Icon(Icons.settings),
      onTap: () {},
      child: SettingsScreen(title: "Security", children: [
        SizedBox(
          height: 15,
        ),
        buildPrivacy(),
        SizedBox(
          height: 15,
        ),
        buildTOS(),
      ]),
    );
  }

  Widget buildPrivacy() => SimpleSettingsTile(
        title: "Privacy",
        subtitle: "",
        leading: Icon(Icons.privacy_tip),
        onTap: () => Get.to(() => PrivacyView()),
      );

  Widget buildTOS() => SimpleSettingsTile(
        title: "Terms & Conditions",
        subtitle: "",
        leading: Icon(Icons.document_scanner),
        onTap: () => Get.to(() => TOSView()),
      );
}

import 'package:bukateria/cubit/post_cubit/post_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as sSetting;
import 'package:flutter_bloc/flutter_bloc.dart';



class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const notification_key = 'notification-key';
  static const notification_enabled_key = 'notification-key';

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: "Settings",
      subtitle: "Notifications",
      leading: Icon(Icons.settings),
      onTap: () {},
      child: SettingsScreen(title: "Settings", children: [
        SizedBox(
          height: 15,
        ),
        StreamBuilder<DocumentSnapshot>(
            stream: context.read<PostCubit>().getSpecificUser(FirebaseAuth.instance.currentUser?.uid ?? ""),
            builder: (context, snapshot) {
              print("---------------------see -------- ${snapshot.data?["notification"]}");
              setValue(snapshot.data?["notification"] ?? false);

              return MaterialButton(onPressed: (){
               /* Map<String,dynamic> map = {};
                map["notification"] = !(snapshot.data?["notification"] ?? false);
                FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid ?? "").update(map).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notification setting changed successfully")));
                });*/
              },child: Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(child: Text("Notification")),
                    CupertinoSwitch(value: snapshot.data?["notification"] ?? false, onChanged: (va){
                      Map<String,dynamic> map = {};
                      map["notification"] = !(snapshot.data?["notification"] ?? false);
                      FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid ?? "").update(map).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notification setting changed successfully")));
                      });
                    })
                  ],
                ),
              ),);

              return SwitchSettingsTile(
                title: "Notification",
                settingKey: notification_key,
                //enabled: snapshot.data?["notification"] ?? false,
                defaultValue: true,
                subtitle: "",
                leading: Icon(Icons.notifications),
                onChange: (val) {
                  Map<String,dynamic> map = {};
                  map["notification"] = !(snapshot.data?["notification"] ?? false);
                  FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser?.uid ?? "").update(map).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notification setting changed successfully")));
                  });
                },
              );
            }
        ),
        SizedBox(
          height: 15,
        ),
      ]),
    );
  }

  setValue(bool value){
    sSetting.Settings.setValue<bool>(notification_key, value).then((value) {
      setState(() {

      });
    });
  }




}


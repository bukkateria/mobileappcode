
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class MyPref{
  late SharedPreferences preferences;
  String result = "No";
  MyPref.getInstance();

  setData({String? userType, String? onboard }) async {
    preferences = await SharedPreferences.getInstance();
    if(userType!=null) {
      preferences.setString("userType", userType);
    }
    if(onboard!=null){
      preferences.setString("onboard", onboard);
    }
  }
  Future<String> getData() async{
    preferences = await SharedPreferences.getInstance();

    String? userType = preferences.getString("userType");
    String? onboard = preferences.getString("onboard");

    if(onboard!=null){
      result = "ONBOARD";
    }
    if(userType!=null){
      if(result == "ONBOARD"){
        result = "BOTH";
      }else{
        result = "USERTYPE";
      }
    }
    return result;

  }


}
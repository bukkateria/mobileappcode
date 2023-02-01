import 'package:bukateria/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonViews{
  static void showProgressDialog(BuildContext context){

    showDialog(context: context, builder: (context){
      return Column(
        children: [
          Expanded(child: Container(),),
          Row(
            children: [
              Expanded(child: Container(),),
              Container(
                  width: 100,height: 100,
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(
                    color: white,
                  )),
              Expanded(child: Container(),),
            ],
          ),
          Expanded(child: Container(),),

        ],
      );
    });
  }
}
import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

enum MenuType { Main, Appetizer, Drink, Desert, Side }

class CustomRadio extends StatelessWidget {
  CustomRadio(
      {Key? key,
      required this.menuType,
      required this.title,
      required this.value,
      this.onChanged})
      : super(key: key);

  String title;
  MenuType value;
  MenuType? menuType;
  Function(MenuType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<MenuType>(
        value: value,
        tileColor: greyLight.withOpacity(0.3),
        groupValue: menuType,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        dense: true,
        contentPadding: EdgeInsets.all(0.0),
        title: Text(
          title,
          textAlign: TextAlign.start,
          style: body3,
        ),
        onChanged: onChanged);
  }
}

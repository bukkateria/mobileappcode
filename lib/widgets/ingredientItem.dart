import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget {
  IngredientItem({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check,
        color: green,
        size: 25,
      ),
      title: Text(
        '$text',
        style: body3,
      ),
      tileColor: Color(0xFFF5F5F5),
      dense: false,
    );
  }
}

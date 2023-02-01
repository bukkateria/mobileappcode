import 'package:bukateria/themes/colors.dart';
import 'package:bukateria/themes/text.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

enum DeliveryType { Pickup, Delivery }

class CustomDeliveryTypeRadio extends StatelessWidget {
  CustomDeliveryTypeRadio(
      {Key? key,
      this.deliveryType,
      required this.title,
      required this.value,
      this.onChanged})
      : super(key: key);

  String title;
  DeliveryType? value;
  DeliveryType? deliveryType;
  Function(DeliveryType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<DeliveryType>(
        value: value!,
        tileColor: greyLight.withOpacity(0.3),
        groupValue: deliveryType,
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

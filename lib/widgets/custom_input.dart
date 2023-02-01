import 'package:bukateria/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? helpText;
  final String? labelText;
  final TextStyle? labelStyle;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? isPassword;
  final bool? enabled;
  final bool? readOnly;
  final bool? filled;
  final Color borderColor;
  final Color? iconColor;
  final Color? color;
  final Color? bgcolor;
  final VoidCallback? onPress;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final VoidCallback? onEditingCompleted;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool? isMulti;
  final bool? autofocus;
  final String? errorText;
  final String? label;
  final Widget? suffix;
  final Widget? prefix;
  final double? height;
  final double? borderRadius;
  final int? maxLines;
  final focusNode;

  const CustomInput(
      {this.controller,
      this.prefix,
      this.suffix,
      this.onTap,
      this.onEditingCompleted,
      this.onChanged,
      this.hintText,
      this.isMulti,
      this.label,
      this.helpText,
      this.autofocus,
      this.errorText,
      this.labelText,
      this.validator,
      this.onPress,
      this.color,
      this.borderRadius,
      this.bgcolor,
      this.labelStyle,
      this.iconColor,
      this.prefixIcon,
      this.suffixIcon,
      this.isPassword,
      this.enabled,
      this.filled,
      this.maxLines,
      this.readOnly,
      this.borderColor = Colors.grey,
      this.keyboardType,
      this.height,
        this.focusNode,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextFormField(
        style: TextStyle(color: color),
        keyboardType: keyboardType,
        validator: validator,
        controller: controller,
        onChanged: onChanged,
        focusNode: focusNode,
        maxLines: maxLines ?? 1,

        readOnly: null == readOnly ? false : true,
        obscureText: null == isPassword ? false : true,
        decoration: InputDecoration(
          filled: filled,
          fillColor: bgcolor,
          errorText: errorText,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(borderRadius!)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(borderRadius!)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: primary, width: 1),
          ),
          hintText: hintText ?? '',
          helperText: helpText ?? '',
          labelText: labelText ?? '',
          labelStyle: labelStyle,
          prefixIcon:
              null == prefixIcon ? null : Icon(prefixIcon, color: iconColor),
          suffixIcon: null == suffixIcon
              ? null
              : IconButton(
                  onPressed: onPress, icon: Icon(suffixIcon, color: iconColor)),
          enabled: null == enabled ? true : false,
        ),
      ),
    );
  }
}

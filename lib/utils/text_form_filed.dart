import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/enums/validation.dart';
import 'package:flutter_todo_app/widgets/commons/validations.dart';

import 'app.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget(
      {Key? key,
        required this.controller,
        this.hint,
        this.isEnabled = true,
        this.formatter,
        this.inputAction = TextInputAction.next,
        this.inputType = TextInputType.text,
        this.validationType = Validations.requiredFieldValidator,
        this.isLabelFloating = true,
        this.hasBorder = false,
        this.needSpace = true,
        this.obscure = false,
        this.maxLengthEnforced = false,
        this.prefixIcon,
        this.suffixIcon,
        this.onTap})
      : super(key: key);

  final TextEditingController controller;
  final String? hint;
  final bool isEnabled;
  final List<TextInputFormatter>? formatter;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isLabelFloating;
  final bool hasBorder;
  final bool needSpace;
  final Validations validationType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool maxLengthEnforced;
  final bool obscure;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: needSpace ? TextStyle(
          fontSize: App.textTheme.subtitle1!.fontSize,
          color: isEnabled ? customColor.labelColor : Colors.grey) :
      TextStyle(
          // fontSize: App.textTheme.caption!.fontSize,
          fontSize: 30,
          color: isEnabled ? customColor.black : customColor.labelColor),
      decoration: InputDecoration(
          labelText: isLabelFloating ? hint : null,
          hintText: !isLabelFloating ? hint : '',
          hintStyle: TextStyle(color: customColor.labelColor),
          enabled: isEnabled,
          contentPadding: (prefixIcon == null)
              ? EdgeInsets.symmetric(horizontal: App.width * 0.03)
              : null,
          enabledBorder: hasBorder
              ? OutlineInputBorder(
              borderSide: BorderSide(
                  color:
                  isEnabled ? CustomColors().black : Colors.grey))
              : null,
          border: hasBorder
              ? OutlineInputBorder(
              borderSide: BorderSide(color: customColor.lightGray))
              : null,
          prefixIcon: (prefixIcon == null) ? null : prefixIcon,
          suffixIcon: (suffixIcon == null) ? null : suffixIcon),
      inputFormatters: formatter,
      keyboardType: inputType,
      maxLines: maxLengthEnforced ? 2 : 1,
      // ignore: deprecated_member_use
      maxLengthEnforced: maxLengthEnforced,
      textInputAction: inputAction,
      onTap: onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: onTap == null ? false : true,
      validator: (value) {
        var resultValidate =
        validation.validateTextFormField(value!, validationType);
        if (resultValidate != null) {
          return resultValidate;
        }
        return null;
      },
    );
  }
}



import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/enums/validation.dart';
import 'package:flutter_todo_app/enums/work_type.dart';

final validation = ValidationExt();

class ValidationExt extends StringConstraints {
  dynamic validateTextFormField(String value, Validations validationType) {
    switch (validationType) {
      case Validations.optional:
        return null;
      case Validations.requiredFieldValidator:
        return requiredFieldValidation(value);
      case Validations.mobile:
        return mobileNumberValidation(value);
      default:
        return null;
    }
  }
  dynamic validateTaskType(WorkType workType){
    switch(workType){
      case WorkType.personal:
        return strings.personal;
      case WorkType.work:
        return strings.work;
      case WorkType.meeting:
        return strings.meeting;
      case WorkType.shopping:
        return strings.shopping;
      default:
        return null;
    }
  }

  String? emailFieldValidation(value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (requiredFieldValidation(value) == null) {
      if (regex.hasMatch(value)) {
        return null;
      } else {
        return emailFieldErrorMessage;
      }
    } else {
      return requiredFieldErrorMessage;
    }
  }

  String? passwordFieldValidation(value) {
    String pattern =
    r'^(?=.*[^a-zA-Z])(?=.*[a-z])(?=.*[A-Z])\S{8,}$';
    RegExp regex = RegExp(pattern);
    if (requiredFieldValidation(value) == null) {
      if (regex.hasMatch(value)) {
        return null;
      } else {
        return passwordFieldErrorMessage;
      }
    } else {
      return requiredFieldErrorMessage;
    }
  }


  String? mobileNumberValidation(value) {
    String pattern = r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value)) {
      return mobileFieldErrorMessage;
    } else {
      return null;
    }
  }

  String? requiredFieldValidation(value) {
    if (value.isEmpty) {
      return requiredFieldErrorMessage;
    } else {
      return null;
    }
  }
}

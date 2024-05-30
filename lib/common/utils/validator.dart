import 'package:flutter/cupertino.dart';

class Validator {
  static String? validateName(String? s) {
    if (s == null || s.isEmpty) {
      return "* Required";
    }
    if (!RegExp(r"^[a-zA-Z]+(?:[-'’][a-zA-Z]+)*$").hasMatch(s)) {
      return "First name may only contain ascii letters and -, ' and ’ characters";
    }
    return null;
  }

  static String? validateEmail(String? s) {
    if (s == null || s.isEmpty) {
      return "* Required";
    }
    bool emailValid = RegExp(r"^\S+@\S+\.\S+$").hasMatch(s);
    if (!emailValid) {
      return "This email address is not valid";
    }
    return null;
  }

  static String? validatePass(String? s) {
    if (s == null || s.isEmpty) {
      return "* Required";
    }
    const String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])((?=.*?[\^$*.\[\]{}()?"!@#%&/\\,><:;|_~`=+-])|'
        r"(?=.*?['])).{8,64}$";
    RegExp passwordRegex = RegExp(pattern);
    if (!passwordRegex.hasMatch(s)) {
      return "Password must contain at least one: special character, digit and big letter";
    } else {
      return null;
    }
  }

  static String? validateDeviceName(String? s) {
    RegExp whiteSpacesRegex = RegExp(r'^\s*$');
    if (s == null || s.isEmpty || whiteSpacesRegex.hasMatch(s)) {
      return "* Required";
    }
    RegExp deviceNameRegex = RegExp(
        r'^[a-zA-Z0-9ÈÉÊËÙÚÛÜÎÌÍÏÒÓÔÖÂÀÁÄẞÇèéêëùúûüîìíïòóôöâàáäsßç\s._-]+$');
    if (!deviceNameRegex.hasMatch(s)) {
      return "Device Name contains forbidden characters";
    } else {
      return null;
    }
  }

  static String? validateConfirmPass(
      String? s, String? s1) {
    String? message = validatePass(s);
    if (message != null) {
      return message;
    }
    if (s != s1) {
      return "Passwords no not match";
    }
    return null;
  }

  static String? validateBatterySerialNumber(String? s) {
    if (s == null || s.isEmpty) {
      return "* Required";
    }
    return null;
  }
}

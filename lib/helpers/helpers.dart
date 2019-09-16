import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class Helpers {
  static bool enableDebug = true;

  static showMessage(String message) {
    Fluttertoast.showToast(
        msg: '$message',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        fontSize: 14.0);
  }
}

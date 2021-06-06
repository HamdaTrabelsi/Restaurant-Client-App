import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SuccessFlush {
  static void showSuccessFlush({BuildContext context, String message}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      title: "Success",
      message: message,
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    )..show(context).whenComplete(() {});
  }
}

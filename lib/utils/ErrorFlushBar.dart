import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ErrorFlush {
  static void showErrorFlush({BuildContext context, String message}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      title: "Error",
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}

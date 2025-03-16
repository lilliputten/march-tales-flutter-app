import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

// XXX FUTURE: Use snack bar:
// ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tap')))

showErrorToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    // gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 5,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    // fontSize: 16.0
  );
}

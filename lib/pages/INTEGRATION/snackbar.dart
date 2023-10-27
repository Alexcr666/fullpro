import 'package:flutter/material.dart';

class CustomSnackbar {
  static snackbar(
      String text,
      //GlobalKey<ScaffoldState> _scaffoldKey,
      BuildContext context) {
    final snackBar = SnackBar(
      content: Text('$text '),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

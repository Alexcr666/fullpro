import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/pages/Authentication/loginpage.dart';

class AppUtils {
  noNull(String value) {
    if (value == null || value.toString() == "null") {
      return "";
    } else {
      return value;
    }
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
}

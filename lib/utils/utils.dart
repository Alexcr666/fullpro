import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/pages/Authentication/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty == true || this == null) {
      return "";
    } else {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
  }
}

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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("professional").then((value) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
    });
  }
}

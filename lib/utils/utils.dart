import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/pages/Authentication/loginpage.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/widgets/widget.dart';
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
  Widget getInternet(BuildContext context) {
    return FutureBuilder(
        future: AppUtils().checkInternet(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return snapshot.data ? AppWidget().loadingOther() : AppWidget().noInternet();
          } else {
            return AppWidget().loadingOther();
          }
        });
  }

  noNull(String value) {
    if (value == null || value.toString() == "null") {
      return "";
    } else {
      return value;
    }
  }

  Future checkInternet(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      AppWidget().itemMessage("No hay conexión a internet", context);
      return false;
    }
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    executeClear() {
      prefs.remove("professional").then((value) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      });
    }

    if (userDataProfile != null) {
      userDataProfile!.ref.update({"tokenNotification": ""}).then((value) {
        executeClear();
      });
    }

    if (userInfoPartners != null) {
      userInfoPartners!.ref.update({"tokenNotification": ""}).then((value) {
        executeClear();
      });
    }
  }
}

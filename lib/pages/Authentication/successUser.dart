// ignore_for_file: prefer_const_constructors

import 'package:calender_picker/extra/color.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:fullpro/controller/loader.dart';

import 'package:fullpro/pages/Authentication/registerationpage.dart';

import 'package:fullpro/pages/Authentication/register.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/homepage.dart';

import 'package:fullpro/styles/statics.dart' as Static;

import 'package:fullpro/utils/permissions.dart';

import 'package:fullpro/utils/userpreferences.dart';

import 'package:fullpro/widgets/progressDialog.dart';

import 'package:fullpro/widgets/widget.dart';

class successUserPage extends StatefulWidget {
  const successUserPage({Key? key}) : super(key: key);

  static const String id = 'login';

  @override
  State<successUserPage> createState() => _successUserPageState();
}

class _successUserPageState extends State<successUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  set errorMessage(String errorMessage) {}

  void login() async {
    try {
      final User = (await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          status: Locales.string(context, 'lbl_logining_in'),
        ),
      );

      if (User != null) {
        DatabaseReference UserRef = FirebaseDatabase.instance.ref().child('users/${User.uid}');

        UserRef.once().then((event) {
          final dataSnapshot = event.snapshot;

          if (dataSnapshot.value != null) {
            UserPreferences.setUserEmail(emailController.text);

            Navigator.pushNamedAndRemoveUntil(context, kHomePage.id, (route) => false);
          }
        });
      }
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case "wrong-password":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, 'error_incorrect_email_or_password'))));

          break;

        case "user-not-found":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, 'error_email_does_not_match_record'))));

          break;

        default:
          print(ex.code);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    locationPermision();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),

                //  AppWidget().back(context),

                SizedBox(
                  height: 40,
                ),

                //

                //

                Image(
                  image: AssetImage("images/logo.png"),
                  alignment: Alignment.center,
                  height: 100,
                ),

                SizedBox(
                  height: 35,
                ),

                //

                //

                SizedBox(
                  height: 40,
                ),

                /*  Container(

                    width: 200,

                    child: CircleAvatar(

                      backgroundColor: Colors.grey,

                    )),
*/

                SizedBox(
                  height: 20,
                ),

                Text(
                  "su registro fue exitoso",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondryColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 200,
                ),

                AppWidget().buttonForm(context, "Finalizar", tap: () {
                  Navigator.pushNamedAndRemoveUntil(context, kHomePage.id, (route) => false);
                }),

                //

                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}

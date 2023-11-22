// ignore_for_file: prefer_const_constructors

import 'package:calender_picker/extra/color.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/Authentication/recoverPassword/recoverPassword.dart';
import 'package:fullpro/pages/Authentication/registerationpage.dart';
import 'package:fullpro/pages/Authentication/register.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/utils/permissions.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/progressDialog.dart';
import 'package:fullpro/widgets/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String id = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  height: 40,
                ),
                //
                //
                Image(
                  image: AssetImage("images/logo.png"),
                  alignment: Alignment.center,
                  height: 90,
                ),
                SizedBox(
                  height: 35,
                ),
                //
                //
                Text(
                  "Welcome back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondryColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 1,
                ),
                Text(
                  "please Login!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 70,
                ),

                //
                //    EMAIL ADDRESS ( TEXT FIELD )
                //
                Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 17, bottom: 17, left: 15),
                      //   filled: true,
                      // fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: BorderSide(color: secondryColor, width: 1.0),
                          borderRadius: BorderRadius.circular(11)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),
                      labelText: Locales.string(context, 'lbl_email'),
                      labelStyle: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                //
                //
                SizedBox(
                  height: 10,
                ),
                //

                Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 17, bottom: 17, left: 15),
                      //     fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: BorderSide(color: secondryColor, width: 1.0),
                          borderRadius: BorderRadius.circular(11)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(12)),
                      labelText: Locales.string(context, 'lbl_password'),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                //
                SizedBox(
                  height: 20,
                ),

                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(top: 10, bottom: 0),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
                      // Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                    },
                    child: Text(
                      "Forgot your password",
                      style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                //
                //
                Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_no_internet'),
                              ),
                            ),
                          );
                          return;
                        }
                        //
                        if (!emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_enter_valid_email'),
                              ),
                            ),
                          );
                          return;
                        }
                        if (passwordController.text.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_enter_strong_password'),
                              ),
                            ),
                          );
                          return;
                        }

                        login();
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Static.themeColor[500]!),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          Locales.string(context, 'lbl_login_now'),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                //
                SizedBox(
                  height: 10,
                ),
                //
                //
                SizedBox(
                  height: 10,
                ),

                AppWidget().redSocial(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

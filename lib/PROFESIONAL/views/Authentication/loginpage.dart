// ignore_for_file: prefer_const_constructors

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/utils/permissions.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/register.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/registerationpage.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/PROFESIONAL/widget/progressDialog.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/widgets/widget.dart';

class LoginPageProfesional extends StatefulWidget {
  const LoginPageProfesional({Key? key}) : super(key: key);

  static const String id = 'login';

  @override
  State<LoginPageProfesional> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageProfesional> {
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
            Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
          }
        });
        // UserPreferences.setUserEmail(emailController.text);
        // Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
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
                  height: 65,
                ),
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

                //    EMAIL ADDRESS ( TEXT FIELD )
                //
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        AppWidget().texfieldFormat(title: Locales.string(context, 'lbl_email'), controller: emailController),

                        SizedBox(
                          height: 10,
                        ),
                        //

                        AppWidget().texfieldFormat(title: "Password", controller: passwordController),
                      ],
                    )),

                /* Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                      labelText: Locales.string(context, 'lbl_email'),
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),*/
                //
                //

                /*  Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                      labelText: /*Locales.string(context, 'lbl_password')*/ "Password",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),*/
                //
                SizedBox(
                  height: 50,
                ),
                //
                //
                Padding(
                  padding: EdgeInsets.only(
                    right: 50,
                    left: 50,
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
                          style: TextStyle(fontSize: 16),
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
                  height: 50.0,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationPage()),
                      );
                      //  Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                    },
                    child: Text(Locales.string(context, 'lbl_dont_have_account_signup_here')),
                  ),
                ),
                //
                //
                /*   Padding(
                  padding: EdgeInsets.only(
                    right: 50,
                    left: 50,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Loader.page(context, Register());
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Static.colorAccent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          Locales.string(context, 'lbl_login_with_phone'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
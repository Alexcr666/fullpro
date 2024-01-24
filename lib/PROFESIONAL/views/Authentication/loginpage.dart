// ignore_for_file: prefer_const_constructors

import 'dart:developer';

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
import 'package:fullpro/pages/Authentication/recoverPassword/recoverPassword.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/styles/styles.dart';
import 'package:fullpro/utils/userpreferences.dart';
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

  void login(BuildContext context) async {
    AppWidget().showAlertDialogLoading(context);
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
        DatabaseReference UserRef = FirebaseDatabase.instance.ref().child('partners/' + FirebaseAuth.instance.currentUser!.uid.toString());

        UserRef.once().then((event) {
          final dataSnapshot = event.snapshot;

          if (dataSnapshot.value != null) {
            Navigator.pop(context);
            if (event.snapshot.child("state").value != null) {
              if (int.parse(event.snapshot.child("stateUser").value.toString()) == 1) {
                AppSharedPreference().setProfessional(context).then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                });
              } else {
                Navigator.pop(context);
                int state = int.parse(event.snapshot.child("stateUser").value.toString());
                if (state == 0) {
                  AppWidget().itemMessage("Usuario Pendiente", context);
                } else {
                  if (state == 2) {
                    AppWidget().itemMessage("Usuario bloqueado", context);
                  } else {
                    if (state == 3) {
                      AppWidget().itemMessage("Suspendido", context);
                    } else {
                      AppWidget().itemMessage("Suspendido", context);
                    }
                  }
                }
              }
            } else {
              AppWidget().itemMessage("Suspendido", context);
            }
          } else {
            AppWidget().itemMessage("Usuario rol cliente", context);
          }
        });
        // UserPreferences.setUserEmail(emailController.text);
        // Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
      } else {
        log("error al iniciar sessión");
        AppWidget().itemMessage("Error al iniciar sessión2", context);
      }
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case "wrong-password":
          AppWidget().itemMessage("Contraseña incorrecta", context);
          break;
        case "user-not-found":
          AppWidget().itemMessage("Usuario no existe", context);
          break;
        default:
          AppWidget().itemMessage("Ha ocurrido un error", context);
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
                AppWidget().back(context),
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
                Text("Welcome back", textAlign: TextAlign.center, style: AppStyle().boldText(20)),

                SizedBox(
                  height: 1,
                ),
                Text(
                  "please Login!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
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

                        AppWidget().texfieldFormat(title: "Password", controller: passwordController, password: true),
                      ],
                    )),

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
                  height: 20,
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

                        login(context);
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
                /* SizedBox(
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
                ),*/

                AppWidget().redSocialProfessional(context, false),
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

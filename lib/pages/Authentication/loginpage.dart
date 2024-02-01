// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:calender_picker/extra/color.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/Authentication/recoverPassword/recoverPassword.dart';
import 'package:fullpro/pages/Authentication/registerationpage.dart';
import 'package:fullpro/pages/Authentication/register.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/styles/styles.dart';
import 'package:fullpro/utils/permissions.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/progressDialog.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String id = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
void login(BuildContext context, String? emailText, String? passwordText) async {
  AppWidget().showAlertDialogLoading(context);
  final User;
  try {
    if (emailText == null) {
      User = (await _auth.signInWithEmailAndPassword(
        email: emailText.toString(),
        password: passwordText.toString(),
      ))
          .user;
    } else {
      User = (await _auth.signInWithEmailAndPassword(
        email: emailText.toString(),
        password: passwordText.toString(),
      ))
          .user;
    }

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
        if (event.snapshot.exists) {
          final dataSnapshot = event.snapshot;

          if (dataSnapshot.value != null && event.snapshot.child("fullname").value != null) {
            print("datosprofessional: " + event.snapshot.child("fullname").value.toString());
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
              Navigator.pop(context);
              AppWidget().itemMessage("Suspendido", context);
            }
          } else {
            loginUser(User, context, emailText!, passwordText!);
            AppWidget().itemMessage("Usuario rol cliente", context);
          }
        } else {
          loginUser(User, context, emailText!, passwordText!);
          AppWidget().itemMessage("Usuario rol cliente", context);
        }
      });
      // UserPreferences.setUserEmail(emailController.text);
      // Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
    } else {
      // log("error al iniciar sessión");
      AppWidget().itemMessage("Error al iniciar sessión2", context);
    }
  } on FirebaseAuthException catch (ex) {
    Navigator.pop(context);
    switch (ex.code) {
      case "wrong-password":
        AppWidget().itemMessage(Locales.string(context, 'lbl_password_incorrect'), context);
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

void loginUser(var User, BuildContext context, String email, String password) async {
  AppWidget().showAlertDialogLoading(context);
  /*  try {
      final User = (await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;*/

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
      Navigator.pop(context);
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Navigator.pop(context);
        if (dataSnapshot.child("stateUser").value.toString() == "1") {
          UserPreferences.setUserEmail(email);
          AppSharedPreference().setUser(context, email);
          Navigator.pushNamedAndRemoveUntil(context, kHomePage.id, (route) => false);
        } else {
          AppWidget().itemMessage("Usuario bloqueado", context);
        }

        //kkk
      } else {
        Navigator.pop(context);
        AppWidget().itemMessage("Usuario rol professional", context);
      }
    });
  } else {
    AppWidget().itemMessage("Error al iniciar sesión", context);
  }
  /*} on FirebaseAuthException catch (ex) {
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
    }*/
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  set errorMessage(String errorMessage) {}

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
          child: Form(
            key: _formKey,
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
                Text(Locales.string(context, 'lbl_welcome'), textAlign: TextAlign.center, style: AppStyle().boldText(20)),

                SizedBox(
                  height: 1,
                ),

                Text(Locales.string(context, "lbl_create_free_account")),
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
                  child: AppWidget().texfieldFormat(title: Locales.string(context, 'lang_email'), controller: emailController),
                ),
                //
                //
                SizedBox(
                  height: 10,
                ),
                //

                Container(
                    margin: EdgeInsets.only(left: 19, right: 19),
                    child: AppWidget()
                        .texfieldFormat(controller: passwordController, title: Locales.string(context, 'lbl_password'), password: true)),

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
                    },
                    child: Text(
                      Locales.string(context, 'lang_recoverpassword'),
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
                        _formKey.currentState!.validate();
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

                        if (_formKey.currentState!.validate()) {
                          login(context, emailController.text, passwordController.text);
                        }
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

                AppWidget().redSocialProfessional(context, false),

                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

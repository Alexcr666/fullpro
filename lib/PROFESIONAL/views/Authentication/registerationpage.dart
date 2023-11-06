// ignore_for_file: prefer_const_constructors
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/utils/permissions.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/DatabaseEntry.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/loginpage.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/register.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/PROFESIONAL/widget/progressDialog.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/widgets/widget.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'RegistrationPage';

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool agree = false;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  set errorMessage(String errorMessage) {}

  void registerUser() async {
    try {
      final User = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;

      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          status: Locales.string(context, "lbl_getting_ready"),
        ),
      );

      // check if user registration is successful
      if (User != null) {
        DatabaseReference phoneRef = FirebaseDatabase.instance.ref().child('partners/${User.uid}');

        phoneRef.once().then((e) async {
          final snapshot = e.snapshot;
          if (snapshot.exists) {
            return;
          } else {
            Map userMap = {
              'fullname': 'Provider',
              'phone': phoneController.text,
              'earnings': "0",
            };
            phoneRef.set(userMap);
          }
        }).catchError((onError) {
          print("error" + onError.toString());
        });

        UserPreferences.setUserPhone(phoneController.text);
        UserPreferences.setUsername(fullNameController.text);

        DatabaseReference nameRef = FirebaseDatabase.instance.ref().child('partners/${User.uid}').child('fullname');

        nameRef.once().then((e) async {
          final snapshot = e.snapshot;
          if (snapshot.exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DatabaseEntry(
                  phone: phoneController.text,
                  userid: User.uid,
                ),
              ),
            );
            /*   Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DatabaseEntry(
                  phone: phoneController.text,
                  userid: User.uid,
                ),
              ),
            );*/
          }
        }).catchError((onError) {
          print("error" + onError.toString());
        });
        ;

        //  Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
      }
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case "email-already-in-use":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, "error_email_already_in_use"))));
          break;
        default:
          errorMessage = Locales.string(context, 'error_undefined');
      }
    }
  }

  ///   LOCATION PERMISSION

  @override
  void initState() {
    super.initState();
    locationPermision();
  }

  Widget signUp2() {
    return Column(
      children: [
        AppWidget().texfieldFormat(title: "Profesión"),
        Row(
          children: [
            Flexible(child: AppWidget().texfieldFormat(title: "Profesión")),
            Flexible(child: AppWidget().texfieldFormat(title: "Profesión")),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                //
                //
                Image(
                  image: AssetImage("images/logo.png"),
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 200.0,
                ),
                SizedBox(
                  height: 15,
                ),
                //
                //
                Row(
                  children: [
                    Expanded(child: SizedBox()),
                    SvgPicture.asset(
                      "images/icons/profileCircle.svg",
                      width: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Registro Profesional",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondryColor),
                        ),
                        Text(
                          "Datos personales",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: secondryColor),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),

                //
                // Full Name
                SizedBox(
                  height: 30,
                ),
                AppWidget().texfieldFormat(title: "Nombre completo", controller: fullNameController, urlIcon: "images/icons/user.svg"),
                /*  Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: fullNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                      labelText: Locales.string(context, 'lbl_fullname'),
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

                //
                //  Phone Number TEXT FIELD
                //
                SizedBox(
                  height: 10,
                ),
                AppWidget()
                    .texfieldFormat(title: "Fecha de nacimiento", controller: fullNameController, urlIcon: "images/icons/calendar.svg"),
                SizedBox(
                  height: 10,
                ),
                AppWidget().texfieldFormat(title: "Correo electronico", controller: emailController, urlIcon: "images/icons/email.svg"),
                SizedBox(
                  height: 10,
                ),
                AppWidget().texfieldFormat(title: "Celular", controller: phoneController, urlIcon: "images/icons/email.svg"),
                /* Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                      labelText: Locales.string(context, 'lbl_phone_number'),
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
                SizedBox(
                  height: 10,
                ),
                //
                //  Email Address TEXT FIELD
                //
                /*Padding(
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
                ),
                //
                //
                SizedBox(
                  height: 15,
                ),*/
                //
                //  Password

                AppWidget().texfieldFormat(title: "Password", controller: passwordController),
                /* Padding(
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
                      labelText: /*Locales.string(context, 'lbl_passowrd')*/ "Password",
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
                SizedBox(height: 15),

                //
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Material(
                        child: Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value ?? false;
                            });
                          },
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: Locales.string(context, 'lbl_i_have_read_terms'),
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: /* Locales.string(context, 'lbl_terms_and_conditions')*/ "  Terms and conditions",
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Loader.page(context, TermsPage());
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                //    Register Button
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

                        if (fullNameController.text.length < 3) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_enter_valid_name'),
                              ),
                            ),
                          );
                          return;
                        }
                        if (phoneController.text.length < 10 || phoneController.text.length > 14) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_enter_valid_phone'),
                              ),
                            ),
                          );
                          return;
                        }
                        if (!emailController.text.contains('@') || !emailController.text.contains('.')) {
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
                        registerUser();
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
                          Locales.string(context, 'lbl_register'),
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
                  height: 30.0,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pushNamedAndRemoveUntil(context, LoginPageProfesional.id, (route) => false);
                    },
                    child: Text(Locales.string(context, 'lbl_already_have_account')),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                /*    Padding(
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
                          Locales.string(context, 'lbl_register_with_phone'),
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

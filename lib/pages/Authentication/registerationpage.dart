// ignore_for_file: prefer_const_constructors
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullpro/utils/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/pages/Authentication/loginpage.dart';
import 'package:fullpro/pages/Authentication/register.dart';
import 'package:fullpro/pages/Authentication/successUser.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/pages/terms.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/styles/styles.dart';
import 'package:fullpro/utils/permissions.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/progressDialog.dart';
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

  void registerUser(BuildContext context, {bool? google}) async {
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
        DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('users/${User.uid}');
        // Prepare data to be saved on users table
        Map userMap = {
          'fullname': fullNameController.text.toString(),
          'email': emailController.text.toString(),
          'phone': phoneController.text.toString(),
          'google': google == null ? false : true,
          //  'dateUser': "",
          //'date': DateTime.now(),
          'stateUser': 1,
        };

        UserPreferences.setUserPhone(phoneController.text);
        UserPreferences.setUsername(fullNameController.text);

        newUserRef.set(userMap).then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const successUserPage()),
          );
        }).catchError((onError) {
          print("erroruser: " + onError.toString());
          AppWidget().itemMessage("Error al crear el usuario", context);
        });
      } else {
        AppWidget().itemMessage("Usuario ya existe", context);
      }
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case "email-already-in-use":
          AppWidget().itemMessage(Locales.string(context, "lang_exist_email"), context);
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    AppWidget().back(context),
                    SizedBox(
                      height: 40,
                    ),
                    //
                    //
                    Image(
                      image: AssetImage("images/logo.png"),
                      alignment: Alignment.center,
                      height: 70.0,
                    ),
                    SizedBox(
                      height: 45,
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
                              "Registro Cliente",
                              textAlign: TextAlign.center,
                              style: AppStyle().boldText(18),
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

                    SizedBox(
                      height: 50,
                    ),
                    //
                    // Full Name

                    AppWidget().texfieldFormat(
                        controller: fullNameController, title: Locales.string(context, 'lbl_fullname'), urlIcon: "images/icons/user.svg"),
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
                    SizedBox(
                      height: 15,
                    ),
                    //
                    //  Phone Number TEXT FIELD
                    //

                    AppWidget().texfieldFormat(
                        controller: phoneController,
                        title: Locales.string(context, 'lbl_phone_number'),
                        urlIcon: "images/icons/phone.svg",
                        number: true),

                    //
                    //
                    SizedBox(
                      height: 15,
                    ),
                    //
                    //  Email Address TEXT FIELD
                    //

                    AppWidget().texfieldFormat(
                        controller: emailController, title: Locales.string(context, 'lbl_email'), urlIcon: "images/icons/message.svg"),

                    SizedBox(
                      height: 15,
                    ),
                    //
                    //  Password

                    AppWidget().texfieldFormat(
                        controller: passwordController,
                        title: Locales.string(context, 'lbl_password'),
                        urlIcon: "images/icons/password.svg",
                        password: true),

                    SizedBox(height: 25),

                    //
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Material(
                            child: Checkbox(
                              activeColor: secondryColor,
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
                                  text: ' ${Locales.string(context, 'lbl_terms_and_conditions')}',
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TermsPage(
                                                    state: 2,
                                                  )));
                                    },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    //    Register Button
                    /*  Padding(
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
                ),*/

                    GestureDetector(
                        onTap: () {
                          GoogleSignInAccount? _currentUser;
                          const List<String> scopes = <String>[
                            'email',
                            'profile',
                            // 'birthday',
                            'https://www.googleapis.com/auth/userinfo.email',
                            'https://www.googleapis.com/auth/user.phonenumbers.read',
                            'https://www.googleapis.com/auth/userinfo.profile',
                            'https://www.googleapis.com/auth/user.birthday.read',
                            'https://www.googleapis.com/auth/user.addresses.read',
                            'https://www.googleapis.com/auth/user.gender.read',
                            'https://www.googleapis.com/auth/contacts.readonly',
                          ];
                          GoogleSignIn _googleSignIn = GoogleSignIn(
                            // Optional clientId

                            // clientId: 'your-client_id.apps.googleusercontent.com',

                            scopes: scopes,
                          );
                          _googleSignIn.signIn().then((value) {
                            fullNameController.text = value!.displayName.toString();
                            emailController.text = value!.email.toString();
                            //   dateController.text = "23/24";
                            phoneController.text = "";
                            passwordController.text = value!.email.toString();

                            setState(() {});
                            registerUser(context, google: true);

                            /* getGender2() async {
                              final headers = await _googleSignIn.currentUser!.authHeaders;
                              final r = await http.get(
                                Uri.parse(
                                    "https://people.googleapis.com/v1/people/me?personFields=phoneNumbers,emailAddresses,names,addresses"),
                                /* headers: {
        "Authorization": headers["Authorization"]
      }*/
                                headers: headers,
                              );

                              log("datos: " + r.body.toString());

                              /// final response = JSON.jsonDecode(r.body);
                              //return response["genders"][0]["formattedValue"];
                            }

                            getGender2();*/
                          }).catchError((onError) {});
                        },
                        child: Image.asset(
                          "images/google.png",
                          width: 50,
                          height: 50,
                        )),
                    SizedBox(
                      height: 10,
                    ),

                    AppWidget().buttonForm(context, Locales.string(context, 'lbl_register'), tap: () async {
                      /*  var connectivityResult = await (Connectivity().checkConnectivity());
                  if (connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          Locales.string(context, 'error_no_internet'),
                        ),
                      ),
                    );
                    return;
                  }*/
                      _formKey.currentState!.validate();

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
                      if (_formKey.currentState!.validate()) {
                        if (await AppUtils().checkInternet(context)) {
                          registerUser(context, google: false);
                        }
                      } else {
                        AppWidget().itemMessage("Falta campos", context);
                      }
                    }),
                    //
                    //
                    SizedBox(
                      height: 10,
                    ),
                    //
                    //
                    /*SizedBox(
                      height: 50.0,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                        },
                        child: Text(Locales.string(context, 'lbl_already_have_account')),
                      ),
                    ),*/
                    //
                    //
                    SizedBox(
                      height: 10,
                    ),

                    // AppWidget().redSocial(context, true),
                    //
                    //
                    /* Padding(
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
                          Locales.string(context, 'lbl_register_with_phone'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),*/
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

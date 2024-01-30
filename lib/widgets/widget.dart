import 'dart:io';

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';

import 'package:flutter_svg/svg.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:fullpro/PROFESIONAL/views/Authentication/loginpage.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/registerationpage.dart';

import 'package:fullpro/pages/Authentication/redsocial/google.dart';

import 'package:fullpro/pages/Authentication/registerationpage.dart';

import 'package:fullpro/styles/statics.dart' as Static;

import 'package:flutter_locales/flutter_locales.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppWidget {
  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Cargando",
            style: TextStyle(color: secondryColor, fontSize: 26),
          ),
          SizedBox(
            width: 30,
          ),
          Container(width: 30, height: 30, child: CircularProgressIndicator()),
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  redSocialProfessional(BuildContext context, bool active) {
    return Column(
      children: [
        active
            ? SizedBox()
            : SizedBox(
                height: 50.0,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    Locales.string(context, 'lang_createaccount_message'),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                title: new Text(Locales.string(context, 'lang_client')),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                                },
                              ),
                              ListTile(
                                title: new Text(Locales.string(context, 'lang_professional')),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationProfessionalPage()));
                                },
                              ),
                              ListTile(
                                title: new Text(Locales.string(context, 'lang_cancel')),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    Locales.string(context, 'lbl_create_free_account'),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: primaryColor,
          margin: EdgeInsets.only(left: 35, right: 35),
        ),
        SizedBox(
          height: 20,
        ),
        /* SizedBox(
          height: 50.0,
          width: double.infinity,
          child: TextButton(
            onPressed: () async {
              Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
            },
            child: Text(
              "Or continue with",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),*/
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
                onTap: () {
                  GoogleSignInAccount? _currentUser;
                  const List<String> scopes = <String>[
                    'email',
                    'https://www.googleapis.com/auth/contacts.readonly',
                  ];

                  GoogleSignIn _googleSignIn = GoogleSignIn(
                    // Optional clientId

                    // clientId: 'your-client_id.apps.googleusercontent.com',

                    scopes: scopes,
                  );

                  bool _isAuthorized = false; // has granted permissions?

                  String _contactText = '';

                  Future<void> _handleSignIn() async {
                    // try {
                    _googleSignIn.signIn().then((value) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('partners')
                          .orderByChild("email")
                          .equalTo(value!.email.toString())
                          .get()
                          .then((value) {})
                          .catchError((onError) {});

                      print("objecto: " + value!.email.toString());
                    }).catchError((onError) {});
                    //} catch (error) {
                    //   print("firebase: " + error.toString());
                    //  }
                  }

                  _handleSignIn();

                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInDemo()));
                  //  Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                },
                child: Image.asset(
                  "images/google.png",
                  width: 50,
                  height: 50,
                )),
            Platform.isIOS == false ? SizedBox() : Expanded(child: SizedBox()),
            Platform.isIOS == false
                ? SizedBox()
                : Image.asset(
                    "images/apple.png",
                    width: 50,
                    height: 50,
                  ),
            //  Expanded(child: SizedBox()),
            /* Image.asset(
              "images/facebook.png",
              width: 50,
              height: 50,
            ),*/
            SizedBox(
              width: 20,
            ),
            Expanded(child: SizedBox()),
          ],
        ),
        /* GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInDemo()));
            },
            child: Image.asset(
              "images/redsocial1.png",
              height: 45,
            )),*/
      ],
    );
  }

  optionsEnabled(String title, BuildContext context, {Function? tap, Function? tap2}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: new Text(Locales.string(context, 'lang_location')),
                onTap: () {
                  // Navigator.pop(context);

                  tap!();
                },
              ),
              ListTile(
                title: new Text(Locales.string(context, 'lang_cancel')),
                onTap: () {
                  Navigator.pop(context);

                  tap2;
                },
              ),
            ],
          );
        });
  }

  Widget circleProfile(String url, {double? size}) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: size ?? 70,
          height: size ?? 70,
          color: Colors.grey.withOpacity(0.4),
          child: CachedNetworkImage(
            width: 70,
            height: 70,
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(
              Icons.error,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ));
  }

  Widget loading() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(child: SizedBox()),
            Container(height: 34, width: 34, child: CircularProgressIndicator()),
            Expanded(child: SizedBox()),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  getFileSize(int bytes, int decimals) {
    //  var file = File(filepath);

    // int bytes = await file.length();

    if (bytes <= 0) return "0 B";

    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

    var i = (log(bytes) / log(1024)).floor();

    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  Widget noResult(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(child: SizedBox()),
            Text(
              Locales.string(context, 'lang_no_result'),
              style: TextStyle(color: secondryColor, fontSize: 20),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget noLocation() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Flexible(
                child: Text(
              "Para recibir ordenes debe seleccionar una ubicación",
              style: TextStyle(color: secondryColor, fontSize: 18),
              textAlign: TextAlign.center,
            )),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget titleAdd(String title, {Function? tap}) {
    return Row(
      children: [
        Container(
            child: Text(
          title.toString(),
          style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 20),
        )),
        Expanded(child: SizedBox()),
        GestureDetector(
            onTap: () {
              tap!();
            },
            child: Container(
                margin: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "Filtro",
                      style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      "images/icons/add.svg",
                      width: 30,
                      color: secondryColor,
                    ),
                  ],
                ))),
      ],
    );
  }

  Widget title(String title, {Function? tap}) {
    return Row(
      children: [
        Container(
            child: Text(
          title.toString(),
          style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 20),
        )),
      ],
    );
  }

  itemMessage(String title, BuildContext context) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: secondryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  borderColor() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),

      border: Border.all(color: secondryColor),

      //  color: secondryColor,
    );
  }

  Widget texfieldFormat({
    String? title,
    TextEditingController? controller,
    bool? password,
    bool? enabled,
    String? urlIcon,
    Color? colorBackground,
    bool? number,
    String? suffix,
    bool? noRequired,
    Function? execute,
    bool? float,
  }) {
    bool _passwordVisible = true;

    return StatefulBuilder(builder: (context, setState) {
      return Container(
          //color: Colors.white,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),

          // padding: EdgeInsets.symmetric(horizontal: 8),

          /*  decoration: BoxDecoration(
            border: Border.all(color: Color(0xffE8E8E8)),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),*/

          //    height: 34.sp,

          margin: EdgeInsets.only(top: 5),
          child: TextFormField(
            inputFormatters: number == null ? null : <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            enabled: enabled == true ? false : true,
            controller: controller,
            onChanged: (text) {
              execute!();
            },
            obscureText: password != true ? false : _passwordVisible,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 17, bottom: 17, left: 15),

              enabledBorder: OutlineInputBorder(

                  // width: 0.0 produces a thin "hairline" border

                  borderSide: BorderSide(color: secondryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(11)),

              border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),

              //  contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),

              labelText: title,

              fillColor: Colors.white,

              errorStyle: TextStyle(height: 0.3),

              prefixIconConstraints: BoxConstraints(maxHeight: 0),

              filled: true,

              labelStyle: TextStyle(color: secondryColor, fontSize: 14),

              //   border: InputBorder.none,

              /*  focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColors.green,
                ),
              ),*/

              suffixIcon: IconButton(
                icon: password == null
                    ? SvgPicture.asset(
                        urlIcon.toString(),
                        color: secondryColor,
                        width: 25,
                      )
                    : Icon(
                        // Based on passwordVisible state choose the icon

                        _passwordVisible == false ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,

                        color: Colors.grey,
                      ),
                onPressed: () {
                  _passwordVisible = !_passwordVisible;
                  password = !password!;
                  setState(() {});
                  // Update the state i.e. toogle the state of passwordVisible variable

                  // setState(() {

                  // _passwordVisible = !_passwordVisible;

                  //});
                },
              ),

              /*  focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColors.greyTextField2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColors.greyTextField2,
                ),
              ),*/
            ),
            validator: (val) {
              if (noRequired == true) {
                return null;
              } else {
                if (val!.length == 0) {
                  return "Campo obligatorio";
                } else {
                  return null;
                }
              }
            },
            keyboardType: float == true
                ? TextInputType.numberWithOptions(decimal: true)
                : number != null
                    ? TextInputType.number
                    : TextInputType.emailAddress,
          ));
    });
  }

  boxShandowGrey() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      boxShadow: [
        BoxShadow(
          color: secondryColor.withOpacity(0.1),

          spreadRadius: 3,

          blurRadius: 3,

          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  boxShandowGreyRectangule() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: secondryColor.withOpacity(0.1),

          spreadRadius: 3,

          blurRadius: 3,

          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  buttonShandowActive(String title, bool active, {Function? tap}) {
    return GestureDetector(
        onTap: () {
          tap!();
        },
        child: Container(
          height: 40,
          child: Center(
              child: Text(
            title,
            style: TextStyle(color: active ? Colors.white : secondryColor, fontSize: 13),
          )),
          decoration: active
              ? BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        secondryColor,
                      ],
                      begin: const FractionalOffset(0.0, 1.0),
                      end: const FractionalOffset(0.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                )
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: secondryColor.withOpacity(0.1),

                      spreadRadius: 3,

                      blurRadius: 3,

                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
        ));
  }

  buttonShandow(String title, {Function? tap, Color? color, Color? colorText}) {
    return GestureDetector(
        onTap: () {
          tap!();
        },
        child: Container(
          height: 40,
          child: Center(
              child: Text(
            title,
            style: TextStyle(color: colorText != null ? colorText : secondryColor, fontSize: 13),
          )),
          decoration: BoxDecoration(
            color: color != null ? color : Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),

                spreadRadius: 3,

                blurRadius: 3,

                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ));
  }

  buttonShandowRounded(String title, bool active, {Function? tap}) {
    return GestureDetector(
        onTap: () {
          tap!();
        },
        child: Container(
          height: 35,
          child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Center(
                  child: Text(
                title,
                style: TextStyle(color: active == false ? Colors.white : secondryColor, fontSize: 13),
              ))),
          decoration: BoxDecoration(
            color: active ? Colors.white : secondryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: secondryColor.withOpacity(0.1),

                spreadRadius: 3,

                blurRadius: 3,

                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ));
  }

  Widget back(BuildContext context, {Function? tap}) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        GestureDetector(
            onTap: () {
              if (tap == null) {
                Navigator.pop(context);
              } else {
                tap();
              }
            },
            child: SvgPicture.asset(
              "images/icons/back.svg",
              width: 30,
            )),
        Expanded(child: SizedBox()),
      ],
    );
  }

  redSocial(BuildContext context, bool active) {
    return Column(
      children: [
        active
            ? SizedBox()
            : SizedBox(
                height: 50.0,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    "¿Que tipo de cuenta desea crear?",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                title: new Text('Cliente'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                                },
                              ),
                              ListTile(
                                title: new Text('Professional'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationProfessionalPage()));
                                },
                              ),
                              ListTile(
                                title: new Text(Locales.string(context, 'lang_cancel')),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });

                    //   Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                  },
                  child: Text(
                    Locales.string(context, 'lbl_create_free_account'),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

        /* SizedBox(
          height: 50.0,
          width: double.infinity,
          child: TextButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPageProfesional()),
              );

              //    Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
            },
            child: Text(
              "Create new account profesional",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),*/
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: primaryColor,
          margin: EdgeInsets.only(left: 35, right: 35),
        ),
        SizedBox(
          height: 50.0,
          width: double.infinity,
          child: TextButton(
            onPressed: () async {
              Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
            },
            child: Text(
              Locales.string(context, 'lang_ocontinue'),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            SizedBox(
              width: 30,
            ),
            Image.asset(
              "images/google.png",
              width: 50,
              height: 50,
            ),
            Platform.isIOS == false ? SizedBox() : Expanded(child: SizedBox()),
            Platform.isIOS == false
                ? SizedBox()
                : Image.asset(
                    "images/apple.png",
                    width: 50,
                    height: 50,
                  ),
            Expanded(child: SizedBox()),
            Image.asset(
              "images/facebook.png",
              width: 50,
              height: 50,
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(child: SizedBox()),
          ],
        ),
        /* GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInDemo()));
            },
            child: Image.asset(
              "images/redsocial1.png",
              height: 45,
            )),*/
      ],
    );
  }

/*
  textFieldForm(BuildContext context, TextEditingController controller, String title) {

    return Padding(

      padding: EdgeInsets.only(

        right: 20,

        left: 20,

      ),

      child: TextField(

        controller: controller,

        keyboardType: TextInputType.emailAddress,

        decoration: InputDecoration(

          contentPadding: EdgeInsets.only(top: 17, bottom: 17, left: 15),

          enabledBorder:

              OutlineInputBorder(borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(11)),

          border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),

          labelText: title,

          labelStyle: TextStyle(fontSize: 12.0, color: Colors.black),

        ),

        style: TextStyle(

          fontSize: 14,

        ),

      ),

    );

  }*/

  buttonForm(BuildContext context, String title, {Function? tap}) {
    return Padding(
      padding: EdgeInsets.only(
        right: 20,
        left: 20,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            tap!();

            //
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
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  buttonFormColor(BuildContext context, String title, Color color, {Function? tap, Color? colorText}) {
    return Padding(
      padding: EdgeInsets.only(
        right: 6,
        left: 6,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            tap!();
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 13, color: colorText != null ? colorText : Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  buttonFormLine(BuildContext context, String title, bool active, {Function? tap, String? urlIcon}) {
    return Padding(
      padding: EdgeInsets.only(
        right: 0,
        left: 00,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            /* var connectivityResult = await (Connectivity().checkConnectivity());
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

            tap!();

            //
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(active ? Colors.white : secondryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              active == false
                  ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: secondryColor, width: 3)),
            ),
          ),
          child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: active == false ? Colors.white : secondryColor),
                  ),
                  urlIcon == null
                      ? SizedBox()
                      : SizedBox(
                          width: 15,
                        ),
                  urlIcon == null
                      ? SizedBox()
                      : SvgPicture.asset(
                          urlIcon,
                          width: 20,
                          height: 20,
                          color: active == false ? Colors.white : secondryColor,
                        ),
                ],
              )),
        ),
      ),
    );
  }

  buttonFormWhite(BuildContext context, String title, {Function? tap}) {
    return Padding(
      padding: EdgeInsets.only(
        right: 20,
        left: 20,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            tap!();

            //
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}

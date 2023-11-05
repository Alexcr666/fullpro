import 'dart:async';


import 'package:flutter/cupertino.dart';


import 'package:flutter/material.dart';


import 'package:flutter/services.dart';


import 'package:flutter_locales/flutter_locales.dart';

import 'package:fullpro/PROFESIONAL/views/Authentication/loginpage.dart';


import 'package:fullpro/pages/Authentication/country_picker.dart';


import 'package:fullpro/pages/Authentication/loginpage.dart';


import 'package:fullpro/pages/Authentication/otp.dart';


import 'package:fullpro/utils/permissions.dart';


import 'package:fullpro/styles/statics.dart' as Static;


class Register extends StatefulWidget {

  static const String id = 'otpregister';


  @override

  _RegisterState createState() => _RegisterState();

}


class _RegisterState extends State<Register> {

  final _contactEditingController = TextEditingController();


  var _dialCode = '';


  //Login click with contact number validation


  Future<void> clickOnLogin(BuildContext context) async {

    if (_contactEditingController.text.isEmpty) {

      showErrorDialog(context, Locales.string(context, 'error_contact_can_not_be_empty'));

    } else {

      final responseMessage = await Navigator.pushNamed(context, OtpPage.id, arguments: '$_dialCode${_contactEditingController.text}');


      if (responseMessage != null) {

        showErrorDialog(context, responseMessage as String);

      }

    }

  }


  //callback function of country picker


  void _callBackFunction(String name, String dialCode, String flag) {

    _dialCode = dialCode;

  }


  //Alert dialogue to show error and response


  void showErrorDialog(BuildContext context, String message) {

    // set up the AlertDialog


    final CupertinoAlertDialog alert = CupertinoAlertDialog(

      title: Text(Locales.string(context, 'lbl_error')),

      content: Text('\n$message'),

      actions: <Widget>[

        CupertinoDialogAction(

          isDefaultAction: true,

          child: Text(Locales.string(context, 'lbl_ok')),

          onPressed: () {

            Navigator.of(context).pop();

          },

        )

      ],

    );


    // show the dialog


    showDialog(

      context: context,

      builder: (BuildContext context) {

        return alert;

      },

    );

  }


  @override

  void initState() {

    // TODO: implement initState


    super.initState();


    locationPermision();

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.white,

      body: Center(

        child: SingleChildScrollView(

          physics: const AlwaysScrollableScrollPhysics(),

          child: Padding(

            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                const SizedBox(

                  height: 24,

                ),

                Text(

                  Locales.string(context, 'lbl_get_started'),

                  style: const TextStyle(

                    fontSize: 22,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                const SizedBox(

                  height: 10,

                ),

                Text(

                  Locales.string(context, 'lbl_enter_phone_number'),

                  style: const TextStyle(

                    fontSize: 14,

                    fontWeight: FontWeight.bold,

                    color: Colors.black38,

                  ),

                  textAlign: TextAlign.left,

                ),

                Container(

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(12),

                  ),

                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,

                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Container(

                        width: 320,


                        margin: const EdgeInsets.all(15),


                        padding: const EdgeInsets.symmetric(horizontal: 8.0),


                        height: 70,


                        decoration: BoxDecoration(

                          border: Border.all(

                            color: Colors.black12,

                          ),

                          borderRadius: BorderRadius.circular(10),

                        ),


                        //


                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.center,

                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [

                            CountryPicker(

                              callBackFunction: _callBackFunction,

                              headerText: Locales.string(context, 'lbl_select_country'),

                              headerBackgroundColor: Theme.of(context).primaryColor,

                              headerTextColor: Colors.white,

                            ),


                            // SizedBox(


                            //   width: MediaQuery.of(context).size.width * 0.01,


                            // ),


                            SizedBox(

                              width: 195,

                              height: 60,

                              child: Column(

                                mainAxisAlignment: MainAxisAlignment.center,

                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [

                                  TextFormField(

                                    inputFormatters: [LengthLimitingTextInputFormatter(10)],

                                    controller: _contactEditingController,

                                    keyboardType: TextInputType.number,

                                    style: const TextStyle(

                                      fontSize: 18,

                                      fontWeight: FontWeight.bold,

                                    ),

                                    decoration: const InputDecoration(

                                      border: InputBorder.none,

                                      prefix: Padding(

                                        padding: EdgeInsets.symmetric(horizontal: 8),

                                      ),

                                      suffixIcon: Icon(

                                        Icons.more_horiz,

                                        color: Colors.green,

                                        size: 32,

                                      ),

                                    ),

                                  ),

                                ],

                              ),

                            ),

                          ],

                        ),

                      ),

                      const SizedBox(

                        height: 22,

                      ),

                      SizedBox(

                        width: double.infinity,

                        child: ElevatedButton(

                          onPressed: () {

                            clickOnLogin(context);

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

                              '${Locales.string(context, 'lbl_continue')}',

                              style: const TextStyle(fontSize: 16),

                            ),

                          ),

                        ),

                      ),

                      SizedBox(

                        height: 10,

                      ),

                      SizedBox(

                        width: double.infinity,

                        child: ElevatedButton(

                          onPressed: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));

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

                              Locales.string(context, 'lbl_login_with_email'),

                              style: const TextStyle(fontSize: 16),

                            ),

                          ),

                        ),

                      ),

                      SizedBox(

                        width: double.infinity,

                        child: ElevatedButton(

                          onPressed: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPageProfesional()));

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

                              "Login profesional",

                              style: const TextStyle(fontSize: 16),

                            ),

                          ),

                        ),

                      ),

                      const SizedBox(

                        height: 10,

                      ),

                      Image.asset(

                        'images/logo.png',

                        width: 110,

                      )

                    ],

                  ),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}


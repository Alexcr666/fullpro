import 'package:connectivity_plus/connectivity_plus.dart';


import 'package:flutter/material.dart';


import 'package:flutter/widgets.dart';


import 'package:flutter_svg/svg.dart';


import 'package:fullpro/pages/Authentication/registerationpage.dart';


import 'package:fullpro/styles/statics.dart' as Static;


import 'package:flutter_locales/flutter_locales.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


class AppWidget {

  buttonShandow(String title) {

    return Container(

      height: 40,

      child: Center(

          child: Text(

        title,

        style: TextStyle(color: secondryColor, fontSize: 13),

      )),

      decoration: BoxDecoration(

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

      ),

    );

  }


  Widget back(BuildContext context) {

    return Row(

      children: [

        SizedBox(

          width: 20,

        ),

        GestureDetector(

            onTap: () {

              Navigator.pop(context);

            },

            child: SvgPicture.asset(

              "images/icons/back.svg",

              width: 30,

            )),

        Expanded(child: SizedBox()),

      ],

    );

  }


  redSocial(BuildContext context) {

    return Column(

      children: [

        SizedBox(

          height: 50.0,

          width: double.infinity,

          child: TextButton(

            onPressed: () async {

              Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);

            },

            child: Text(

              "Create new account",

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

        ),

        GestureDetector(

            onTap: () {},

            child: Image.asset(

              "images/redsocial1.png",

              height: 45,

            )),

      ],

    );

  }


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

  }


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


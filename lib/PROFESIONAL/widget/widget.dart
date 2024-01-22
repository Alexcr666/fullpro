import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';

import 'package:fullpro/PROFESIONAL/views/profile/menuProfile.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/profile/address/addressUser.dart';

appbarProfessional(BuildContext context, bool activeColor) {
  String dayTime = "";

  TimeOfDay day = TimeOfDay.now();

  switch (day.period) {
    case DayPeriod.am:
      dayTime = Locales.string(context, 'lbl_morning');

      break;

    case DayPeriod.pm:
      dayTime = Locales.string(context, 'lbl_evening');
  }

  return AppBar(
    centerTitle: false,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      //  crossAxisAlignment: CrossAxisAlignment.start,

      // mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Text(
          '$dayTime',
          style: TextStyle(color: activeColor ? Colors.white : secondryColor, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          userInfoPartners == null ? "Hola " : "Hola " + userInfoPartners!.child("fullname").value.toString(),
          style: TextStyle(
            color: activeColor ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
        GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddressesUser("partners")));
            },
            child: Text(
              userInfoPartners == null
                  ? "Selecciona ubicación"
                  : userInfoPartners!.child("location").value == null
                      ? "Seleccionar ubicación"
                      : userInfoPartners!.child("location").value.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            )),
      ],
    ),
    actions: [
      Image.asset(
        "images/logo.png",
        color: activeColor ? Colors.white : secondryColor,
        width: 70,
      ),
      SizedBox(
        width: 20,
      ),

      /*   Padding(

        padding: const EdgeInsets.symmetric(horizontal: 10),

        child: MaterialButton(

            elevation: 0.0,

            hoverElevation: 0.0,

            focusElevation: 0.0,

            highlightElevation: 0.0,

            minWidth: 50,

            height: 60,

            color: Colors.transparent,

            onPressed: () {

              //    Loader.page(context, const CartPage());

            },

            shape: const CircleBorder(),

            child: SvgPicture.asset(

              "images/icons/cart.svg",

              width: 35,

            )),

      ),*/
    ],
    backgroundColor: activeColor ? secondryColor : Colors.white,
    elevation: 0.0,
    toolbarHeight: 70,
    leadingWidth: 80,
    leading: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileOptionsProfessionalPage()));
                    },
                    child: SvgPicture.asset(
                      "images/icons/drawer.svg",
                      width: 35,
                    ))
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/views/Orders/orders.dart';
import 'package:fullpro/PROFESIONAL/views/Orders/ordersList.dart';
import 'package:fullpro/PROFESIONAL/views/account.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/profesional/profileProfesional.dart';
import 'package:fullpro/pages/profile/profileOptions.dart';
import 'package:fullpro/pages/support/newSupport.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      //kkk
      color: secondryColor,
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  height: 50,
                  shape: const CircleBorder(),
                  onPressed: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "images/icons/bottom1.svg",
                        width: 30,
                        color: Colors.white,
                      ),
                      /*  const SizedBox(height: 3),
                      Text(
                        Locales.string(context, 'lbl_home'),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                      ),*/
                    ],
                  ),
                ),
                //
                //
                MaterialButton(
                  height: 50,
                  shape: const CircleBorder(),
                  onPressed: () {
                    Loader.page(
                        context,
                        MyOrders(
                          tabIndicator: 3,
                        ));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "images/icons/bottom2.svg",
                        width: 30,
                        color: Colors.white,
                      ),
                      /* const SizedBox(height: 3),
                      Text(
                        Locales.string(context, 'lbl_orders'),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                      ),*/
                    ],
                  ),
                ),
                //
                //
                MaterialButton(
                  height: 50,
                  shape: const CircleBorder(),
                  onPressed: () {
                    Loader.page(context, const OrdersList());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "images/icons/bottom3.svg",
                        width: 30,
                        color: Colors.white,
                      ),
                      /* const SizedBox(height: 3),
                      Text(
                        Locales.string(context, 'lbl_list'),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                      ),*/
                    ],
                  ),
                ),
                //
                //
                MaterialButton(
                  height: 50,
                  shape: const CircleBorder(),
                  onPressed: () {
                    //    Loader.page(context, const Account());
//kkk

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileProfesionalPage(id: FirebaseAuth.instance.currentUser!.uid.toString())));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(FeatherIcons.user, color: Colors.black),
                      SvgPicture.asset(
                        "images/icons/user.svg",
                        width: 25,
                        color: Colors.white,
                      ),
                      /* const SizedBox(height: 3),
                      Text(
                        Locales.string(context, 'lbl_profile'),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                      ),*/
                    ],
                  ),
                ),
                //
                //
                /*   MaterialButton(
                  shape: CircleBorder(),
                  onPressed: () {
                    //   Loader.page(context, kNotifications());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FeatherIcons.bell, color: Colors.black),
                    ],
                  ),
                ),*/
              ],
            ),
            //
          ],
        ),
      ),
    );
  }
}

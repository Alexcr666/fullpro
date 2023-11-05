import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/controller/loader.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/homepage.dart';

import 'package:fullpro/widgets/widget.dart';

import '../../styles/styles.dart';

import '../styles/statics.dart' as Static;

class ProfileProfesionalPage extends StatefulWidget {
  const ProfileProfesionalPage({Key? key}) : super(key: key);

  @override
  State<ProfileProfesionalPage> createState() => _ProfileProfesionalPageState();
}

int stateIndicator = 0;

class _ProfileProfesionalPageState extends State<ProfileProfesionalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: gradientColor(),
            ),
            Container(
              width: double.infinity,
              height: 280,
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey.withOpacity(0.5),
                        ),
                        Text(
                          "Nombre completo",
                          style: TextStyle(color: secondryColor, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RatingBarIndicator(
                            rating: 2.5,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                )),
                      ],
                    ))),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Container(
                decoration: AppWidget().boxShandowGreyRectangule(),
                padding: EdgeInsets.only(left: 30, right: 20, top: 15, bottom: 15),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "lorem impum",
                          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "8,956",
                          style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Lomrem impusmp",
                          style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "+8,956",
                          style: TextStyle(color: secondryColor, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      width: 55,
                      height: 55,
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        "images/icons/calendar.svg",
                        color: Colors.white,
                      ),
                      color: secondryColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                AppWidget().buttonShandowRounded("Review", stateIndicator != 1, tap: () {
                  stateIndicator = 1;

                  setState(() {});
                }),
                SizedBox(
                  width: 10,
                ),
                AppWidget().buttonShandowRounded("Portafolio", stateIndicator != 2, tap: () {
                  stateIndicator = 2;

                  setState(() {});
                }),
                SizedBox(
                  width: 10,
                ),
                AppWidget().buttonShandowRounded("Historial", stateIndicator != 3, tap: () {
                  stateIndicator = 3;

                  setState(() {});
                }),
                SizedBox(
                  width: 10,
                ),
                AppWidget().buttonShandowRounded("Información", stateIndicator != 4, tap: () {
                  stateIndicator = 4;

                  setState(() {});
                }),
                SizedBox(
                  width: 10,
                ),
              ],
            )),
        SizedBox(
          height: 20,
        ),

        /*    Column(

          children: [

            Row(

              children: [

                Container(

                  decoration: AppWidget().borderColor(),

                  width: 240,

                  padding: EdgeInsets.only(left: 20, right: 30, top: 10, bottom: 10),

                  height: 130,

                  child: Column(

                    children: [

                      Row(

                        children: [

                          SvgPicture.asset(

                            "images/icons/support1.svg",

                            width: 30,

                            height: 30,

                          ),

                          SizedBox(

                            width: 10,

                          ),

                          Text(

                            "Angelica mora",

                            style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 17),

                          ),

                        ],

                      ),

                      Row(

                        children: [

                          SvgPicture.asset(

                            "images/icons/check.svg",

                            width: 20,

                            height: 20,

                          ),

                          SizedBox(

                            width: 10,

                          ),

                          Text(

                            "Trabajo realizado",

                            style: TextStyle(color: secondryColor, fontSize: 13),

                          ),

                        ],

                      ),

                      Row(

                        children: [

                          SvgPicture.asset(

                            "images/icons/globe.svg",

                            width: 20,

                            height: 20,

                          ),

                          SizedBox(

                            width: 15,

                          ),

                          Text(

                            "Calle 45# - 35",

                            style: TextStyle(color: secondryColor, fontSize: 13),

                          ),

                        ],

                      ),

                      Row(

                        children: [

                          SvgPicture.asset(

                            "images/icons/calendar.svg",

                            width: 20,

                            height: 20,

                          ),

                          SizedBox(

                            width: 15,

                          ),

                          Text(

                            "2.500",

                            style: TextStyle(color: secondryColor, fontSize: 23, fontWeight: FontWeight.bold),

                          ),

                        ],

                      ),

                    ],

                  ),

                ),

                SizedBox(

                  width: 10,

                ),

                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                    ),
                    Container(
                      height: 100,
                      width: 1,
                      color: Colors.black,
                    ),
                  ],
                )

              ],

            )

          ],

        ),*/

        Container(
            width: double.infinity,
            height: 300,
            child: AlignedGridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            "",
                            errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                              return Container(
                                width: 90,
                                height: 90,
                                color: Colors.grey.withOpacity(0.3),
                              );
                            },
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "Reparación",
                          style: TextStyle(color: secondryColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Casas",
                          style: TextStyle(color: secondryColor, fontSize: 11),
                        ),
                      ],
                    ));
              },
            )),
        SizedBox(
          height: 20,
        ),
      ],
    ));
  }
}

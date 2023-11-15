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
  TextEditingController nameController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
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
            Container(
                height: 60,
                child: SingleChildScrollView(
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
                    ))),
            SizedBox(
              height: 20,
            ),
            stateIndicator != 2 ? SizedBox() : portafolio(),
            stateIndicator != 3 ? SizedBox() : stateIndicator1(),
            stateIndicator != 1 ? SizedBox() : stateIndicator0(),
            stateIndicator != 4 ? SizedBox() : stateIndicator4(),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget stateIndicator0() {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: AppWidget().boxShandowGreyRectangule(),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.3),
              radius: 40,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 14,
                ),
                Text(
                  "Carlos Duran",
                  style: TextStyle(color: secondryColor, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Opiniones clientes",
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
                RatingBarIndicator(
                    rating: 2.5,
                    itemCount: 5,
                    itemSize: 16.0,
                    itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: secondryColor,
                        )),
                SizedBox(
                  height: 5,
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc posuere, dolor id rhoncus interdum, lacus mauris rutrum metus, a ullamcorper urna nunc efficitur orci.",
                      style: TextStyle(fontSize: 10),
                    )),
                SizedBox(
                  height: 14,
                ),
              ],
            ))
          ],
        ),
      )
    ]);
  }

  Widget itemHistory() {
    return Container(
      decoration: AppWidget().borderColor(),
      width: 170,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      height: 105,
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                "images/icons/support1.svg",
                width: 15,
                height: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Angelica mora",
                style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                "images/icons/check.svg",
                width: 11,
                height: 11,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Trabajo realizado",
                style: TextStyle(color: secondryColor, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                "images/icons/globe.svg",
                width: 15,
                height: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Calle 45# - 35",
                style: TextStyle(color: secondryColor, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                "images/icons/calendar.svg",
                width: 15,
                height: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "2.500",
                style: TextStyle(color: secondryColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget stateIndicator4() {
    return Column(children: [
      SizedBox(
        height: 20,
      ),
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
                "Datos cliente",
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
      SizedBox(
        height: 20,
      ),
      AppWidget().textFieldForm(context, nameController, "Nombre completo"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, dateController, "Fecha"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, emailController, "Correo electronico"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, phoneController, "Celular"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, passwordController, "Contraseña"),
      SizedBox(
        height: 20,
      ),
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
                "Datos profesionales",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondryColor),
              ),
              Text(
                "Datos personales",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: secondryColor),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(child: SizedBox()),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      AppWidget().textFieldForm(context, passwordController, "Nombre Completo"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, passwordController, "Fecha"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, passwordController, "Correo electronico"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, passwordController, "Celular"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, passwordController, "Contraseña"),
      SizedBox(
        height: 10,
      ),
      AppWidget().textFieldForm(context, passwordController, "Profesión"),
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Flexible(child: AppWidget().textFieldForm(context, passwordController, "Contraseña")),
          Flexible(child: AppWidget().textFieldForm(context, passwordController, "Contraseña")),
        ],
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }

  Widget stateIndicator1() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 7,
            ),
            itemHistory(),
            SizedBox(
              width: 5,
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
            ),
            SizedBox(
              width: 5,
            ),
            itemHistory(),
          ],
        )
      ],
    );
  }

  Widget portafolio() {
    return Container(
        width: double.infinity,
        height: 300,
        child: AlignedGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "",
                            errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                              return Container(
                                width: 110,
                                height: 110,
                                color: Colors.grey.withOpacity(0.3),
                              );
                            },
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  "images/icons/addCircleBlue.svg",
                                  width: 40,
                                ))),
                      ],
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
        ));
  }
}

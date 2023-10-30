import 'package:flutter/material.dart';


import 'package:flutter_feather_icons/flutter_feather_icons.dart';


import 'package:flutter_locales/flutter_locales.dart';


import 'package:flutter_svg/flutter_svg.dart';


import 'package:fullpro/config.dart';


import 'package:fullpro/controller/loader.dart';


import 'package:fullpro/pages/INTEGRATION/Profile/profile.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


import 'package:fullpro/pages/about.dart';


import 'package:fullpro/pages/homepage.dart';


import 'package:fullpro/pages/language.dart';


import 'package:fullpro/pages/profile/account.dart';


import 'package:fullpro/pages/profile/addresses.dart';


import 'package:fullpro/pages/terms.dart';


import 'package:fullpro/utils/userpreferences.dart';


import 'package:fullpro/widgets/ProfileButtonWithBottomSheet.dart';


import 'package:fullpro/widgets/ProfileWidget.dart';


import 'package:fullpro/widgets/widget.dart';


import 'package:fullpro/styles/statics.dart' as Static;


class ProfileOptionsPage extends StatefulWidget {

  const ProfileOptionsPage({Key? key}) : super(key: key);


  static const String id = 'TermsPage';


  @override

  State<ProfileOptionsPage> createState() => _ProfileOptionsPageState();

}


class _ProfileOptionsPageState extends State<ProfileOptionsPage> {

  Widget itemProfile(String url, String title, {Function? tap}) {

    return GestureDetector(

        child: Column(

      children: [

        Container(

          width: 53,

          height: 53,

          child: Container(

            child: SvgPicture.asset(url),

            width: 30,

            padding: EdgeInsets.all(12),

            height: 30,

          ),

          decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),

        ),

        SizedBox(

          height: 1,

        ),

        Container(

            width: 70,

            child: Text(

              title,

              textAlign: TextAlign.center,

              style: TextStyle(color: secondryColor, fontSize: 11),

            ))

      ],

    ));

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: SingleChildScrollView(

        physics: const AlwaysScrollableScrollPhysics(),

        child: Padding(

          padding: const EdgeInsets.symmetric(

            vertical: 10,

            horizontal: 24,

          ),

          child: Column(

            //  physics: const BouncingScrollPhysics(),


            children: [

              /* Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onPressed: () => Navigator.pop(context),
                              elevation: 0.0,
                              hoverElevation: 0.0,
                              focusElevation: 0.0,
                              highlightElevation: 0.0,
                              color: Colors.transparent,
                              minWidth: 20,
                              height: 20,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(5),
                              child: SvgPicture.asset('images/svg_icons/arrowLeft.svg'),
                            ),
                          ],
                        ),*/


              SizedBox(

                height: 20,

              ),


              Row(

                children: [

                  GestureDetector(

                    onTap: () {

                      Navigator.pop(context);

                    },

                    child: SvgPicture.asset(

                      'images/icons/back.svg',

                      width: 30,

                    ),

                  ),

                  Expanded(child: SizedBox()),

                  Image.asset(

                    "images/logo.png",

                    width: 80,

                  ),

                ],

              ),


              SizedBox(

                height: 10,

              ),


              Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    "Hola",

                    style: TextStyle(color: secondryColor, fontSize: 25),

                  ),

                  Text(

                    "Andres peña",

                    style: TextStyle(color: secondryColor, fontSize: 25, fontWeight: FontWeight.bold),

                  ),

                ],

              ),


              SizedBox(

                height: 10,

              ),


              Container(

                  decoration: AppWidget().boxShandowGrey(),

                  padding: EdgeInsets.only(top: 33, bottom: 33),

                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [

                      itemProfile("images/icons/profile1.svg", "Datos de perfil"),


                      itemProfile("images/icons/profile2.svg", "Centro de ayuda"),


                      itemProfile("images/icons/profile3.svg", "Historial de pedidos"),


                      itemProfile("images/icons/profile4.svg", "Metodos de pago"),


                      //  "images/icons/profile1.svg"

                    ],

                  )),


              /* Container(

                  width: 60,

                  height: 60,

                  child: ProfileWidget(

                    imagePath: 'images/user_icon.png',

                    onClicked: () async {},

                  )),*/


              const SizedBox(height: 24),


              // ignore: prefer_if_null_operators


              //     buildName(UserPreferences.getUsername() != null ? UserPreferences.getUsername() : getUserName),


              const SizedBox(height: 10),


              //


              //


              Center(

                child: Container(

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(12),

                    color: Colors.white,

                  ),

                  child: Column(

                    children: [

                      ProfileButton(

                        buttonName: /* Locales.string(context, 'lbl_account')*/ "Mi perfil",

                        onCLicked: () {

                          Navigator.pop(context);


                          //


                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Account()));


                          //    Navigator.push(context, MaterialPageRoute(builder: (context) => const Account()));

                        },

                        icon: "images/icons/miprofile1.svg",

                      ),


                      const Divider(color: Colors.black12),


                      ProfileButton(

                        buttonName: "Ajustes",

                        onCLicked: () {

                          bool isPuchased = false;


                          Navigator.pop(context);


                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(currentUser!, isPuchased)));

                        },

                        icon: "images/icons/miprofile2.svg",

                      ),


                      const Divider(color: Colors.black12),


                      ProfileButton(

                        buttonName: /*Locales.string(context, 'lbl_address')*/ "Notificaciones",

                        onCLicked: () {

                          Navigator.pop(context);


                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Addresses()));

                        },

                        icon: "images/icons/miprofile3.svg",

                      ),


                      const Divider(color: Colors.black12),


                      ProfileButton(

                        buttonName: /*Locales.string(context, 'lbl_language')*/ "Acerca de el app",

                        onCLicked: () {

                          Navigator.pop(context);


                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Language()));

                        },

                        icon: "images/icons/miprofile4.svg",

                      ),


                      // const Divider(color: Colors.black12),


                      // ProfileButton(


                      //   buttonName: 'Wallet',


                      //   onCLicked: () {


                      //     Loader.page(context, Wallet());


                      //   },


                      //   icon: FeatherIcons.dollarSign,


                      // ),

                    ],

                  ),

                ),

              ),


              //


              const SizedBox(height: 20),


              Center(

                child: Container(

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(12),

                    color: Colors.white,

                  ),

                  child: Column(

                    children: [

                      ProfileButton(

                        buttonName: /*Locales.string(context, 'lbl_invite_friends')*/ "Portafolio",

                        onCLicked: () {

                          Navigator.pop(context);


                          //


                          // share();

                        },

                        icon: "images/icons/miprofile5.svg",

                      ),

                      const Divider(color: Colors.black12),

                      ProfileButton(

                        buttonName: /* Locales.string(context, 'lbl_terms_and_conditions')*/ "Soporte",

                        onCLicked: () {

                          Navigator.pop(context);


                          Loader.page(context, const TermsPage());


                          //

                        },

                        icon: "images/icons/miprofile6.svg",

                      ),

                      const Divider(color: Colors.black12),

                      ProfileButton(

                        buttonName: /* Locales.string(context, 'lbl_about')*/ "Cerrar sesión",

                        onCLicked: () {

                          Navigator.pop(context);


                          Loader.page(context, const AboutPage());

                        },

                        icon: "images/icons/miprofile7.svg",

                      ),


                      /*  const Divider(color: Colors.black12),

                      ProfileButton(

                        buttonName: Locales.string(context, 'lbl_logout'),

                        onCLicked: () {

                          Navigator.pop(context);


                          //    _signOut().then((value) => Navigator.of(context)


                          //      .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Register()), (route) => false));

                        },

                        icon: "images/icons/miprofile1.svg",

                      ),*/

                    ],

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}

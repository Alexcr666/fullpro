import 'package:flutter/material.dart';


import 'package:flutter_locales/flutter_locales.dart';


import 'package:flutter_svg/flutter_svg.dart';


import 'package:fullpro/config.dart';


import 'package:fullpro/controller/loader.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


import 'package:fullpro/pages/homepage.dart';


import 'package:fullpro/widgets/widget.dart';


class DeleteAccountPage extends StatefulWidget {

  const DeleteAccountPage({Key? key}) : super(key: key);


  //static const String id = 'TermsPage';


  @override

  State<DeleteAccountPage> createState() => _DeleteAccountPageState();

}


class _DeleteAccountPageState extends State<DeleteAccountPage> {

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,


      /* appBar: AppBar(
        backgroundColor: Static.dashboardBG,
        elevation: 0.0,
        toolbarHeight: 80,
        leadingWidth: 100,
        leading: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: SvgPicture.asset('images/svg_icons/arrowLeft.svg'),
        ),
      ),*/


      body: SingleChildScrollView(

        physics: const AlwaysScrollableScrollPhysics(),

        child: Padding(

          padding: const EdgeInsets.symmetric(

            vertical: 10,

            horizontal: 24,

          ),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              SizedBox(

                height: 40,

              ),


              AppWidget().back(context),


              SizedBox(

                height: 40,

              ),


              Container(

                  margin: EdgeInsets.only(left: 50, right: 50),

                  child: Text(

                    "Eliminar cuenta",

                    style: TextStyle(

                      color: secondryColor,

                      fontSize: 20,

                      fontWeight: FontWeight.bold,

                    ),

                  )),


              SizedBox(

                height: 30,

              ),


              SvgPicture.asset(

                "images/icons/profileCircle.svg",

                width: 80,

              ),


              SizedBox(

                height: 20,

              ),


              Text(

                "¿Desactivar la cuenta en lugar de eliminarla?",

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: secondryColor,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                ),

              ),


              SizedBox(

                height: 50,

              ),


              Row(

                children: [

                  SvgPicture.asset(

                    "images/icons/saved.svg",

                    width: 30,

                  ),

                  SizedBox(

                    width: 20,

                  ),

                  Flexible(

                      child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(

                        "¿Desactivar la cuenta en lugar de eliminarla?",

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          color: secondryColor,

                          fontSize: 14,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                      Text(

                        "¿Desactivar la cuenta en lugar de eliminarla?",

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          color: secondryColor,

                          fontSize: 13,

                        ),

                      ),

                    ],

                  ))

                ],

              )


              /*Text(

                '$appName ${Locales.string(context, 'lbl_terms_para_one')}',

                style: const TextStyle(

                  fontSize: 14,

                  fontFamily: 'Roboto-Regular',

                ),

                textAlign: TextAlign.center,

              ),*/


              ,


              SizedBox(height: 30),


              //


              //


              const SizedBox(height: 90),


              Container(


                  //   margin: EdgeInsets.only(left: 70, right: 70),


                  child: AppWidget().buttonForm(context, "Regresar", tap: () {

                Loader.PagewithHome(context, const kHomePage());

              })),


              const SizedBox(height: 30),


              Text(

                "Eliminar cuenta",

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: secondryColor,

                  fontSize: 20,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}


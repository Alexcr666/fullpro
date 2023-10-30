import 'package:flutter/material.dart';


import 'package:flutter_locales/flutter_locales.dart';


import 'package:flutter_svg/flutter_svg.dart';


import 'package:fullpro/config.dart';


import 'package:fullpro/controller/loader.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


import 'package:fullpro/pages/homepage.dart';


import 'package:fullpro/pages/support/newSupport.dart';


import 'package:fullpro/widgets/widget.dart';


import '../styles/statics.dart' as Static;


class PortafolioPage extends StatefulWidget {

  const PortafolioPage({Key? key}) : super(key: key);


  static const String id = 'TermsPage';


  @override

  State<PortafolioPage> createState() => _PortafolioPageState();

}


class _PortafolioPageState extends State<PortafolioPage> {

  itemPortafolio() {

    return Container(

        margin: EdgeInsets.only(top: 10),

        child: Row(

          children: [

            CircleAvatar(

              backgroundColor: Colors.grey.withOpacity(0.3),

              radius: 30,

            ),

            SizedBox(

              width: 30,

            ),

            Container(

                width: 250,

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        Flexible(

                            child: Column(

                          children: [

                            Text(

                              "Alex",

                              textAlign: TextAlign.center,

                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: secondryColor),

                            ),

                            Text(

                              "titulo",

                              textAlign: TextAlign.center,

                              style: TextStyle(fontSize: 11, color: secondryColor),

                            ),

                          ],

                        )),


                        // Expanded(child: SizedBox()),

                      ],

                    ),

                    SizedBox(

                      height: 5,

                    ),

                    Row(

                      children: [

                        Icon(

                          Icons.star_border_rounded,

                          color: secondryColor,

                          size: 20,

                        ),

                        Icon(

                          Icons.star_border_rounded,

                          color: secondryColor,

                          size: 20,

                        ),

                        Icon(

                          Icons.star_border_rounded,

                          color: secondryColor,

                          size: 20,

                        ),

                        Icon(

                          Icons.star_border_rounded,

                          color: secondryColor,

                          size: 20,

                        ),

                        Icon(

                          Icons.star_border_rounded,

                          color: secondryColor,

                          size: 20,

                        ),

                      ],

                    )

                  ],

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

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              SizedBox(

                height: 40,

              ),


              AppWidget().back(context),


              SizedBox(

                height: 40,

              ),


              Row(

                children: [

                  Container(

                      child: Text(

                    "Lista de portafolio",

                    style: TextStyle(

                      color: secondryColor,

                      fontSize: 20,

                      fontWeight: FontWeight.bold,

                    ),

                  )),

                  Expanded(child: SizedBox()),

                  GestureDetector(

                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewPortafolioPage()));

                      },

                      child: Container(

                          width: 40,

                          height: 40,

                          decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),

                          child: SvgPicture.asset("images/icons/add.svg"))),

                ],

              ),


              SizedBox(

                height: 50,

              ),


              itemPortafolio(),


              Text(

                '$appName ${Locales.string(context, 'lbl_terms_para_one')}',

                style: const TextStyle(

                  fontSize: 14,

                  fontFamily: 'Roboto-Regular',

                ),

                textAlign: TextAlign.center,

              ),


              const SizedBox(height: 30),


              //


              //


              const SizedBox(height: 40),


              Container(

                  margin: EdgeInsets.only(left: 70, right: 70),

                  child: AppWidget().buttonFormWhite(context, "Regresar", tap: () {

                    Loader.PagewithHome(context, const kHomePage());

                  })),


              const SizedBox(height: 40),

            ],

          ),

        ),

      ),

    );

  }

}


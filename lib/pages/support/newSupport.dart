import 'package:flutter/material.dart';


import 'package:flutter_locales/flutter_locales.dart';


import 'package:flutter_svg/flutter_svg.dart';


import 'package:fullpro/config.dart';


import 'package:fullpro/controller/loader.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


import 'package:fullpro/pages/homepage.dart';


import 'package:fullpro/widgets/widget.dart';


import '../styles/statics.dart' as Static;


class NewPortafolioPage extends StatefulWidget {

  const NewPortafolioPage({Key? key}) : super(key: key);


  static const String id = 'TermsPage';


  @override

  State<NewPortafolioPage> createState() => _PortafolioPageState();

}


class _PortafolioPageState extends State<NewPortafolioPage> {

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

                    "Nuevo portafolio",

                    style: TextStyle(

                      color: secondryColor,

                      fontSize: 20,

                      fontWeight: FontWeight.bold,

                    ),

                  )),

                  Expanded(child: SizedBox()),

                  Container(

                      width: 40,

                      height: 40,

                      decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),

                      child: SvgPicture.asset("images/icons/add.svg")),

                ],

              ),

              SizedBox(

                height: 20,

              ),

              AppWidget().texfieldFormat(title: "Nombre de portafolio", urlIcon: "images/icons/work.svg"),

              SizedBox(

                height: 20,

              ),

              Row(

                children: [

                  Flexible(

                      child: Container(

                          decoration: AppWidget().borderColor(),

                          child: CheckboxListTile(

                            title: Text("Servicios", style: TextStyle(color: secondryColor)),


                            value: false,


                            onChanged: (newValue) {

                              setState(() {

                                //  checkedValue = newValue;

                              });

                            },


                            controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox

                          ))),

                  SizedBox(

                    width: 10,

                  ),

                  Flexible(

                      child: Container(

                          decoration: AppWidget().borderColor(),

                          child: CheckboxListTile(

                            title: Text(

                              "Servicios",

                              style: TextStyle(color: secondryColor),

                            ),


                            value: false,


                            onChanged: (newValue) {

                              setState(() {

                                //  checkedValue = newValue;

                              });

                            },


                            controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox

                          ))),

                ],

              ),

              SizedBox(

                height: 20,

              ),

              AppWidget().texfieldFormat(title: "Categorias"),

              Container(

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(12),


                    border: Border.all(color: secondryColor),


                    //  color: secondryColor,

                  ),

                  child: ListView.builder(

                      padding: EdgeInsets.only(left: 10.0),

                      itemCount: 2,

                      physics: NeverScrollableScrollPhysics(),

                      shrinkWrap: true,

                      itemBuilder: (BuildContext context, int index) {

                        return CheckboxListTile(

                          title: Text("Categorias " + (index + 1).toString()),


                          value: false,


                          onChanged: (newValue) {

                            setState(() {

                              //  checkedValue = newValue;

                            });

                          },


                          controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox

                        );

                      })),

              SizedBox(

                height: 20,

              ),

              Text("Fotos portafolio"),

              SizedBox(

                height: 5,

              ),

              Stack(

                children: [

                  Container(

                      alignment: Alignment.center,

                      width: double.infinity,

                      height: 50,

                      child: Text(

                        "Drag & Drop your files or Mobile",

                        style: TextStyle(color: Colors.black),

                      )),

                  Container(

                      alignment: Alignment.center,

                      width: double.infinity,

                      height: 50,

                      child: SvgPicture.asset("images/icons/rectangule.svg")),

                ],

              ),

              SizedBox(

                height: 20,

              ),

              Row(

                children: [

                  Flexible(child: AppWidget().buttonForm(context, "Cancelar")),

                  Flexible(child: AppWidget().buttonForm(context, "Guardar")),

                ],

              ),

            ],

          ),

        ),

      ),

    );

  }

}


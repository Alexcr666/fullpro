import 'package:firebase_database/firebase_database.dart';


import 'package:flutter/material.dart';


import 'package:flutter_locales/flutter_locales.dart';


import 'package:flutter_svg/flutter_svg.dart';


import 'package:fullpro/config.dart';


import 'package:fullpro/controller/loader.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


import 'package:fullpro/pages/homepage.dart';


import 'package:fullpro/widgets/widget.dart';


class SupportAppPage extends StatefulWidget {

  const SupportAppPage({Key? key}) : super(key: key);


  //static const String id = 'TermsPage';


  @override

  State<SupportAppPage> createState() => _SupportAppPageState();

}


final _formKey = GlobalKey<FormState>();


class _SupportAppPageState extends State<SupportAppPage> {

  TextEditingController _nameController = TextEditingController();


  TextEditingController _phoneController = TextEditingController();


  TextEditingController _dateController = TextEditingController();


  TextEditingController _descriptionController = TextEditingController();


  Widget item1(String url, String title, String subtitle) {

    return Row(

      children: [

        SvgPicture.asset(

          /*   "images/icons/saved.svg"*/ url,

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

              /* "¿Desactivar la cuenta en lugar de eliminarla?"*/ title,

              textAlign: TextAlign.left,

              style: TextStyle(

                color: secondryColor,

                fontSize: 14,

                fontWeight: FontWeight.bold,

              ),

            ),

            Text(

              /*"¿Desactivar la cuenta en lugar de eliminarla?"*/ subtitle,

              textAlign: TextAlign.left,

              style: TextStyle(

                color: secondryColor,

                fontSize: 13,

              ),

            ),

          ],

        ))

      ],

    );

  }


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

            child: Form(

              key: _formKey,

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


                  Row(

                    children: [

                      Container(

                          child: Text(

                        "Soporte",

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

                    height: 30,

                  ),


                  Row(

                    children: [

                      SvgPicture.asset(

                        "images/icons/profileCircle.svg",

                        width: 30,

                      ),

                      SizedBox(

                        width: 20,

                      ),

                      Container(

                          child: Row(

                        children: [

                          Text(

                            "Creación de",

                            style: TextStyle(

                              color: secondryColor,

                              fontSize: 20,

                            ),

                          ),

                          SizedBox(

                            width: 10,

                          ),

                          Text(

                            "solicitud",

                            style: TextStyle(

                              color: secondryColor,

                              fontSize: 20,

                              fontWeight: FontWeight.bold,

                            ),

                          )

                        ],

                      )),

                    ],

                  ),


                  SizedBox(

                    height: 30,

                  ),


                  SizedBox(height: 10),


                  AppWidget().texfieldFormat(title: "Nombre de usuario", urlIcon: "images/icons/support1.svg", controller: _nameController),


                  SizedBox(height: 10),


                  AppWidget()

                      .texfieldFormat(title: "Teléfono de contacto", urlIcon: "images/icons/support2.svg", controller: _phoneController),


                  SizedBox(height: 10),


                  AppWidget()
                      .texfieldFormat(title: "Fecha de solicitud", urlIcon: "images/icons/support3.svg", controller: _dateController),


                  SizedBox(height: 10),


                  AppWidget()

                      .texfieldFormat(title: "Descripción", urlIcon: "images/icons/support4.svg", controller: _descriptionController),


                  SizedBox(height: 10),


                  //  AppWidget().texfieldFormat(title: "Estado de solicitud", urlIcon: "images/icons/support5.svg"),


                  SizedBox(height: 30),


                  //


                  //


                  Container(


                      //   margin: EdgeInsets.only(left: 70, right: 70),


                      child: AppWidget().buttonForm(context, "Enviar", tap: () {

                    //Loader.PagewithHome(context, const kHomePage());


                    savedData() {

                      DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('support').push();


                      // Prepare data to be saved on users table


                      Map userMap = {

                        'name': _nameController.text,

                        'phone': _phoneController.text,

                        'date': _dateController.text,

                        'description': _descriptionController.text,

                        'state': 0,

                      };


                      newUserRef.set(userMap).then((value) {

                        Navigator.pop(context);


                        AppWidget().itemMessage("Guardado", context);

                      }).catchError((onError) {

                        AppWidget().itemMessage("Error al guardar", context);

                      });

                    }


                    if (_formKey.currentState!.validate()) {

                      savedData();

                    }

                  })),

                ],

              ),

            ),

          )),

    );

  }

}


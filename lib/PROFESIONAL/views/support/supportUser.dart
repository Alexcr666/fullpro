import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';

import 'package:fullpro/PROFESIONAL/views/support/listSupport.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/controller/loader.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/homepage.dart';

import 'package:fullpro/widgets/widget.dart';

import 'package:intl/intl.dart';

class SupportAppProfessionalPage extends StatefulWidget {
  const SupportAppProfessionalPage({Key? key}) : super(key: key);

  //static const String id = 'TermsPage';

  @override
  State<SupportAppProfessionalPage> createState() => _SupportAppProfessionalPageState();
}

final _formKey = GlobalKey<FormState>();

class _SupportAppProfessionalPageState extends State<SupportAppProfessionalPage> {
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
              /* "¿Desactivar la cuenta en lugar de Locales.string(context, 'lang_location')la?"*/ title,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: secondryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              /*"¿Desactivar la cuenta en lugar de Locales.string(context, 'lang_location')la?"*/ subtitle,
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
                        Locales.string(context, 'lang_support'),
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
                            Locales.string(context, "lang_creation_support"),
                            style: TextStyle(
                              color: secondryColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  SizedBox(height: 10),

                  //   AppWidget().texfieldFormat(
                  //     title: Locales.string(context, 'lbl_fullname'), urlIcon: "images/icons/support1.svg", controller: _nameController),

                  //SizedBox(height: 10),

                  //   AppWidget().texfieldFormat(
                  //     title: "Teléfono de contacto", urlIcon: "images/icons/support2.svg", controller: _phoneController, number: true),

                  SizedBox(height: 10),

                  GestureDetector(
                      onTap: () {
                        void _showIOS_DatePicker(ctx) {
                          showCupertinoModalPopup(
                              context: ctx,
                              builder: (_) => Container(
                                    height: 190,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 180,
                                          child: CupertinoDatePicker(
                                              mode: CupertinoDatePickerMode.date,
                                              initialDateTime: DateTime.now(),
                                              onDateTimeChanged: (val) {
                                                setState(() {
                                                  final f = new DateFormat('yyyy-MM-dd');

                                                  _dateController.text = f.format(val);

                                                  //  dateSelected = val.toString();
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ));
                        }

                        _showIOS_DatePicker(context);
                      },
                      child: AppWidget().texfieldFormat(
                          title: "Fecha de solicitud", controller: _dateController, urlIcon: "images/icons/calendar.svg", enabled: true)),

                  //  AppWidget()

                  //    .texfieldFormat(title: "Fecha de solicitud", urlIcon: "images/icons/support3.svg", controller: _dateController),

                  SizedBox(height: 10),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: secondryColor, width: 1), borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 8, //or null
                          decoration: InputDecoration.collapsed(hintText: Locales.string(context, "lang_description")),
                        ),
                      )),
                  //    AppWidget()
                  //      .texfieldFormat(title: "Descripción", urlIcon: "images/icons/support4.svg", controller: _descriptionController),

                  SizedBox(height: 10),

                  //  AppWidget().texfieldFormat(title: "Estado de solicitud", urlIcon: "images/icons/support5.svg"),

                  SizedBox(height: 30),

                  //

                  //

                  Container(

                      //   margin: EdgeInsets.only(left: 70, right: 70),

                      child: AppWidget().buttonForm(context, Locales.string(context, 'lbl_send'), tap: () {
                    //Loader.PagewithHome(context, const kHomePage());

                    savedData() {
                      DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('support').push();

                      // Prepare data to be saved on users table

                      Map userMap = {
                        'name': userInfoPartners!.child("fullname").value.toString(),
                        'phone': userInfoPartners!.child("phone").value.toString(),
                        'date': _dateController.text,
                        'user': FirebaseAuth.instance.currentUser!.uid.toString(),
                        'description': _descriptionController.text,
                        'state': 0,
                      };

                      newUserRef.set(userMap).then((value) {
                        // Navigator.pop(context);

                        newUserRef.child("message").push().set({
                          "description": "Su solicitud ha sido enviada con exito, en un rato se atendera",
                          "date": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
                          "nameUser": "Admin",
                          "user": "admin"
                        }).then((value) {
                          Navigator.pop(context);

                          AppWidget().itemMessage("Guardado", context);
                          //  AppWidget().itemMessage("Enviado", context);
                        }).catchError((onError) {
                          AppWidget().itemMessage(Locales.string(context, "lang_error"), context);
                        });

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ListSupportProfessionalPage()));

                        // AppWidget().itemMessage("Guardado", context);
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

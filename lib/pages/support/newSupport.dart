import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_database/firebase_database.dart';

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
  NewPortafolioPage({Key? key, this.idEdit}) : super(key: key);

  String? idEdit;

  static const String id = 'TermsPage';

  @override
  State<NewPortafolioPage> createState() => _PortafolioPageState();
}

bool licenceCheck = false;

TextEditingController _searchHome = TextEditingController();
List<File> fileLicense = [];

class _PortafolioPageState extends State<NewPortafolioPage> {
  TextEditingController _namePortafolioController = TextEditingController();

  TextEditingController _categoriController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  bool checkInspeccion = false;

  List<String> suggestions = [];

  void servicesSearch(int type) {
    suggestions.clear();
    if (type == 1) {
      final UserRef = FirebaseDatabase.instance.ref().child("categories").once().then((value) {
        DatabaseEvent response = value;

        for (var i = 0; i < response.snapshot.children.length; i++) {
          DataSnapshot dataList = response.snapshot.children.toList()[i];

          if (dataList.child("name").value != null) {
            suggestions.add(dataList.child("name").value.toString());
          }
        }
        setState(() {});
      });
    } else {
      final UserRef = FirebaseDatabase.instance.ref().child("inspections").once().then((value) {
        DatabaseEvent response = value;

        for (var i = 0; i < response.snapshot.children.length; i++) {
          DataSnapshot dataList = response.snapshot.children.toList()[i];

          if (dataList.child("name").value != null) {
            suggestions.add(dataList.child("name").value.toString());
          }
        }
        setState(() {});
      });
    }

/*    UserRef.once().then((e) async {
      final dataSnapshot = e.snapshot;

     
    });*/
  }

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

  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
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
                      SvgPicture.asset(
                        "images/icons/edit.svg",
                        width: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AppWidget().texfieldFormat(
                      title: "Nombre de portafolio", urlIcon: "images/icons/maletin.svg", controller: _namePortafolioController),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                          child: Container(
                              decoration: AppWidget().borderColor(),
                              child: CheckboxListTile(
                                activeColor: secondryColor,

                                contentPadding: EdgeInsets.all(0),

                                title: Text("Servicios", style: TextStyle(color: secondryColor)),

                                value: checkInspeccion == true,

                                onChanged: (newValue) {
                                  setState(() {
                                    checkInspeccion = true;

                                    //  checkedValue = newValue;
                                  });
                                },

                                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                              ))),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          child: Container(
                              decoration: AppWidget().borderColor(),
                              child: CheckboxListTile(
                                activeColor: secondryColor,

                                contentPadding: EdgeInsets.all(0),

                                title: Text(
                                  "Inspecciones",
                                  style: TextStyle(color: secondryColor, fontSize: 14),
                                ),

                                value: checkInspeccion == false,

                                onChanged: (newValue) {
                                  setState(() {
                                    checkInspeccion = false;

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
                  SimpleAutoCompleteTextField(
                    key: key,
                    decoration: InputDecoration(
                      // errorText: "Ingresar servicio valido",
                      contentPadding: EdgeInsets.only(top: 17, bottom: 17, left: 15),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(11)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),
                      labelText: "Profesión",
                      labelStyle: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                    controller: _searchHome,
                    suggestions: suggestions,
                    //   textChanged: (text) => currentText = text,
                    clearOnSubmit: true,
                    textSubmitted: (text) => setState(() {
                      _searchHome.text = text;
                      // setState(() {});
                      // added.add(text);
                    }),
                  ),

                  /*  AppWidget().texfieldFormat(title: "Categorias", controller: _categoriController),

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

                          })),*/

                  SizedBox(
                    height: 20,
                  ),
                  Text("Fotos portafolio"),
                  SizedBox(
                    height: 10,
                  ),
                  fileLicense.length == 0
                      ? SizedBox()
                      : Container(
                          height: 40,
                          child: ListView.builder(
                              padding: EdgeInsets.only(left: 10.0),
                              itemCount: fileLicense.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 150,
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xff38CAB3),

                                    // Set border width

                                    borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            fileLicense.removeAt(0);

                                            setState(() {});
                                          },
                                          child: SvgPicture.asset(
                                            "images/icons/closeFile.svg",
                                            width: 35,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fileLicense[index].path.split('/').last,
                                            maxLines: 1,
                                            style: TextStyle(color: Colors.white, fontSize: 10),
                                          ),
                                          Text(
                                            AppWidget().getFileSize(fileLicense[index].lengthSync(), 1),
                                            style: TextStyle(color: Colors.white, fontSize: 9),
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                );
                              })),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();

                        if (result != null) {
                          fileLicense.add(File(result.files.single.path!));

                          licenceCheck = false;

                          setState(() {});
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: DottedBorder(
                        color: licenceCheck ? Colors.red : Colors.grey,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        padding: EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            child: Center(child: Text("Drag & Drop your files or Mobile")),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(child: AppWidget().buttonFormLine(context, "Cancelar", true, urlIcon: "images/icons/closeCircle.svg")),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                          child: AppWidget().buttonFormLine(context, "Guardar", false, urlIcon: "images/icons/saved.svg", tap: () {
                        savedData() {
                          DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('portafolio/1');

                          // Prepare data to be saved on users table

                          Map userMap = {
                            'name': _namePortafolioController.text,
                            'type': checkInspeccion ? 1 : 2,
                            'category': "tecno",
                            'foto': '1'
                          };

                          newUserRef.set(userMap).then((value) {
                            Navigator.pop(context);

                            AppWidget().itemMessage("Guardado", context);
                          }).catchError((onError) {
                            AppWidget().itemMessage("Error al guardar", context);
                          });
                        }

                        updateData() {
                          DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('portafolio/' + widget.idEdit.toString());

                          // Prepare data to be saved on users table

                          Map userMap = {
                            'name': _namePortafolioController.text,
                            'type': checkInspeccion ? 1 : 2,
                            'category': "tecno",
                            'foto': '1'
                          };

                          newUserRef.set(userMap).then((value) {
                            Navigator.pop(context);

                            AppWidget().itemMessage("Actualizado", context);
                          }).catchError((onError) {
                            AppWidget().itemMessage("Error al guardar", context);
                          });
                        }

                        if (_formKey.currentState!.validate()) {
                          if (fileLicense.length != 0) {
                            savedData();

                            licenceCheck = false;
                          } else {
                            licenceCheck = true;
                          }

                          setState(() {});
                        }
                      })),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();

    servicesSearch(1);

    if (widget.idEdit != null) {
      final UserRef = FirebaseDatabase.instance.ref().child("portafolio").child("1");

      UserRef.once().then((e) async {
        final dataSnapshot = e.snapshot;

        _namePortafolioController.text = dataSnapshot.child("name").value.toString();

        _categoriController.text = dataSnapshot.child("category").value.toString();

        if (dataSnapshot.child("type").value.toString() == "1") {
          checkInspeccion = true;
        } else {
          checkInspeccion = false;
        }
      });
    }
  }
}

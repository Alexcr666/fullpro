import 'package:firebase_database/firebase_database.dart';


import 'package:flutter/material.dart';


import 'package:flutter_locales/flutter_locales.dart';


import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import 'package:flutter_svg/flutter_svg.dart';


import 'package:fullpro/config.dart';

import 'package:fullpro/const.dart';


import 'package:fullpro/controller/loader.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


import 'package:fullpro/pages/homepage.dart';


import 'package:fullpro/pages/support/newSupport.dart';

import 'package:fullpro/pages/support/support.dart';


import 'package:fullpro/widgets/widget.dart';


import '../styles/statics.dart' as Static;


class ListSupportPage extends StatefulWidget {

  const ListSupportPage({Key? key}) : super(key: key);


  static const String id = 'TermsPage';


  @override

  State<ListSupportPage> createState() => _ListSupportPageState();

}


class _ListSupportPageState extends State<ListSupportPage> {

  Widget stateIndicator0() {

    return FutureBuilder(


        // initialData: 1,


        future: FirebaseDatabase.instance.ref().child('support').once(),

        builder: (BuildContext context, AsyncSnapshot snapshot) {

          try {

            if (snapshot.hasData) {

              DatabaseEvent response = snapshot.data;


              return response == null

                  ? Text("Cargando")

                  : ListView.builder(

                      itemCount: response.snapshot.children.length,

                      shrinkWrap: true,

                      itemBuilder: (BuildContext context, int index) {

                        DataSnapshot dataList = response.snapshot.children.toList()[index];


                        return GestureDetector(

                            onTap: () {

                              showModalBottomSheet(

                                  context: context,

                                  builder: (context) {

                                    return Column(

                                      mainAxisSize: MainAxisSize.min,

                                      children: <Widget>[

                                        ListTile(

                                          title: new Text('Eliminar'),

                                          onTap: () {

                                            dataList.ref.remove().then((value) {

                                              AppWidget().itemMessage("Eliminado", context);


                                              setState(() {});

                                            });


                                            Navigator.pop(context);

                                          },

                                        ),

                                        ListTile(

                                          title: new Text('Actualizar'),

                                          onTap: () {

                                            Navigator.pop(context);


                                            Navigator.push(

                                                context,

                                                MaterialPageRoute(

                                                    builder: (context) => NewPortafolioPage(

                                                          idEdit: dataList.key.toString(),

                                                        )));

                                          },

                                        ),

                                        ListTile(

                                          title: new Text('Cancelar'),

                                          onTap: () {

                                            Navigator.pop(context);

                                          },

                                        ),

                                      ],

                                    );

                                  });

                            },

                            child: Container(

                                decoration: AppWidget().boxShandowGrey(),

                                margin: EdgeInsets.only(top: 10),

                                padding: EdgeInsets.only(top: 20, right: 20, bottom: 20),

                                child: Row(

                                  children: [

                                    SizedBox(

                                      width: 10,

                                    ),

                                    ClipRRect(

                                      borderRadius: BorderRadius.circular(15),

                                      child: Image.network(

                                        dataList.child("foto").value.toString(),

                                        errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {

                                          return Container(

                                            width: 70,

                                            height: 70,

                                            color: Colors.grey.withOpacity(0.3),

                                          );

                                        },

                                        width: 70,

                                        height: 70,

                                        fit: BoxFit.cover,

                                      ),

                                    ),

                                    SizedBox(

                                      width: 10,

                                    ),

                                    Container(

                                        width: 220,

                                        child: Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [

                                            Row(

                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                              children: [

                                                Flexible(

                                                    child: Column(

                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: [

                                                    Text(

                                                      dataList.child("name").value.toString(),

                                                      textAlign: TextAlign.center,

                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: secondryColor),

                                                    ),

                                                    Text(

                                                      dataList.child("type").value.toString(),

                                                      textAlign: TextAlign.center,

                                                      style: TextStyle(fontSize: 10, color: secondryColor),

                                                    ),

                                                  ],

                                                )),


                                                Text(stateOrder[int.parse(dataList.child("state").value.toString())]),


                                                // Expanded(child: SizedBox()),

                                              ],

                                            ),

                                          ],

                                        )),


                                    /*  MaterialButton(

                                    height: 30,

                                    shape: CircleBorder(),

                                    color: Colors.grey.withOpacity(0.5),

                                    onPressed: () {

                                     

                                      /*  dataList.ref.remove().then((value) {

                                        AppWidget().itemMessage("Eliminado", context);

                                        setState(() {});

                                      });*/

                                    },

                                    child: Icon(

                                      Icons.more_vert_rounded,

                                    ))*/

                                  ],

                                )));

                      });

            } else {

              return Text("Cargando");

            }


            ;

          } catch (e) {

            return Text("Cargando");

          }

        });

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

                  SvgPicture.asset(

                    "images/icons/miprofile6.svg",

                    color: secondryColor,

                    width: 32,

                  ),

                  SizedBox(

                    width: 10,

                  ),

                  Container(

                      child: Text(

                    "Lista de soporte",

                    style: TextStyle(

                      color: secondryColor,

                      fontSize: 20,

                      fontWeight: FontWeight.bold,

                    ),

                  )),

                  Expanded(child: SizedBox()),

                  GestureDetector(

                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => SupportAppPage()));

                      },

                      child: Container(

                          width: 40,

                          height: 40,

                          padding: EdgeInsets.all(7),

                          decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),

                          child: SvgPicture.asset("images/icons/add.svg"))),

                ],

              ),

              SizedBox(

                height: 50,

              ),

              stateIndicator0(),

            ],

          ),

        ),

      ),

    );

  }

}


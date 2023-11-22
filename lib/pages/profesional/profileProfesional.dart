import 'dart:convert';


import 'dart:io';


import 'package:connectivity_plus/connectivity_plus.dart';


import 'package:dotted_border/dotted_border.dart';


import 'package:file_picker/file_picker.dart';


import 'package:firebase_auth/firebase_auth.dart';


import 'package:firebase_database/firebase_database.dart';


import 'package:flutter/material.dart';


import 'package:flutter_locales/flutter_locales.dart';


import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import 'package:flutter_svg/flutter_svg.dart';


import 'package:fullpro/PROFESIONAL/models/partner.dart';


import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';


import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';


import 'package:fullpro/PROFESIONAL/views/Authentication/country_picker.dart';


import 'package:fullpro/PROFESIONAL/widget/widget.dart';


import 'package:fullpro/config.dart';


import 'package:fullpro/controller/loader.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


import 'package:fullpro/pages/homepage.dart';


import 'package:fullpro/styles/statics.dart';


import 'package:fullpro/utils/countryStateCity/AddressPickerRow.dart';


import 'package:fullpro/widgets/widget.dart';


import '../../styles/styles.dart';


import '../styles/statics.dart' as Static;


class ProfileProfesionalPage extends StatefulWidget {

  const ProfileProfesionalPage({Key? key}) : super(key: key);


  @override

  State<ProfileProfesionalPage> createState() => _ProfileProfesionalPageState();

}


String nameProfesional = "";


int stateIndicator = 0;


class _ProfileProfesionalPageState extends State<ProfileProfesionalPage> {

  bool agree = false;


  List<File> fileLicense = [];


  List<File> fileBackgroundCheck = [];


  bool signUpNext = false;


  List<File> fileRegistroLegal = [];


  bool licenceCheck = false;


  bool backgroundCheck = false;


  bool registroCheck = false;


  TextEditingController country = TextEditingController();


  TextEditingController state = TextEditingController();


  TextEditingController city = TextEditingController();


  TextEditingController nameController = TextEditingController();


  TextEditingController dateController = TextEditingController();


  TextEditingController emailController = TextEditingController();


  TextEditingController phoneController = TextEditingController();


  TextEditingController passwordController = TextEditingController();


  @override

  Widget build(BuildContext context) {

    return Scaffold(

        appBar: appbarProfessional(context, true),

        backgroundColor: Colors.white,

        body: ListView(

          children: [

            Stack(

              children: [

                Container(

                  width: double.infinity,

                  height: 130,

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

                              height: 60,

                            ),

                            CircleAvatar(

                              radius: 65,

                              backgroundColor: Colors.grey.withOpacity(0.5),

                            ),

                            Text(

                              nameProfesional,

                              style: TextStyle(color: secondryColor, fontSize: 18, fontWeight: FontWeight.bold),

                            ),

                            SizedBox(

                              height: 5,

                            ),

                            RatingBarIndicator(

                                rating: 2.5,

                                itemCount: 5,

                                itemSize: 30.0,

                                itemBuilder: (context, _) => Icon(

                                      Icons.star_border_rounded,

                                      color: secondryColor,

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

    return FutureBuilder(

        initialData: 1,

        future: FirebaseDatabase.instance.ref().child('comments').once(),

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


                        return Container(

                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),

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

                                    dataList.child("usuario").value.toString(),

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

                                        dataList.child("value").value.toString(),

                                        style: TextStyle(fontSize: 10),

                                      )),

                                  SizedBox(

                                    height: 14,

                                  ),

                                ],

                              ))

                            ],

                          ),

                        );

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


  var _dialCode = '';


  void _callBackFunction(String name, String dialCode, String flag) {

    _dialCode = dialCode;

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

      Container(

          margin: EdgeInsets.only(left: 20, right: 20),

          child: CountryStateCityPickerRow(

            country: country,

            state: state,

            city: city,

            textFieldInputBorder: const UnderlineInputBorder(),

          )),

      Text("Licencias"),

      SizedBox(

        height: 5,

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

                                "Foto: " + index.toString(),

                                style: TextStyle(color: Colors.white, fontSize: 10),

                              ),

                              Text(

                                "291 KB",

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


      /* Row(
          children: [
            kkk
           
          ],
        ),*/


      SizedBox(

        height: 5,

      ),

      Container(

          margin: EdgeInsets.only(left: 20, right: 20),

          child: Column(

            children: [

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

                height: 10,

              ),

              Text("Background check"),

              fileBackgroundCheck.length == 0

                  ? SizedBox()

                  : Container(

                      height: 40,

                      child: ListView.builder(

                          padding: EdgeInsets.only(left: 10.0),

                          itemCount: fileBackgroundCheck.length,

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

                                        fileBackgroundCheck.removeAt(0);


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

                                        "Foto: " + index.toString(),

                                        style: TextStyle(color: Colors.white, fontSize: 10),

                                      ),

                                      Text(

                                        "291 KB",

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

                      fileBackgroundCheck.add(File(result.files.single.path!));


                      backgroundCheck = false;

                    } else {

                      // User canceled the picker

                    }


                    setState(() {});

                  },

                  child: DottedBorder(

                    color: backgroundCheck ? Colors.red : Colors.grey,

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

                height: 10,

              ),

              Text("Registro legal w9"),

              fileRegistroLegal.length == 0

                  ? SizedBox()

                  : Container(

                      height: 40,

                      child: ListView.builder(

                          padding: EdgeInsets.only(left: 10.0),

                          itemCount: fileRegistroLegal.length,

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

                                        fileRegistroLegal.removeAt(0);


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

                                        "Foto: " + index.toString(),

                                        style: TextStyle(color: Colors.white, fontSize: 10),

                                      ),

                                      Text(

                                        "291 KB",

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

                      fileRegistroLegal.add(File(result.files.single.path!));


                      registroCheck = false;

                    } else {

                      // User canceled the picker

                    }


                    setState(() {});

                  },

                  child: DottedBorder(

                    color: registroCheck ? Colors.red : Colors.grey,

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

            ],

          )),


      /* CountryPicker(
        callBackFunction: _callBackFunction,
        headerText: Locales.string(context, 'lbl_select_country'),
        headerBackgroundColor: Theme.of(context).primaryColor,
        headerTextColor: Colors.white,
      ),*/


      /* Row(

        children: [

          Flexible(child: AppWidget().textFieldForm(context, passwordController, "Contraseña")),

          Flexible(child: AppWidget().textFieldForm(context, passwordController, "Contraseña")),

        ],

      ),*/


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


  void getUserInfo() async {

    currentFirebaseUser = FirebaseAuth.instance.currentUser;


    String? userid = currentFirebaseUser?.uid;


    if (UserPreferences.getUsername() != null && UserPreferences.getUserPhone() != null) {

      nameController.text = UserPreferences.getUsername() ?? '';


      phoneController.text = UserPreferences.getUserPhone() ?? '';

    } else {

      final userRef = FirebaseDatabase.instance.ref().child("partners").child(userid!);


      userRef.once().then((e) async {

        final _datasnapshot = e.snapshot;


        if (_datasnapshot.value != null) {

          currentPartnerInfo = Partner.fromSnapshot(_datasnapshot);


          if (mounted) {

            var connectivityResults = await Connectivity().checkConnectivity();


            if (connectivityResults != ConnectivityResult.mobile && connectivityResults != ConnectivityResult.wifi) {

              //


              ScaffoldMessenger.of(context).showSnackBar(

                SnackBar(

                  content: Text(

                    Locales.string(context, 'error_no_internet'),

                  ),

                ),

              );

            } else {

              setState(() {

                if (UserPreferences.getUsername() == null) {

                  nameProfesional = currentPartnerInfo!.fullName.toString();


                  setState(() {});


                  nameController.text = currentPartnerInfo!.fullName.toString();


                  emailController.text = currentPartnerInfo!.email.toString();

                } else {

                  nameController.text = UserPreferences.getUsername() ?? '';

                }


                if (UserPreferences.getUserPhone() == null) {

                  phoneController.text = currentPartnerInfo!.phone.toString();

                } else {

                  phoneController.text = UserPreferences.getUserPhone() ?? '';

                }

              });

            }

          }

        }

      });

    }

  }


  @override

  void initState() {

    // TODO: implement initState


    super.initState();


    getUserInfo();

  }


  Widget portafolio() {

    return FutureBuilder(

        initialData: 1,

        future: FirebaseDatabase.instance.ref().child('portafolio').child("alex").once(),

        builder: (BuildContext context, AsyncSnapshot snapshot) {

          try {

            if (snapshot.hasData && snapshot.data != null) {

              DatabaseEvent response;


              response = snapshot.data;


              return response == null

                  ? Text("Cargando")

                  : Container(

                      width: double.infinity,

                      height: 300,

                      child: AlignedGridView.count(

                        crossAxisCount: 3,

                        itemCount: response.snapshot.children.length,

                        mainAxisSpacing: 2,

                        crossAxisSpacing: 2,

                        itemBuilder: (context, index) {

                          DataSnapshot dataList = response.snapshot.children.toList()[index];


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

                                          dataList.child("value").value.toString(),

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

            } else {

              return Text("Cargando");

            }


            ;

          } catch (e) {

            return Text("Cargando");

          }

        });

  }

}


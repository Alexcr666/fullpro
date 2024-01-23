import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'dart:io';

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:fullpro/pages/INTEGRATION/models/user_model.dart' as userD;
import 'package:file_picker/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';

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
import 'package:fullpro/pages/INTEGRATION/Chat/Matches.dart';
import 'package:fullpro/pages/INTEGRATION/Chat/chatPage.dart';
import 'package:fullpro/pages/INTEGRATION/Chat/home_screen.dart';
import 'package:fullpro/pages/INTEGRATION/models/user_model.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/pages/subServicePage.dart';

import 'package:fullpro/styles/statics.dart';

import 'package:fullpro/utils/countryStateCity/AddressPickerRow.dart';
import 'package:fullpro/utils/utils.dart';
import 'package:fullpro/widgets/bottomNav.dart';

import 'package:fullpro/widgets/widget.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../styles/styles.dart';

import '../styles/statics.dart' as Static;

class ProfileProfesionalPage extends StatefulWidget {
  ProfileProfesionalPage({Key? key, required this.id, this.settings}) : super(key: key);

  String? id;
  bool? settings;

  @override
  State<ProfileProfesionalPage> createState() => _ProfileProfesionalPageState();
}

String nameProfesional = "";

int stateIndicator = 0;

DataSnapshot? _userDataProfile = null;
Iterable<DataSnapshot>? dataListObjectOrdens;
TextEditingController priceController = TextEditingController();

class _ProfileProfesionalPageState extends State<ProfileProfesionalPage> {
  Widget itemOptionProfileOptions(String title, String url, {String? subtitle, Function? onTap}) {
    return GestureDetector(
        onTap: () {
          onTap!();
        },
        child: Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  url,
                  width: 35,
                  //  color: secondryColor,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                  style: TextStyle(color: secondryColor, fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Expanded(child: SizedBox()),
                subtitle == null
                    ? SizedBox()
                    : Text(
                        subtitle,
                        style: TextStyle(color: secondryColor, fontSize: 19, fontWeight: FontWeight.bold),
                      ),
              ],
            )));
  }

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

  TextEditingController professionController = TextEditingController();

  String imageUser = "";

  // TextEditingController passwordController = TextEditingController();
  double _currentSliderValue = 20;
  Widget pageOrdens() {
    return FutureBuilder(
        future: FirebaseDatabase.instance.ref().child('ordens').orderByChild("professional").equalTo(widget.id.toString()).once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            dataListObjectOrdens = response.snapshot.children;
            DataSnapshot? dataListObject = null;

            //   for (var i = 0; i < response.snapshot.children.toList().length; i++) {

            //return Text(dataListObject!.child("name").value.toString());

            return response.snapshot.children.toList().length == 0
                ? AppWidget().noResult()
                : Container(
                    width: double.infinity,
                    height: 120,
                    child: ListView.builder(
                        padding: EdgeInsets.only(left: 10.0),
                        itemCount: response.snapshot.children.toList().length,
                        scrollDirection: Axis.horizontal,

                        //  physics: NeverScrollableScrollPhysics(),

                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int i) {
                          DataSnapshot dataList = response.snapshot.children.toList()[i];

                          return /*dataList.child("user").value.toString() == "LapnDojkb8QGfSOioTXLkiPAiNt2"

                      ? SizedBox()

                      :*/

                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 110,
                                          decoration: AppWidget().boxShandowGreyRectangule(),
                                          padding: EdgeInsets.only(left: 30, right: 20, top: 15, bottom: 15),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dataList.child("name").value.toString().capitalize(),
                                                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    dataList.child("price").value == null
                                                        ? '\$ ' + "0"
                                                        : '\$ ' +
                                                            MoneyFormatter(amount: double.parse(dataList.child("price").value.toString()))
                                                                .output
                                                                .withoutFractionDigits
                                                                .toString(),
                                                    style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    dataList.child("description").value == null
                                                        ? "No disponible"
                                                        : dataList.child("description").value.toString(),
                                                    style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
                                                  ),

                                                  /*  Text(

                                    "+8,956",

                                    style: TextStyle(color: secondryColor, fontSize: 15, fontWeight: FontWeight.bold),

                                  ),*/
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
                                  ));
                        }));
          } else {
            // }

            return AppWidget().loading();
          }
        });
  }

  Widget pageOrdensHistory() {
    return FutureBuilder(

        //   kkk

        future: FirebaseDatabase.instance.ref().child('ordens').orderByChild("professional").equalTo(widget.id.toString()).once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            DataSnapshot? dataListObject = null;

            //   for (var i = 0; i < response.snapshot.children.toList().length; i++) {

            //return Text(dataListObject!.child("name").value.toString());

            return response == null
                ? AppWidget().loading()
                : response.snapshot.children.toList().length == 0
                    ? AppWidget().noResult()
                    : Container(

                        // width: double.infinity,

                        // height: 300,
                        child: ListView.builder(
                            padding: EdgeInsets.only(left: 10.0),
                            itemCount: response.snapshot.children.toList().length,

                            // scrollDirection: Axis.horizontal,

                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              DataSnapshot dataList = response.snapshot.children.toList()[i];

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
                                            dataList.child("name").value == null
                                                ? "No disponible"
                                                : dataList.child("name").value.toString().capitalize(),
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
                                          Flexible(
                                              child: Text(
                                            dataList.child("address").value == null
                                                ? "No disponible"
                                                : dataList.child("address").value.toString().capitalize(),
                                            maxLines: 1,
                                            style: TextStyle(color: secondryColor, fontSize: 12),
                                          )),
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
                                            dataList.child("price").value == null
                                                ? '\$' + "0"
                                                : '\$' +
                                                    MoneyFormatter(amount: double.parse(dataList.child("price").value.toString()))
                                                        .output
                                                        .withoutFractionDigits
                                                        .toString(),
                                            style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }

                              Widget itemSpacing() {
                                return Container(

                                    // decoration: AppWidget().borderColor(),

                                    width: 170,
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                    height: 105,
                                    child: SizedBox());
                              }

//(i / 2).toString().contains(".5")

                              return Row(
                                children: [
                                  SizedBox(
                                    width: 7,
                                  ),
                                  (i / 2).toString().contains(".5") == false ? itemSpacing() : itemHistory(),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    children: [
                                      dataList!.child("user").value == null
                                          ? AppWidget().loading()
                                          : FutureBuilder(
                                              future: FirebaseDatabase.instance
                                                  .ref()
                                                  .child('users')
                                                  .child(dataList!.child("user").value.toString())
                                                  .once(),
                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                late DatabaseEvent response;
                                                if (snapshot.hasData) {
                                                  response = snapshot.data;
                                                }
                                                return snapshot.hasData != true
                                                    ? AppWidget().loading()
                                                    : AppWidget()
                                                        .circleProfile(response.snapshot.child("photo").value.toString(), size: 40);
                                              }),
                                      (i + 1) == response.snapshot.children.toList().length
                                          ? Container(
                                              height: 100,
                                              width: 1,
                                              //   color: Colors.black.withOpacity(0.2),
                                            )
                                          : Container(
                                              height: 100,
                                              width: 1,
                                              color: Colors.black.withOpacity(0.2),
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  (i / 2).toString().contains(".5") == true ? itemSpacing() : itemHistory(),
                                ],
                              );
                            }));
          } else {
            return AppWidget().loading();
          }

          // }
        });
  }

  Widget statePoratolfio() {
    return FutureBuilder(

        // initialData: 1,

        future: FirebaseDatabase.instance.ref().child('portafolio').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;

              return response == null ? AppWidget().loading() : SizedBox();
            } else {
              return AppWidget().loading();
            }

            ;
          } catch (e) {
            return AppWidget().loading();
          }
        });
  }

  clickPhoto() async {
    ImagePicker imagePicker = ImagePicker();

    var image = await imagePicker.pickImage(source: ImageSource.gallery);

    FirebaseAuth user = FirebaseAuth.instance;

    int timestamp = new DateTime.now().millisecondsSinceEpoch;

    Reference storageReference =
        FirebaseStorage.instance.ref().child('partners/' + user.currentUser!.uid.toString() + timestamp.toString() + '.jpg');

    UploadTask uploadTask = storageReference.putFile(File(image!.path));
    AppWidget().itemMessage("Subiendo foto...", context);
    await uploadTask.then((p0) async {
      String fileUrl = await storageReference.getDownloadURL();

      //  log("urlfile: " + fileUrl.toString());

      // userProfileData.child("photo")

      _userDataProfile!.ref.update({'photo': fileUrl}).then((value) {
        //  Navigator.pop(context);

        setState(() {});

        AppWidget().itemMessage("Foto actualizada", context);
      }).catchError((onError) {
        AppWidget().itemMessage("Error al actualizar foto", context);
      });

      //   _sendImage(messageText: 'Photo', imageUrl: fileUrl);
    }).catchError((onError) {
      print("error: " + onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarProfessional(context, true),
        backgroundColor: Colors.white,
        body: _userDataProfile == null
            ? AppWidget().loading()
            : ListView(
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
                                  GestureDetector(
                                      onTap: () {
                                        clickPhoto();
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                              height: 120,
                                              width: 120,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(90),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: imageUser ?? '',
                                                  useOldImageOnUrlChange: true,
                                                  placeholder: (context, url) => CupertinoActivityIndicator(
                                                    radius: 20,
                                                    color: Colors.grey.withOpacity(0.3),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    color: Colors.grey.withOpacity(0.4),
                                                  ),
                                                ),
                                              )),
                                          Positioned.fill(
                                              child: Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),
                                                      child: Icon(
                                                        Icons.camera_alt_outlined,
                                                        color: Colors.white,
                                                      )))),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    nameProfesional.capitalize(),
                                    style: TextStyle(color: secondryColor, fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  RatingBarIndicator(
                                      rating: _userDataProfile!.child("rating").value == null
                                          ? 0
                                          : double.parse(_userDataProfile!.child("rating").value.toString()),
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
                  FirebaseAuth.instance.currentUser!.uid.toString() == widget.id
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Container(
                                    width: 170,
                                    child: AppWidget().buttonFormLine(
                                        context,
                                        FirebaseAuth.instance.currentUser!.uid.toString() == widget.id ? "Editar perfil" : "Solicitar",
                                        false, tap: () {
                                      if (FirebaseAuth.instance.currentUser!.uid.toString() == widget.id) {
                                        stateIndicator = 4;
                                        setState(() {});
                                      } else {
                                        createOrdens(context,
                                            name: "Tecnp",
                                            inspections: "si",
                                            profesionalName: nameProfesional,
                                            profesional: userDataProfile!.key.toString(),
                                            price: 1000);
                                      }
                                    }))),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  if (FirebaseAuth.instance.currentUser!.uid.toString() == widget.id) {
                                    List<userD.User> result = LinkedHashSet<userD.User>.from(matches).toList();

                                    List<userD.User> newMatchesResult = LinkedHashSet<userD.User>.from(newmatches).toList();
// => ["a", "b", "c", "d"]
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen(currentUser!, result, newMatchesResult)),
                                    );
                                  }
                                  /* CollectionReference users = FirebaseFirestore.instance
                      .collection('Users')
                      .doc("Mkoc6GZaIWMf6yO2mDAHlZucj9V2" /*FirebaseAuth.instance.currentUser!.uid.toString()*/)
                      .collection("Matches");

                  Future<void> addUser() {
                    // Call the user's CollectionReference to add a new user
                    return users.add({
                      'Matches': userDataProfile!.key.toString(), // John Doe
                      'isRead': true,
                      'userName': "alex c",
                      // Stokes and Sons
                      'name': userDataProfile!.child("fullname").value.toString() // 42
                    }).then((value) {
                      AppWidget().itemMessage("Creado", context);
                    }).catchError((error) {
                      AppWidget().itemMessage("Error al crear", context);
                    });*/

                                  //CollectionReference users = FirebaseFirestore.instance.collection('Users');
/*
                            addMatches() {
                              DocumentReference usersValidate2 = FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                  .collection("Matches")
                                  .doc(_userDataProfile!.key.toString());

                              addMatch() {
                                usersValidate2.set({
                                  'Matches': _userDataProfile!.key.toString(), // John Doe
                                  'UserName': _userDataProfile!.child("fullname").value.toString(),
                                  'userId': _userDataProfile!.key.toString(),
                                }).then((value) {
                                  AppWidget().itemMessage("Creado", context);

                                  Future.delayed(const Duration(milliseconds: 1200), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen(currentUser!, matches, newmatches)),
                                    );
                                  });
                                }).catchError((error) {
                                  AppWidget().itemMessage("Error al crear", context);
                                });
                              }

                              usersValidate2.get().then((value) {
                                if (value.exists == false) {
                                  addMatch();
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeScreen(currentUser!, matches, newmatches)),
                                  );
                                }
                              });
                            }

                            DocumentReference usersValidate =
                                FirebaseFirestore.instance.collection('Users').doc(_userDataProfile!.key.toString());

                            addUser() {
                              usersValidate.get().then((value) {
                                if (value.exists) {
                                  addMatches();
                                } else {
                                  usersValidate.set({
                                    'Matches': _userDataProfile!.key.toString(), // John Doe

                                    'UserName': _userDataProfile!.child("fullname").value.toString(),
                                    'userId': _userDataProfile!.key.toString(),
                                  }).then((value) {
                                    AppWidget().itemMessage("Creado", context);
                                    addMatches();
                                  }).catchError((error) {
                                    AppWidget().itemMessage("Error al crear", context);
                                  });
                                  usersValidate.collection("Matches").doc(_userDataProfile!.key.toString()).set({
                                    'Matches': _userDataProfile!.key.toString(), // John Doe

                                    'UserName': _userDataProfile!.child("fullname").value.toString(),
                                    'userId': _userDataProfile!.key.toString(),
                                  }).then((value) {
                                    AppWidget().itemMessage("Creado", context);
                                    addMatches();
                                  }).catchError((error) {
                                    AppWidget().itemMessage("Error al crear", context);
                                  });
                                }
                              });

                              // Call the user's CollectionReference to add a new user
                              /* return users.add({
                          'Matches': userDataProfile!.key.toString(), // John Doe
                          //  'isRead': true,
                          'UserName': userDataProfile!.child("fullname").value.toString(),
                          'userId': userDataProfile!.key.toString(),
                          // Stokes and Sons
                          // 'name': userDataProfile!.child("fullname").value.toString() // 42
                        }).then((value) {
                          AppWidget().itemMessage("Creado", context);
                        }).catchError((error) {
                          AppWidget().itemMessage("Error al crear", context);
                        });*/
                            }

                            addUser();*/
                                  //  kkk
                                },
                                child: Icon(
                                  Icons.message,
                                  size: 40,
                                  color: secondryColor,
                                )),
                          ],
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  pageOrdens(),
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
                              FirebaseAuth.instance.currentUser!.uid.toString() != widget.id
                                  ? SizedBox()
                                  : AppWidget().buttonShandowRounded("Historial", stateIndicator != 3, tap: () {
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
    bool emptyResult = false;
    return dataListObjectOrdens == null
        ? AppWidget().loading()
        : dataListObjectOrdens!.length == 0
            ? AppWidget().noResult()
            : ListView.builder(
                itemCount: dataListObjectOrdens!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  DataSnapshot dataList = dataListObjectOrdens!.toList().reversed.toList()[index];

                  if (dataList.child("rating").value == 0) {
                    emptyResult = true;
                  }

                  return dataList.child("rating").value == 0
                      ? (index == dataListObjectOrdens!.length)
                          ? SizedBox()
                          : emptyResult == false
                              ? SizedBox()
                              : AppWidget().noResult()
                      : Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          decoration: AppWidget().boxShandowGreyRectangule(),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
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
                                  dataList!.child("user").value == null
                                      ? SizedBox()
                                      : FutureBuilder(
                                          future: FirebaseDatabase.instance
                                              .ref()
                                              .child('users')
                                              .child(dataList!.child("user").value.toString())
                                              .once(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            late DatabaseEvent response;
                                            if (snapshot.hasData) {
                                              response = snapshot.data;
                                            } else {}
                                            return snapshot.hasData == false
                                                ? AppWidget().loading()
                                                : Row(
                                                    children: [
                                                      Flexible(
                                                          child: AppWidget()
                                                              .circleProfile(response.snapshot.child("photo").value.toString(), size: 50)),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              response.snapshot.child("fullname").value == null
                                                                  ? "No disponible"
                                                                  : response.snapshot.child("fullname").value.toString(),
                                                              style: TextStyle(
                                                                  color: secondryColor, fontSize: 17, fontWeight: FontWeight.bold),
                                                            ),
                                                            RatingBarIndicator(
                                                                rating: response.snapshot.child("rating").value == null
                                                                    ? 0
                                                                    : double.parse(response.snapshot.child("rating").value.toString()),
                                                                itemCount: 5,
                                                                itemSize: 16.0,
                                                                itemBuilder: (context, _) => Icon(
                                                                      Icons.star,
                                                                      color: secondryColor,
                                                                    )),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  );
                                          }),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  /*Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              dataList.child("comment").value == null ? "" : dataList.child("comment").value.toString(),
                              style: TextStyle(fontSize: 10),
                            )),*/
                                  SizedBox(
                                    height: 14,
                                  ),
                                ],
                              ))
                            ],
                          ),
                        );
                });
  }

/*
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
  }*/

  var _dialCode = '';
  final formkey = GlobalKey<FormState>();

  void _callBackFunction(String name, String dialCode, String flag) {
    _dialCode = dialCode;
  }

  uploadFile(String doc) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // fileBackgroundCheck.add(File(result.files.single.path!));

      int timestamp = new DateTime.now().millisecondsSinceEpoch;

      Reference storageReference = FirebaseStorage.instance.ref().child("filesdoc/" + timestamp.toString() + ".jpg");

      UploadTask uploadTask = storageReference.putFile(File(result.files.single.path!));

      await uploadTask.then((p0) async {
        String fileUrl = await storageReference.getDownloadURL();

        _userDataProfile!.ref.update({doc: fileUrl}).then((value) {
          setState(() {});

          AppWidget().itemMessage("Archivo subido", context);
        });
      });

      backgroundCheck = false;
    } else {
      // User canceled the picker
    }

    setState(() {});
  }

  Widget stateIndicator4() {
    return Column(children: [
      SizedBox(
        height: 20,
      ),

      /*  Row(
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
      ),*/

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
      Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Form(
              key: formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  AppWidget().texfieldFormat(
                      controller: nameController,
                      title: "Nombre Completo",
                      enabled: FirebaseAuth.instance.currentUser!.uid == widget.id ? false : true),
                  SizedBox(
                    height: 10,
                  ),
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

                                                  dateController.text = f.format(val);
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
                      child: AppWidget().texfieldFormat(title: "Fecha de nacimiento", controller: dateController, enabled: true)),
                  SizedBox(
                    height: 10,
                  ),
                  AppWidget().texfieldFormat(
                      controller: emailController,
                      title: "Correo electronico",
                      enabled: FirebaseAuth.instance.currentUser!.uid == widget.id ? false : true),
                  SizedBox(
                    height: 10,
                  ),
                  AppWidget().texfieldFormat(
                      controller: phoneController,
                      title: "Celular",
                      enabled: FirebaseAuth.instance.currentUser!.uid == widget.id ? false : true),
                  SizedBox(
                    height: 10,
                  ),
                  AppWidget().texfieldFormat(
                      controller: professionController,
                      title: "Profesión",
                      enabled: FirebaseAuth.instance.currentUser!.uid == widget.id ? false : true),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ))),
      FirebaseAuth.instance.currentUser!.uid.toString() != widget.id
          ? SizedBox()
          : Column(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: CountryStateCityPickerRow(
                      country: country,
                      state: state,
                      city: city,
                      textFieldInputBorder: const UnderlineInputBorder(),
                    )),

                SizedBox(
                  height: 10,
                ),

                /*  Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: AppWidget().texfieldFormat(
            controller: priceController,
            title: "Precio",
            enabled: FirebaseAuth.instance.currentUser!.uid == widget.id ? false : true,
          )),*/
                SizedBox(
                  height: 10,
                ),
                Container(margin: EdgeInsets.only(left: 20), alignment: Alignment.centerLeft, child: Text("Licencias")),

                SizedBox(
                  height: 10,
                ),

                // _userDataProfile.child("licence") == null

                _userDataProfile!.child("license").value == null
                    ? AppWidget().noResult()
                    : Container(
                        height: 40,
                        child: ListView.builder(
                            padding: EdgeInsets.only(left: 10.0),
                            itemCount: 1,
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
                                          AppWidget().optionsEnabled("¿Seguro quieres eliminar?", context, tap: () {
                                            _userDataProfile!.ref.child("license").remove().then((value) {
                                              setState(() {});
                                            }).catchError((onError) {
                                              print("error: " + onError.toString());
                                            });

                                            setState(() {});
                                          }, tap2: () {
                                            Navigator.pop(context);
                                          });
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
                                    GestureDetector(
                                        onTap: () async {
                                          final Uri url = Uri.parse(_userDataProfile!.child("license").value.toString());
                                          if (!await launchUrl(url)) {
                                            throw Exception('Could not launch _url');
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          size: 30,
                                          color: Colors.black.withOpacity(0.4),
                                        )),
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
                        FirebaseAuth.instance.currentUser!.uid != widget.id
                            ? SizedBox()
                            : GestureDetector(
                                onTap: () async {
                                  /*   FilePickerResult? result = await FilePicker.platform.pickFiles();


                    if (result != null) {

                      fileLicense.add(File(result.files.single.path!));


                      licenceCheck = false;


                      setState(() {});

                    } else {

                      // User canceled the picker

                    }*/

                                  uploadFile("license");
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
                        Container(margin: EdgeInsets.only(left: 3), alignment: Alignment.centerLeft, child: Text("Background check")),
                        SizedBox(
                          height: 10,
                        ),
                        _userDataProfile!.child("background").value == null
                            ? AppWidget().noResult()
                            : Container(
                                height: 40,
                                child: ListView.builder(
                                    padding: EdgeInsets.only(left: 10.0),
                                    itemCount: 1,
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
                                                  AppWidget().optionsEnabled("¿Seguro quieres eliminar?", context, tap: () {
                                                    Navigator.pop(context);
                                                    _userDataProfile!.ref.child("background").remove().then((value) {
                                                      setState(() {});
                                                    });

                                                    setState(() {});
                                                  }, tap2: () {
                                                    Navigator.pop(context);
                                                  });
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
                                            GestureDetector(
                                                onTap: () async {
                                                  final Uri url = Uri.parse(_userDataProfile!.child("background").value.toString());
                                                  if (!await launchUrl(url)) {
                                                    throw Exception('Could not launch _url');
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.black.withOpacity(0.4),
                                                  size: 30,
                                                )),
                                          ],
                                        ),
                                      );
                                    })),
                        SizedBox(
                          height: 5,
                        ),
                        FirebaseAuth.instance.currentUser!.uid != widget.id
                            ? SizedBox(
                                height: 10,
                              )
                            : GestureDetector(
                                onTap: () async {
                                  uploadFile("background");
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
                        Container(margin: EdgeInsets.only(left: 3), alignment: Alignment.centerLeft, child: Text("Registro legal w9")),
                        SizedBox(
                          height: 10,
                        ),
                        _userDataProfile!.child("legal").value == null
                            ? AppWidget().noResult()
                            : Container(
                                height: 40,
                                child: ListView.builder(
                                    padding: EdgeInsets.only(left: 10.0),
                                    itemCount: 1,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        width: 150,
                                        margin: EdgeInsets.only(left: 5),
                                        padding: EdgeInsets.all(2),
                                        alignment: Alignment.centerLeft,
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
                                                  AppWidget().optionsEnabled("¿Seguro quieres eliminar?", context, tap: () {
                                                    Navigator.pop(context);
                                                    _userDataProfile!.ref.child("legal").remove().then((value) {
                                                      setState(() {});
                                                    });

                                                    setState(() {});
                                                  }, tap2: () {
                                                    Navigator.pop(context);
                                                  });
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
                                            GestureDetector(
                                                onTap: () async {
                                                  final Uri url = Uri.parse(_userDataProfile!.child("legal").value.toString());
                                                  if (!await launchUrl(url)) {
                                                    throw Exception('Could not launch _url');
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.black.withOpacity(0.4),
                                                  size: 30,
                                                )),
                                          ],
                                        ),
                                      );
                                    })),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
                FirebaseAuth.instance.currentUser!.uid != widget.id
                    ? SizedBox(
                        height: 10,
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: GestureDetector(
                            onTap: () async {
                              /* FilePickerResult? result = await FilePicker.platform.pickFiles();


                    if (result != null) {

                      fileRegistroLegal.add(File(result.files.single.path!));


                      registroCheck = false;

                    } else {

                      // User canceled the picker

                    }


                    setState(() {});*/

                              uploadFile("legal");
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
                            ))),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: itemOptionProfileOptions("Radio de busqueda", "images/icons/locationCircle.svg",
                      subtitle: _currentSliderValue.round().toString() + " KM"),
                ),
                Slider(
                  value: _currentSliderValue,
                  max: 100,
                  activeColor: secondryColor,
                  divisions: 5,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: AppWidget().buttonFormColor(context, "Guardar", secondryColor, tap: () {
                      if (_userDataProfile!.child("legal") == null && _userDataProfile!.child("background") == null) {
                        AppWidget().itemMessage("Error al actualizar foto", context);
                      } else {
                        AppWidget().itemMessage("Error al actualizar foto", context);
                      }

                      if (formkey.currentState!.validate()) {
                        _userDataProfile!.ref.update({
                          'fullname': nameController.text.toString(),
                          'date': dateController.text.toString(),
                          'email': emailController.text.toString(),
                          'phone': phoneController.text.toString(),
                          'state': state.text.toString(),
                          'city': city.text.toString(),
                          'radio': _currentSliderValue.round().toString(),
                          'price': priceController.text.toString(),
                          'country': country.text.toString(),
                        }).then((value) {
                          AppWidget().itemMessage("Información actualizada", context);
                        }).catchError((onError) {
                          print("error: " + onError.toString());
                          AppWidget().itemMessage("Error al actualizar foto", context);
                        });
                      } else {
                        AppWidget().itemMessage("Faltan campos", context);
                      }
                    })),
                SizedBox(
                  height: 30,
                ),
              ],
            ),

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
        pageOrdensHistory(),

        /*  Row(
          children: [
            SizedBox(
              width: 7,
            ),

            pageOrdensHistory(),
            // itemHistory(),
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
        )*/
      ],
    );
  }

  void getUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    String? userid = currentFirebaseUser?.uid;

/*
    if (UserPreferences.getUsername() != null && UserPreferences.getUserPhone() != null) {

      nameController.text = UserPreferences.getUsername() ?? '';


      phoneController.text = UserPreferences.getUserPhone() ?? '';

    } else {*/

    final userRef = FirebaseDatabase.instance.ref().child("partners").child(userid!);

    userRef.once().then((e) async {
      final _datasnapshot = e.snapshot;

      if (_datasnapshot.value != null) {
        _userDataProfile = _datasnapshot;

        professionController.text = _datasnapshot.child("price").value.toString();

        professionController.text = _datasnapshot.child("profesion").value.toString();

        country.text = _datasnapshot.child("country").value.toString();

        state.text = _datasnapshot.child("state").value.toString();

        country.text = _datasnapshot.child("country").value.toString();

        city.text = _datasnapshot.child("city").value.toString();
      }
    });

    // }
  }

  void getProfile(String id) {
    final UserRef = FirebaseDatabase.instance.ref().child("partners").child(id);

    UserRef.once().then((e) async {
      final dataSnapshot = e.snapshot;

      _userDataProfile = e.snapshot;

      if (dataSnapshot.child("fullname").value != null) {
        nameProfesional = dataSnapshot.child("fullname").value.toString();
        _currentSliderValue = double.parse(dataSnapshot.child("radio").value.toString());

        nameController.text = dataSnapshot.child("fullname").value.toString();

        nameController.text = dataSnapshot.child("fullname").value.toString();

        emailController.text = dataSnapshot.child("email").value.toString();
        dateController.text = dataSnapshot.child("dateBirthay").value.toString();

        phoneController.text = dataSnapshot.child("phone").value.toString();

        imageUser = dataSnapshot.child("photo").value.toString();

        professionController.text = dataSnapshot.child("profesion").value.toString();

        country.text = dataSnapshot.child("country").value.toString();

        state.text = dataSnapshot.child("state").value.toString();

        country.text = dataSnapshot.child("country").value.toString();

        city.text = dataSnapshot.child("city").value.toString();

        setState(() {});
      } else {}
    });

    setState(() {});

/*    UserRef.once().then((e) async {
      final dataSnapshot = e.snapshot;

     
    });*/
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.ref("partners/" + widget.id.toString());

    Stream<DatabaseEvent> stream = ref.onValue;

    stream.listen((DatabaseEvent event) {
      getProfile(widget.id.toString());
    });

    if (widget.settings != null) {
      stateIndicator = 4;
      Timer.run(() {
        setState(() {});
      });
    }

    /*if (widget.id != null) {
      getProfile(widget.id.toString());
    } else {
      getUserInfo();
    }*/
  }

  Widget portafolio() {
    return FutureBuilder(
        initialData: 1,
        future: FirebaseDatabase.instance.ref().child('portafolio').child(widget.id.toString()).once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData && snapshot.data != null) {
              DatabaseEvent response;

              response = snapshot.data;

              return response == null
                  ? AppWidget().loading()
                  : response.snapshot.children.toList().length == 0
                      ? AppWidget().noResult()
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

                              return GestureDetector(
                                  onTap: () {
                                    watchService(String urlString) async {
                                      final Uri url = Uri.parse(urlString);
                                      if (!await launchUrl(url)) {
                                        throw Exception('Could not launch');
                                      }
                                    }

                                    if (FirebaseAuth.instance.currentUser!.uid != widget.id) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext contextAlert) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              insetPadding: EdgeInsets.all(0),
                                              contentPadding: EdgeInsets.all(0),
                                              content: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          width: double.infinity,
                                                          child: Text(
                                                            "Información del servicio",
                                                            style:
                                                                TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 17),
                                                            textAlign: TextAlign.center,
                                                          )),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(25),
                                                        child: Image.network(
                                                          dataList.child("foto").value.toString(),
                                                          errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                            return Container(
                                                              width: 200,
                                                              height: 100,
                                                              color: Colors.grey.withOpacity(0.3),
                                                            );
                                                          },
                                                          width: 220,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                              margin: EdgeInsets.only(left: 10),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "Categoria",
                                                                    style: TextStyle(
                                                                        color: secondryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  Text(
                                                                    dataList.child("category").value.toString(),
                                                                    style: TextStyle(
                                                                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  /* RatingBarIndicator(
                                                                                        rating: 2.5,
                                                                                        itemCount: 5,
                                                                                        itemSize: 30.0,
                                                                                        itemBuilder: (context, _) => Icon(
                                                                                              Icons.star_border_rounded,
                                                                                              color: secondryColor,
                                                                                            )),*/
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ],
                                                              )),
                                                          Expanded(child: SizedBox()),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "Costo del servicio",
                                                                style: TextStyle(
                                                                    color: secondryColor, fontWeight: FontWeight.bold, fontSize: 15),
                                                              ),
                                                              Text(
                                                                dataList.child("price").value == null
                                                                    ? '\$' + "0"
                                                                    : '\$' +
                                                                        MoneyFormatter(
                                                                                amount:
                                                                                    double.parse(dataList.child("price").value.toString()))
                                                                            .output
                                                                            .withoutFractionDigits
                                                                            .toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                              ),
                                                              SizedBox(
                                                                height: 40,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin: EdgeInsets.only(left: 20, right: 20),
                                                          child: Text(
                                                            dataList.child("name").value.toString(),
                                                            style:
                                                                TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 12),
                                                          )),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets.only(left: 20, right: 20),
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                  child: AppWidget().buttonFormLine(context, "Cancelar", true, tap: () {
                                                                Navigator.pop(context);
                                                              })),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Flexible(
                                                                  child: AppWidget().buttonFormLine(context, "Solicitar", false, tap: () {
                                                                Navigator.pop(context);
                                                                Query historyRef = FirebaseDatabase.instance
                                                                    .ref()
                                                                    .child('ordens')
                                                                    .child(userDataProfile!.child("cart").value.toString());

                                                                createService(DataSnapshot snapshot) {
                                                                  snapshot.ref.child("services").push().set({
                                                                    "foto": dataList.child("foto").value.toString(),
                                                                    "name": dataList.child("name").value,
                                                                    "price": dataList.child("price").value
                                                                  }).then((value) {
                                                                    AppWidget().itemMessage("Agregado", context);
                                                                  }).catchError((onError) {
                                                                    AppWidget().itemMessage("Ha ocurrido un error", context);
                                                                  });
                                                                }

                                                                historyRef.once().then((e) async {
                                                                  final snapshot = e.snapshot;
                                                                  if (snapshot.value != null) {
                                                                    if (snapshot.child("professional").value.toString() ==
                                                                        _userDataProfile!.key.toString()) {
                                                                      createService(snapshot);
                                                                    } else {
                                                                      AppWidget().itemMessage(
                                                                          "No se puede seleccionar otro professional", context);
                                                                    }
                                                                  } else {
                                                                    createOrdens(context,
                                                                        name: dataList.child("name").value.toString(),
                                                                        inspections: dataList.child("inspections").value.toString(),
                                                                        profesionalName: dataList.child("fullname").value.toString(),
                                                                        profesional: _userDataProfile!.key.toString(),
                                                                        price: int.parse(dataList.child("price").value.toString()));

                                                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                                                      createService(snapshot);
                                                                    });
                                                                  }
                                                                });
                                                              })),
                                                            ],
                                                          )),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          });
                                      /* showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
                                                  title: new Text('Ver portafolio'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    watchService((dataList!.child("foto").value.toString()));
                                                  },
                                                ),
                                                ListTile(
                                                  title: new Text('Agregar servicio'),
                                                  onTap: () {
                                                    Query historyRef = FirebaseDatabase.instance
                                                        .ref()
                                                        .child('ordens')
                                                        .child(userDataProfile!.child("cart").value.toString());

                                                    historyRef.once().then((e) async {
                                                      final snapshot = e.snapshot;
                                                      if (snapshot.value != null) {
                                                        snapshot.ref.child("services").push().set({
                                                          "foto": dataList.child("foto").value.toString(),
                                                          "name": dataList.child("name").value,
                                                          "price": dataList.child("price").value
                                                        }).then((value) {
                                                          AppWidget().itemMessage("Agregado", context);
                                                        }).catchError((onError) {
                                                          AppWidget().itemMessage("Ha ocurrido un error", context);
                                                        });
                                                      } else {
                                                       
                                                      }
                                                    });
                                                  },
                                                ),
                                                ListTile(
                                                  title: new Text('Cancelar'),
                                                  onTap: () {},
                                                ),
                                              ],
                                            );
                                          });*/
                                    } else {
                                      watchService((dataList.child("foto").value.toString()));
                                    }
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Image.network(
                                                  dataList.child("foto").value.toString(),
                                                  errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                    return Container(
                                                      width: 120,
                                                      height: 120,
                                                      color: Colors.grey.withOpacity(0.3),
                                                    );
                                                  },
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              FirebaseAuth.instance.currentUser!.uid == widget.id
                                                  ? SizedBox()
                                                  : Positioned.fill(
                                                      child: Align(
                                                          alignment: Alignment.center,
                                                          child: SvgPicture.asset(
                                                            "images/icons/addCircleBlue.svg",
                                                            width: 40,
                                                          ))),
                                            ],
                                          ),
                                          Text(
                                            dataList.child("name").value.toString().capitalize(),
                                            style: TextStyle(color: secondryColor, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            dataList.child("category").value.toString().capitalize(),
                                            style: TextStyle(color: secondryColor, fontSize: 11),
                                          ),
                                          Text(
                                            dataList.child("price").value == null
                                                ? "No disponible"
                                                : '\$' +
                                                    MoneyFormatter(amount: double.parse(dataList.child("price").value.toString()))
                                                        .output
                                                        .withoutFractionDigits
                                                        .toString(),
                                            style: TextStyle(color: secondryColor, fontSize: 11),
                                          ),
                                        ],
                                      )));
                            },
                          ));
            } else {
              return AppWidget().noResult();
            }

            ;
          } catch (e) {
            return AppWidget().loading();
          }
        });
  }
}

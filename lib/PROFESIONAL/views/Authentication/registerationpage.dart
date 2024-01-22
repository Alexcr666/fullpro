// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/utils/permissions.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/DatabaseEntry.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/loginpage.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/register.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/PROFESIONAL/widget/progressDialog.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/terms.dart';

import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/styles/styles.dart';
import 'package:fullpro/utils/countryStateCity/AddressPicker.dart';
import 'package:fullpro/utils/countryStateCity/AddressPickerRow.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:intl/intl.dart';

class RegistrationProfessionalPage extends StatefulWidget {
  static const String id = 'RegistrationPage';

  @override
  State<RegistrationProfessionalPage> createState() => _RegistrationProfessionalPageState();
}

GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
TextEditingController _searchHome = TextEditingController();

class _RegistrationProfessionalPageState extends State<RegistrationProfessionalPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
  TextEditingController street = TextEditingController();

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var dateController = TextEditingController();

  var passwordController = TextEditingController();

  set errorMessage(String errorMessage) {}

  var professionController = TextEditingController();

  var cityController = TextEditingController();

  var stateController = TextEditingController();
  late DatabaseReference nameRef;

  late DatabaseReference userRef;

  Future uploadFile(String title, int position) async {
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    List<String> urlFile = [fileLicense[0].path, fileBackgroundCheck[0].path, fileRegistroLegal[0].path];

    Reference storageReference = FirebaseStorage.instance.ref().child("filesdoc/" + urlFile[position]);

    UploadTask uploadTask = storageReference.putFile(File(fileLicense[0].path));
    UploadTask uploadTask2 = storageReference.putFile(File(fileBackgroundCheck[0].path));
    UploadTask uploadTask3 = storageReference.putFile(File(fileRegistroLegal[0].path));

    TaskSnapshot p0;
    if (position == 0) {
      p0 = await uploadTask;
    }
    if (position == 1) {
      p0 = await uploadTask2;
    }
    if (position == 2) {
      p0 = await uploadTask3;
    }

    String fileUrl = await storageReference.getDownloadURL();

    await userRef.ref.update({title: fileUrl});
  }

  void registerUser(BuildContext context) async {
    try {
      final User = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;

      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          status: Locales.string(context, "lbl_getting_ready"),
        ),
      );

      // check if user registration is successful
      if (User != null) {
        DatabaseReference phoneRef = FirebaseDatabase.instance.ref().child('partners/${User.uid}');

        phoneRef.once().then((e) async {
          final snapshot = e.snapshot;
          if (snapshot.exists) {
            return;
          } else {
            Map userMap = {
              'fullname': fullNameController.text,
              'phone': phoneController.text,
              'dateBirthay': dateController.text,
              'email': emailController.text,
              'history': "0",
              'earnings': 0,
              'profesion': _searchHome.text,
              'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),

              //'city': '',
              'stateUser': '0',
              'country': country.text,
              'state': state.text,
              'city': city.text,
            };
            phoneRef.set(userMap);
          }
        }).catchError((onError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, "Error al crear usuario"))));
          print("error" + onError.toString());
        });

        UserPreferences.setUserPhone(phoneController.text);
        UserPreferences.setUsername(fullNameController.text);

        nameRef = FirebaseDatabase.instance.ref().child('partners/${User.uid}').child('fullname');
        userRef = FirebaseDatabase.instance.ref().child('partners/${User.uid}');
        nameRef.once().then((e) async {
          final snapshot = e.snapshot;
          if (snapshot.exists) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, "Usuario ya existe"))));
          } else {
            /*   Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DatabaseEntry(
                  phone: phoneController.text,
                  userid: User.uid,
                ),
              ),
            );*/

            uploadFile("license", 0).then((value) {
              uploadFile("background", 1).then((value) {
                uploadFile("legal", 2).then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPageProfesional()),
                  );

                  AppWidget().itemMessage("Se ha enviado la solicitud,debes estar activo para poder ingresar", context);
                });
              });
            });

            /*   Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DatabaseEntry(
                  phone: phoneController.text,
                  userid: User.uid,
                ),
              ),
            );*/
          }
        }).catchError((onError) {
          print("error" + onError.toString());

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, "Error al crear usuario"))));
        });
        ;

        //  Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
      } else {
        print("error-->" + "error al crear usuario");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, "Error al crear usuario"))));
      }
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case "email-already-in-use":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Locales.string(context, "error_email_already_in_use"))));
          break;
        default:
          errorMessage = Locales.string(context, 'error_undefined');
      }
    }
  }

  String currentText = "";
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

  ///   LOCATION PERMISSION

  @override
  void initState() {
    super.initState();
    locationPermision();
    servicesSearch(1);
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  Widget signUp2() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleAutoCompleteTextField(
                key: key,
                decoration: InputDecoration(
                  // errorText: "Ingresar servicio valido",
                  contentPadding: EdgeInsets.only(top: 17, bottom: 17, left: 15),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(11)),
                  errorBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),
                  border:
                      OutlineInputBorder(borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),
                  labelText: "Profesión",
                  labelStyle: TextStyle(fontSize: 12.0, color: Colors.black),
                ),
                controller: _searchHome,
                suggestions: suggestions,
                //   textChanged: (text) => currentText = text,
                clearOnSubmit: true,
                textSubmitted: (text) {
                  _searchHome.text = text;
                }
                // setState(() {});
                // added.add(text);

                ),
            //   AppWidget().texfieldFormat(title: "Profesión", controller: professionController),
            /*   Row(
          children: [
            Flexible(child: AppWidget().texfieldFormat(title: "Ciudad", controller: cityController)),
            SizedBox(
              width: 20,
            ),
            Flexible(child: AppWidget().texfieldFormat(title: "Estado", controller: stateController)),
          ],
        ),*/
            SizedBox(
              height: 10,
            ),
            CountryStateCityPickerRow(
              country: country,
              state: state,
              city: city,
              textFieldInputBorder: const UnderlineInputBorder(),
            ),
            SizedBox(
              height: 10,
            ),
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
                                    child: Flexible(
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
                                ))),
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
                                    child: Flexible(
                                        child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileBackgroundCheck[index].path.split('/').last,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                    Text(
                                      AppWidget().getFileSize(fileBackgroundCheck[index].lengthSync(), 1),
                                      style: TextStyle(color: Colors.white, fontSize: 9),
                                    ),
                                  ],
                                ))),
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
                                    child: Flexible(
                                        child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileRegistroLegal[index].path.split('/').last,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                    Text(
                                      AppWidget().getFileSize(fileRegistroLegal[index].lengthSync(), 1),
                                      style: TextStyle(color: Colors.white, fontSize: 9),
                                    ),
                                  ],
                                ))),
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
        ));
  }

  Widget signUp1() {
    return Form(
        key: _formKey1,
        child: Column(
          children: [
            AppWidget().texfieldFormat(title: "Nombre completo", controller: fullNameController, urlIcon: "images/icons/user.svg"),
            /*  Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: fullNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                      labelText: Locales.string(context, 'lbl_fullname'),
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),*/
            //
            //

            //
            //  Phone Number TEXT FIELD
            //
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
                child: AppWidget().texfieldFormat(
                    title: "Fecha de nacimiento", controller: dateController, urlIcon: "images/icons/calendar.svg", enabled: true)),

            SizedBox(
              height: 10,
            ),
            AppWidget().texfieldFormat(title: "Correo electronico", controller: emailController, urlIcon: "images/icons/message.svg"),
            SizedBox(
              height: 10,
            ),
            AppWidget().texfieldFormat(title: "Celular", controller: phoneController, urlIcon: "images/icons/phone.svg"),
            /* Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                      labelText: Locales.string(context, 'lbl_phone_number'),
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),*/
            //
            //
            SizedBox(
              height: 10,
            ),
            //
            //  Email Address TEXT FIELD
            //
            /*Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                      labelText: Locales.string(context, 'lbl_email'),
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                //
                //
                SizedBox(
                  height: 15,
                ),*/
            //
            //  Password

            AppWidget()
                .texfieldFormat(title: "Password", controller: passwordController, urlIcon: "images/icons/password.svg", password: true),
            /* Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                      labelText: /*Locales.string(context, 'lbl_passowrd')*/ "Password",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),*/
            SizedBox(height: 15),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                AppWidget().back(context, tap: () {
                  if (signUpNext == true) {
                    signUpNext = false;
                    setState(() {});
                  } else {
                    Navigator.pop(context);
                  }
                }),

                //
                //
                Image(
                  image: AssetImage("images/logo.png"),
                  alignment: Alignment.center,
                  height: 120.0,
                  width: 120.0,
                ),
                SizedBox(
                  height: 15,
                ),
                //
                //
                GestureDetector(
                    onTap: () {
                      servicesSearch(1);
                    },
                    child: Row(
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
                              "Registro Profesional",
                              textAlign: TextAlign.center,
                              style: AppStyle().boldText(18),
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
                    )),

                //
                // Full Name
                SizedBox(
                  height: 30,
                ),

                signUpNext ? SizedBox() : signUp1(),
                signUpNext == false ? SizedBox() : signUp2(),
                //
                signUpNext == false
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Material(
                              child: Checkbox(
                                activeColor: secondryColor,
                                value: agree,
                                onChanged: (value) {
                                  setState(() {
                                    agree = value ?? false;
                                  });
                                },
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: Locales.string(context, 'lbl_i_have_read_terms'),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: /* Locales.string(context, 'lbl_terms_and_conditions')*/ "  Terms and conditions",
                                    style: TextStyle(color: secondryColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TermsPage(
                                                      state: 1,
                                                    )));

                                        // Loader.page(context, TermsPage());
                                      },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                SizedBox(height: 15),
                //    Register Button

                //   Text(signUpNext.toString()),
                Padding(
                  padding: EdgeInsets.only(
                    right: 0,
                    left: 0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_no_internet'),
                              ),
                            ),
                          );
                          return;
                        }

                        if (fullNameController.text.length < 3) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_enter_valid_name'),
                              ),
                            ),
                          );
                          return;
                        }
                        if (phoneController.text.length < 10 || phoneController.text.length > 14) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_enter_valid_phone'),
                              ),
                            ),
                          );
                          return;
                        }
                        if (!emailController.text.contains('@') || !emailController.text.contains('.')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_enter_valid_email'),
                              ),
                            ),
                          );
                          return;
                        }
                        if (passwordController.text.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_enter_strong_password'),
                              ),
                            ),
                          );
                          return;
                        }
                        if (fileLicense.length == 0) {
                          licenceCheck = true;
                        } else {
                          licenceCheck = false;
                        }
                        if (fileBackgroundCheck.length == 0) {
                          backgroundCheck = true;
                        } else {
                          backgroundCheck = false;
                        }
                        if (fileRegistroLegal.length == 0) {
                          registroCheck = true;
                        } else {
                          registroCheck = false;
                        }

                        if (signUpNext == true) {
                          if (agree == true) {
                            if (_formKey.currentState!.validate()) {
                              registerUser(context);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Debe aceptar los terminos y condiciones")));
                          }
                        } else {
                          if (_formKey1.currentState!.validate()) {
                            signUpNext = true;
                          }
                        }
                        signUpNext = true;
                        setState(() {});
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Static.themeColor[500]!),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          Locales.string(context, 'lbl_register'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                //
                SizedBox(
                  height: 10,
                ),
                //
                //
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pushNamedAndRemoveUntil(context, LoginPageProfesional.id, (route) => false);
                    },
                    child: Text(Locales.string(context, 'lbl_already_have_account')),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                /*    Padding(
                  padding: EdgeInsets.only(
                    right: 50,
                    left: 50,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Loader.page(context, Register());
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Static.colorAccent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          Locales.string(context, 'lbl_register_with_phone'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

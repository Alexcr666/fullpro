import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/const.dart';
import 'package:fullpro/models/userdata.dart';
import 'package:fullpro/pages/Authentication/recoverPassword/changePassword.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/pages/pay/payList.dart';
import 'package:fullpro/pages/profesional/profileProfesional.dart';
import 'package:fullpro/pages/profile/deleteAccount.dart';
import 'package:fullpro/pages/profile/portafolio.dart';
import 'package:fullpro/pages/support.dart';
import 'package:fullpro/pages/support/support.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/utils/utils.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/ProfileWidget.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);
  static const String id = 'Account';

  @override
  _AccountState createState() => _AccountState();
}

bool activeProfile = false;
bool activeSetting = false;
bool activeAjustCount = false;

File? imagePickerFile;

class _AccountState extends State<Account> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  final int _groupValue = 1;
  bool manualAdressExists = false;
  double _currentSliderValue = 20;
  String? getUserName = '';
  String? getuserPhone = '';

  // late DataSnapshot userDataProfile;

  // Text Field Controllers

  late final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  late final _nameControllerProfile = TextEditingController();
  late final _dateController = TextEditingController();
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
  }

  void getUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    /* if (UserPreferences.getUsername() != null && UserPreferences.getUserPhone() != null) {
      _nameController.text = UserPreferences.getUsername() ?? '';
      _phoneController.text = UserPreferences.getUserPhone() ?? '';
    } else {*/
    final UserRef = FirebaseDatabase.instance.ref().child("users").child(userid!);
    UserRef.once().then((e) async {
      if (e.snapshot != null) {
        final DataSnapshot = e.snapshot;
        userDataProfile = e.snapshot;
        setState(() {});

        currentUserInfo = UserData.fromSnapshot(DataSnapshot);
        _currentSliderValue = double.parse(userDataProfile!.child("radio").value.toString());
        _dateController.text = AppUtils().noNull(userDataProfile!.child("dateUser").value.toString());
        _emailController.text = AppUtils().noNull(userDataProfile!.child("email").value.toString());

        _nameController.text = AppUtils().noNull(userDataProfile!.child("fullname").value.toString());
      }
      /*  if (mounted) {
        setState(() {
          if (UserPreferences.getUsername() == null) {
            _nameController.text = currentUserInfo!.fullName.toString();
          } else {
            _nameController.text = UserPreferences.getUsername() ?? '';
          }
          if (UserPreferences.getUserPhone() == null) {
            _phoneController.text = currentUserInfo!.phone.toString();
          } else {
            _phoneController.text = UserPreferences.getUserPhone() ?? '';
          }
        });
      }*/
    });
    //  }
  }

  Widget itemOptionProfile(String title, String url, {String? subtitle, Function? tap}) {
    return GestureDetector(
        onTap: () {
          tap!();
        },
        child: Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(color: secondryColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(child: SizedBox()),
                url == ""
                    ? SizedBox()
                    : SvgPicture.asset(
                        url,
                        width: 35,
                      ),
                subtitle == null
                    ? SizedBox()
                    : Text(
                        subtitle,
                        style: TextStyle(color: secondryColor, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
              ],
            )));
  }

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

  Future<void> updateProfile() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    DatabaseReference profileRef = FirebaseDatabase.instance.ref().child('users/$userid');

    await profileRef.update({
      "fullname": _nameController.text.toString(),
    });
    Navigator.pop(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Center(
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    FeatherIcons.check,
                    size: 35,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Locales.string(context, 'lbl_profile_updated'),
                    style: const TextStyle(fontSize: 15),
                  ),
                  Center(
                      child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.black,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      Locales.string(context, 'lbl_close'),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      /* appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        elevation: .7,
        toolbarHeight: 70,
        backgroundColor: Static.dashboardBG,
        centerTitle: true,
        title: Text(
          Locales.string(context, 'lbl_account'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),*/
      body: userDataProfile == null
          ? AppWidget().loading()
          : SafeArea(
              child: Padding(
              padding: EdgeInsets.only(
                left: leftPadding,
                right: rightPadding,
                bottom: bottomPadding,
                top: topPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    AppWidget().back(context),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();

                          var image = await imagePicker.pickImage(source: ImageSource.gallery);
                          imagePickerFile = File(image!.path);
                          FirebaseAuth user = FirebaseAuth.instance;

                          AppWidget().itemMessage("Subiendo..", context);

                          int timestamp = new DateTime.now().millisecondsSinceEpoch;

                          Reference storageReference = FirebaseStorage.instance
                              .ref()
                              .child('user/' + user.currentUser!.uid.toString() + timestamp.toString() + '.jpg');

                          UploadTask uploadTask = storageReference.putFile(File(image!.path));

                          await uploadTask.then((p0) async {
                            String fileUrl = await storageReference.getDownloadURL();

                            log("urlfile: " + fileUrl.toString());

                            // userProfileData.child("photo")

                            userDataProfile!.ref.update({'photo': fileUrl}).then((value) {
                              //  Navigator.pop(context);

                              setState(() {});

                              AppWidget().itemMessage("Foto actualizada", context);
                              getUserInfo();
                            }).catchError((onError) {
                              AppWidget().itemMessage("Error al actualizar foto", context);
                            });

                            //   _sendImage(messageText: 'Photo', imageUrl: fileUrl);
                          }).catchError((onError) {
                            print("error: " + onError.toString());
                          });
                        },
                        child: Stack(
                          children: [
                            userDataProfile!.child("photo").value == null
                                ? AppWidget().circleProfile(userDataProfile!.child("photo").value.toString(), size: 120)
                                : imagePickerFile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: Image.file(
                                          imagePickerFile!,
                                          fit: BoxFit.cover,
                                          width: 130,
                                          height: 130,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        "images/icons/profileCircle.svg",
                                        width: 130,
                                      ),
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
                    /* const SizedBox(height: 30),
              ProfileWidget(
                imagePath: 'images/user_icon.png',
                onClicked: () async {},
              ),*/
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      userDataProfile!.child("fullname").value == null
                          ? Locales.string(context, 'lang_nodisponible')
                          : userDataProfile!.child("fullname").value.toString().capitalize(),
                      style: TextStyle(color: secondryColor, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            itemOptionProfile(Locales.string(context, 'lang_profile'), "images/icons/profileCircle.svg", tap: () {
                              activeProfile = !activeProfile;
                              setState(() {});
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              height: 0.5,
                              color: secondryColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            activeProfile
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () async {},
                                              child: SvgPicture.asset(
                                                "images/icons/profileCircle.svg",
                                                width: 35,
                                              )),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Locales.string(context, 'lang_profile'),
                                                style: TextStyle(color: secondryColor, fontSize: 17),
                                              ),
                                              Text(
                                                Locales.string(context, 'lang_dataprofile'),
                                                style: TextStyle(color: secondryColor, fontSize: 17, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Expanded(child: SizedBox()),
                                          Text(
                                            Locales.string(context, 'lang_datapersonal'),
                                            style: TextStyle(color: secondryColor, fontSize: 13, fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      /* Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              labelText: Locales.string(context, 'lbl_name'),
                              hintText: Locales.string(context, 'hint_enter_full_name'),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return Locales.string(context, 'hint_enter_full_name');
                              }
                              return null;
                            },
                          ),
                        ),
                      ),*/

                                      AppWidget().texfieldFormat(
                                          title: Locales.string(context, 'lbl_fullname'),
                                          urlIcon: "images/icons/user.svg",
                                          controller: _nameController),
                                      const SizedBox(height: 10),
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
                                              title: Locales.string(context, 'lang_datebirt'),
                                              urlIcon: "images/icons/calendar.svg",
                                              controller: _dateController,
                                              enabled: true)),
                                      const SizedBox(height: 10),
                                      AppWidget().texfieldFormat(
                                          title: Locales.string(context, 'lang_email'),
                                          urlIcon: "images/icons/message.svg",
                                          controller: _emailController),
                                      const SizedBox(height: 10),
                                      //   AppWidget().texfieldFormat(
                                      //     title: "Locales.string(context, 'lbl_password')", urlIcon: "images/icons/password.svg", controller: _passwordController),
                                    ],
                                  ),

                            /* Text(
                        Locales.string(context, 'war_phone_can_not_change'),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: TextFormField(
                            enabled: false,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              labelText: Locales.string(context, 'lbl_phone'),
                              hintText: Locales.string(context, 'hint_enter_phone_number'),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return Locales.string(context, 'hint_enter_phone_number');
                              }
                              return null;
                            },
                          ),
                        ),
                      ),*/
                            const SizedBox(height: 20),
                            /*  Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: MaterialButton(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 40,
                            color: Static.themeColor[500],
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            child: Text(Locales.string(context, 'lbl_update_profile')),
                            //
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //
                                updateProfile();
                              }
                            },f
                          ),
                        ),
                      ),*/
                            SizedBox(
                              height: 30,
                            ),
                            itemOptionProfile(Locales.string(context, 'lang_settings'), "images/icons/settings.svg", tap: () {
                              activeSetting = !activeSetting;
                              setState(() {});
                            }),
                            activeSetting
                                ? SizedBox()
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      itemOptionProfileOptions(Locales.string(context, 'lang_radio'), "images/icons/locationCircle.svg",
                                          subtitle: _currentSliderValue.round().toString() + " KM"),
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
                                        height: 10,
                                      ),
                                      itemOptionProfileOptions(Locales.string(context, 'lang_settings'), "images/icons/profileCircle.svg",
                                          onTap: () {
                                        activeAjustCount = !activeAjustCount;
                                        setState(() {});
                                      }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //   Text(activeAjustCount.toString()),
                                      activeAjustCount
                                          ? SizedBox()
                                          :
                                          /*? SizedBox()
                                          : userDataProfile != null
                                              ? SizedBox()
                                              :*/
                                          Column(
                                              children: [
                                                itemOptionProfile(
                                                    Locales.string(context, 'lang_location'), "images/icons/profileCircle.svg", tap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => DeleteAccountPage(
                                                                userProfileData: userDataProfile!,
                                                              )));
                                                }),
                                                itemOptionProfile("Fecha", "",
                                                    subtitle: userDataProfile!.child("date").value == null
                                                        ? Locales.string(context, 'lang_nodisponible')
                                                        : userDataProfile!.child("date").value.toString(), tap: () {
                                                  //    Navigator.push(context, MaterialPageRoute(builder: (context) => const PortafolioPage()));
                                                }),
                                                /* itemOptionProfile("Usuario", "",
                                                    subtitle: userDataProfile!.child("name").value == null
                                                        ? Locales.string(context, 'lang_nodisponible')
                                                        : userDataProfile!.child("name").value.toString()),
                                                itemOptionProfile("Estado del usuario", "",
                                                    subtitle: userDataProfile!.child("state").value == null
                                                        ? "Disponible"
                                                        : stateOrderUser[int.parse(userDataProfile!.child("state").value.toString())]),
                                               */
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                itemOptionProfile(Locales.string(context, 'lbl_password'), "", subtitle: "", tap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                                                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileProfesionalPage()));
                                                }),
                                                /*  itemOptionProfile("Suspender cuenta", "", subtitle: "", tap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAccountPage()));
                                                //   Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileProfesionalPage()));
                                              }),*/
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                /*  itemOptionProfile("Archivar cuenta", "", subtitle: "", tap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAccountPage()));
                                          }),*/
                                                SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                /* GestureDetector(
                              onTap: () {},
                              child: Flexible(
                                  child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "images/icons/miprofile7.svg",
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "LOGOUT",
                                    style: TextStyle(color: secondryColor, fontSize: 20),
                                  ),
                                ],
                              ))),*/
                                Expanded(child: SizedBox()),
                                GestureDetector(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        //
                                        //updateProfile();

                                        userDataProfile!.ref.update({
                                          'radio': int.parse(_currentSliderValue.round().toString()),
                                          "fullname": _nameController.text.toString(),
                                          "dateUser": _dateController.text,
                                          "email": _emailController.text
                                        }).then((value) {
                                          AppWidget().itemMessage("Guardado", context);
                                        });
                                      } else {
                                        AppWidget().itemMessage("Faltan campos", context);
                                      }
                                    },
                                    child: Flexible(
                                        child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "images/icons/saved.svg",
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Guardar",
                                          style: TextStyle(color: secondryColor, fontSize: 20),
                                        ),
                                      ],
                                    ))),
                                Expanded(child: SizedBox()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }

  Widget addressRadio({required String title, required int value, required bool selected, required Function(int?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black87,
          border: Border.all(color: Colors.black26),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(),
          child: RadioListTile(
            value: value,
            groupValue: _groupValue,
            onChanged: onChanged,
            selected: selected,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

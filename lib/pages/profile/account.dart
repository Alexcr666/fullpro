import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/models/userdata.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/profile/deleteAccount.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/ProfileWidget.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);
  static const String id = 'Account';

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  final int _groupValue = 1;
  bool manualAdressExists = false;
  String? getUserName = '';
  String? getuserPhone = '';
  // Text Field Controllers

  late final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
  }

  void getUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    if (UserPreferences.getUsername() != null && UserPreferences.getUserPhone() != null) {
      _nameController.text = UserPreferences.getUsername() ?? '';
      _phoneController.text = UserPreferences.getUserPhone() ?? '';
    } else {
      final UserRef = FirebaseDatabase.instance.ref().child("users").child(userid!);
      UserRef.once().then((e) async {
        final DataSnapshot = e.snapshot;

        currentUserInfo = UserData.fromSnapshot(DataSnapshot);
        if (mounted) {
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
        }
      });
    }
  }

  Widget itemOptionProfile(String title, String url, {String? subtitle}) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: secondryColor, fontSize: 19, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: secondryColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
          ],
        ));
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
      appBar: AppBar(
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
      ),
      body: SafeArea(
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
              const SizedBox(height: 30),
              ProfileWidget(
                imagePath: 'images/user_icon.png',
                onClicked: () async {},
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      itemOptionProfile("Mi perfil", "images/icons/profileCircle.svg"),
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
                      Row(
                        children: [
                          SvgPicture.asset(
                            "images/icons/profileCircle.svg",
                            width: 35,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mi Perfil",
                                style: TextStyle(color: secondryColor, fontSize: 17),
                              ),
                              Text(
                                "Datos cliente",
                                style: TextStyle(color: secondryColor, fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            "Datos personales",
                            style: TextStyle(color: secondryColor, fontSize: 13, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
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
                      ),
                      const SizedBox(height: 20),
                      Text(
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
                      ),
                      const SizedBox(height: 20),
                      Center(
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
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      itemOptionProfile("Ajustes", "images/icons/settings.svg"),
                      SizedBox(
                        height: 30,
                      ),
                      itemOptionProfileOptions("Radio de busqueda", "images/icons/location.svg", subtitle: "13 KM"),
                      SizedBox(
                        height: 10,
                      ),
                      itemOptionProfileOptions("Ajuste de cuenta", "images/icons/profileCircle.svg", onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAccountPage()));
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      itemOptionProfile(
                        "Eliminar cuenta",
                        "images/icons/profileCircle.svg",
                      ),
                      itemOptionProfile(
                        "Fecha",
                        "",
                        subtitle: "02/05/2023",
                      ),
                      itemOptionProfile("Usuario", "", subtitle: "user"),
                      itemOptionProfile("Estado del usuario", "", subtitle: "Activado"),
                      SizedBox(
                        height: 30,
                      ),
                      itemOptionProfile("Suspender cuenta", "", subtitle: ""),
                      SizedBox(
                        height: 10,
                      ),
                      itemOptionProfile("Archivar cuenta", "", subtitle: ""),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
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
                          Expanded(child: SizedBox()),
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

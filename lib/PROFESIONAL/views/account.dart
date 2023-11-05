import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/PROFESIONAL/models/partner.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/loginpage.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';
import 'package:fullpro/PROFESIONAL/widget/profileWidget.dart';

import 'package:fullpro/styles/statics.dart' as appcolors;

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
  int groupValue = 1;
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
                  _nameController.text = currentPartnerInfo!.fullName.toString();
                } else {
                  _nameController.text = UserPreferences.getUsername() ?? '';
                }
                if (UserPreferences.getUserPhone() == null) {
                  _phoneController.text = currentPartnerInfo!.phone.toString();
                } else {
                  _phoneController.text = UserPreferences.getUserPhone() ?? '';
                }
              });
            }
          }
        }
      });
    }
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

    DatabaseReference profileRef = FirebaseDatabase.instance.ref().child('partners/$userid');

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
                    FeatherIcons.userCheck,
                    size: 40,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Locales.string(context, 'lbl_profile_updated'),
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 20),
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
      backgroundColor: appcolors.dashboardCard,
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
        backgroundColor: appcolors.dashboardBG,
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
                            color: appcolors.themeColor[500],
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            child: Text(
                              Locales.string(context, 'lbl_update_profile'),
                            ),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: MaterialButton(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 40,
                            color: appcolors.colorAccent,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            child: Text(
                              Locales.string(context, 'lbl_logout'),
                            ),
                            //
                            onPressed: () {
                              _signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const LoginPageProfesional()), (route) => false));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
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
            groupValue: groupValue,
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

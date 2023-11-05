// ignore_for_file: file_names

import 'package:flutter_locales/flutter_locales.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/controllers/categoriesController.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/views/Authentication/CategorySelection.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';

import 'package:fullpro/styles//statics.dart' as appcolors;

class DatabaseEntry extends StatefulWidget {
  static const String id = 'DatabaseEntry';

  final String? userid;
  final String? phone;

  const DatabaseEntry({
    Key? key,
    this.userid,
    this.phone,
  }) : super(key: key);

  @override
  _DatabaseEntryState createState() => _DatabaseEntryState();
}

class _DatabaseEntryState extends State<DatabaseEntry> {
  final _contactEditingController = TextEditingController();
  set errorMessage(String errorMessage) {}
  String? fullname;
  String? getUserName = '';
  String? getuserPhone = '';
  bool dataisLoading = true;

  void registerUser() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    try {
      // check if user registration is successful
      if (_contactEditingController.text.isNotEmpty) {
        DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('partners/${widget.userid}');
        // Prepare data to be saved on users table
        Map userMap = {
          'fullname': _contactEditingController.text,
          'phone': widget.phone,
          'history': "0",
          'earnings': 0,
        };

        UserPreferences.setUserPhone(widget.phone.toString());
        UserPreferences.setUsername(_contactEditingController.text);

        newUserRef.set(userMap);

        Loader.page(context, CategorySelection(userID: widget.userid));
      } else {
        MainControllerProfesional.showErrorDialog(
            context, Locales.string(context, 'lbl_error'), Locales.string(context, 'lbl_please_enter_your_name'));
      }
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        default:
          MainControllerProfesional.showErrorDialog(context, Locales.string(context, 'lbl_error'), ex.message!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    CategoriesController.getParentCategory(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
            child: Column(
              children: [
                const SizedBox(
                  height: 18,
                ),
                Image.asset(
                  'images/otp_done.gif',
                  width: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  Locales.string(context, 'lbl_enter_your_name'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  Locales.string(context, 'lbl_please_enter_your_name'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        //
                        child: Row(
                          children: [
                            SizedBox(
                              width: 180,
                              child: TextFormField(
                                controller: _contactEditingController,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefix: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_contactEditingController.text.isNotEmpty) {
                              registerUser();
                            } else {
                              MainControllerProfesional.showErrorDialog(
                                context,
                                Locales.string(context, 'lbl_error'),
                                Locales.string(context, 'lbl_please_enter_your_name'),
                              );
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(appcolors.themeColor[500]!),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              "Siguiente",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Image.asset(
                        'images/logo.png',
                        width: 110,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

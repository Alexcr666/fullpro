import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/styles//statics.dart' as Static;

class DatabaeEntry extends StatefulWidget {
  static const String id = 'DatabaeEntry';

  String? userid;
  String? phone;

  DatabaeEntry({
    this.userid,
    this.phone,
  });

  @override
  _DatabaeEntryState createState() => _DatabaeEntryState();
}

class _DatabaeEntryState extends State<DatabaeEntry> {
  final _contactEditingController = TextEditingController();
  set errorMessage(String errorMessage) {}
  String? fullname;
  String? getUserName = '';
  String? getuserPhone = '';
  bool dataisLoading = true;

  void registerUser() async {
    try {
      // check if user registration is successful
      if (_contactEditingController.text.isNotEmpty) {
        DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('users/${widget.userid}');
        // Prepare data to be saved on users table
        Map userMap = {
          'fullname': _contactEditingController.text,
          'currentAddress': 'Set Current Address',
          'manualAddress': Locales.string(context, 'lbl_set_manual_address'),
          'phone': widget.phone,
          'AddressinUse': "current",
        };

        UserPreferences.setUserPhone(widget.phone.toString());
        UserPreferences.setUsername(_contactEditingController.text);

        newUserRef.set(userMap);

        Navigator.pushNamedAndRemoveUntil(context, kHomePage.id, (route) => false);
      }
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case "email-already-in-use":
          showErrorDialog(context, Locales.string(context, 'error_email_already_in_use'));
          break;
        default:
          errorMessage = Locales.string(context, 'error_enter_valid_name');
          showErrorDialog(context, Locales.string(context, 'error_enter_valid_name'));
      }
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(Locales.string(context, 'lbl_error')),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              Container(
                width: 150,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'images/otp_done.gif',
                ),
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
                Locales.string(context, 'lbl_update_information'),
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
                          registerUser();
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Static.themeColor[500]!),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            Locales.string(context, 'lbl_save'),
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
    );
  }
}

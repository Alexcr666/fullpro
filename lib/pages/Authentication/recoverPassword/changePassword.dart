import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'package:fullpro/pages/Authentication/recoverPassword/firebaseAuth.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/widgets/widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String id = 'reset_password';

  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _key = GlobalKey<FormState>();

  final _newPasswordController = TextEditingController();

  final _repeatNewPasswordController = TextEditingController();

  final _actualPasswordController = TextEditingController();

  static final auth = FirebaseAuth.instance;

  static late AuthStatus _status;

  @override
  void dispose() {
    super.dispose();
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError((e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
  }

  void _changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;

    final cred = EmailAuthProvider.credential(email: user!.email.toString(), password: currentPassword);

    user!.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        AppWidget().itemMessage("Se han realizado los cambios", context);

        //Success, do something
      }).catchError((error) {
        AppWidget().itemMessage("Se han realizado los cambios", context);

        //Error, show something
      });
    }).catchError((err) {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppWidget().back(context),
                const SizedBox(height: 70),
                Text(
                  Locales.string(context, 'lang_recoverpassword'),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 40),
                AppWidget().texfieldFormat(controller: _newPasswordController, title: "Locales.string(context, 'lbl_password') nueva"),
                SizedBox(
                  height: 7,
                ),
                AppWidget().texfieldFormat(
                    controller: _repeatNewPasswordController, title: "Repite Locales.string(context, 'lbl_password') nueva"),
                SizedBox(
                  height: 7,
                ),
                AppWidget().texfieldFormat(controller: _actualPasswordController, title: "Locales.string(context, 'lbl_password') actual"),
                const Expanded(child: SizedBox()),
                AppWidget().buttonFormColor(context, "Guardar", secondryColor, tap: () async {
                  if (_key.currentState!.validate()) {
                    if (_newPasswordController.text.toString() == _repeatNewPasswordController.text.toString()) {
                      _changePassword(_actualPasswordController.text, _newPasswordController.text);
                    } else {
                      AppWidget().itemMessage("Las Locales.string(context, 'lbl_password') no coinciden", context);
                    }
                  }
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

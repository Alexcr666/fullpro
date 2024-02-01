import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'package:fullpro/pages/Authentication/recoverPassword/firebaseAuth.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/widgets/widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'reset_password';

  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _key = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  static final auth = FirebaseAuth.instance;

  static late AuthStatus _status;

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError((e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
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
                  Locales.string(context, 'lang_change_password'),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ingresa tu email',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                AppWidget().texfieldFormat(controller: _emailController, title: "Correo electronico"),
                const SizedBox(height: 16),
                const Expanded(child: SizedBox()),
                AppWidget().buttonFormColor(context, Locales.string(context, 'lang_recoverpassword'), secondryColor, tap: () async {
                  if (_key.currentState!.validate()) {
                    final _status = await resetPassword(email: _emailController.text.trim());

                    if (_status == AuthStatus.successful) {
                      Navigator.pop(context);

                      AppWidget().itemMessage(
                          "Hemos enviado un correo electronico para el cambio de tu Locales.string(context, 'lbl_password')", context);

                      //your logic
                    } else {
                      AppWidget().itemMessage("Error al envio del correo electronico", context);

                      //your logic or show snackBar with error message
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

import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';


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

                const Text(

                  "Recuperar contraseña",

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


                /* Container(

                  child: TextFormField(

                    obscureText: false,

                    controller: _emailController,

                    validator: (value) {

                      if (value == null || value.isEmpty) {

                        return 'Empty email';

                      }


                      return null;

                    },

                    autofocus: false,

                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: secondryColor),

                    decoration: InputDecoration(

                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),


                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),


                      enabledBorder: OutlineInputBorder(

                        borderSide: BorderSide(

                          color: secondryColor,

                          width: 1,

                        ),

                        borderRadius: BorderRadius.all(

                          Radius.circular(

                            30.0,

                          ),

                        ),

                      ),


                      focusedBorder: OutlineInputBorder(

                        borderSide: BorderSide(color: secondryColor, width: 2.0),

                        borderRadius: BorderRadius.all(

                          Radius.circular(

                            30.0,

                          ),

                        ),

                      ),


                      isDense: true,


                      // fillColor: kPrimaryColor,


                      filled: true,


                      errorStyle: TextStyle(fontSize: 15),


                      hintText: 'email address',


                      hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: secondryColor),

                    ),

                  ),

                ),*/


                AppWidget().texfieldFormat(controller: _emailController, title: "Correo electronico"),

                const SizedBox(height: 16),

                const Expanded(child: SizedBox()),


                /*   SizedBox(

                  height: MediaQuery.of(context).size.height / 20,

                  child: Material(

                    elevation: 2,

                    borderRadius: BorderRadius.circular(20),

                    color: secondryColor,

                    child: MaterialButton(

                      onPressed: () async {


                      },

                      minWidth: double.infinity,

                      child: Text(

                        'RECOVER PASSWORD',

                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins'),

                      ),

                    ),

                  ),

                ),*/


                AppWidget().buttonFormColor(context, "Recuperar contraseña", secondryColor, tap: () async {

                  if (_key.currentState!.validate()) {

                    final _status = await resetPassword(email: _emailController.text.trim());


                    if (_status == AuthStatus.successful) {

                      Navigator.pop(context);


                      AppWidget().itemMessage("Hemos enviado un correo electronico para el cambio de tu contraseña", context);


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


import 'package:connectivity_plus/connectivity_plus.dart';


import 'package:flutter/material.dart';


import 'package:flutter/services.dart';


import 'package:flutter/widgets.dart';


import 'package:flutter_svg/svg.dart';


import 'package:fullpro/PROFESIONAL/views/Authentication/loginpage.dart';


import 'package:fullpro/pages/Authentication/registerationpage.dart';


import 'package:fullpro/styles/statics.dart' as Static;


import 'package:flutter_locales/flutter_locales.dart';


import 'package:fullpro/pages/INTEGRATION/styles/color.dart';


class AppWidget {

  borderColor() {

    return BoxDecoration(

      borderRadius: BorderRadius.circular(12),


      border: Border.all(color: secondryColor),


      //  color: secondryColor,

    );

  }


  Widget texfieldFormat(

      {String? title,

      TextEditingController? controller,

      bool? password,

      bool? enabled,

      String? urlIcon,

      Color? colorBackground,

      bool? number,

      String? suffix,

      bool? noRequired,

      Function? execute,

      bool? float}) {

    bool _passwordVisible = true;


    return Container(

        color: Colors.white,


        /*decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),*/


        // padding: EdgeInsets.symmetric(horizontal: 8),


        /*  decoration: BoxDecoration(
            border: Border.all(color: Color(0xffE8E8E8)),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),*/


        //    height: 34.sp,


        margin: EdgeInsets.only(top: 5),

        child: TextFormField(

          inputFormatters: number == null ? null : <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],

          enabled: enabled == true ? false : true,

          controller: controller,

          onChanged: (text) {

            execute!();

          },

          obscureText: password != true ? false : _passwordVisible,

          decoration: InputDecoration(

            enabledBorder: OutlineInputBorder(


                // width: 0.0 produces a thin "hairline" border


                borderSide: BorderSide(color: secondryColor, width: 1.0),

                borderRadius: BorderRadius.circular(11)),


            border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),


            contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),


            labelText: title,


            fillColor: Colors.white,


            errorStyle: TextStyle(height: 0.3),


            prefixIconConstraints: BoxConstraints(maxHeight: 0),


            filled: true,


            labelStyle: TextStyle(color: secondryColor, fontSize: 14),


            //   border: InputBorder.none,


            /*  focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColors.green,
                ),
              ),*/


            suffixIcon: IconButton(

              icon: urlIcon != null

                  ? SvgPicture.asset(

                      urlIcon.toString(),

                      color: secondryColor,

                      width: 25,

                    )

                  : Icon(

                      // Based on passwordVisible state choose the icon


                      _passwordVisible == false ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,


                      color: password != true ? Colors.transparent : Colors.grey,

                    ),

              onPressed: () {

                // Update the state i.e. toogle the state of passwordVisible variable


                // setState(() {


                // _passwordVisible = !_passwordVisible;


                //});

              },

            ),


            /*  focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColors.greyTextField2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColors.greyTextField2,
                ),
              ),*/

          ),

          validator: (val) {

            if (noRequired == true) {

              return null;

            } else {

              if (val!.length == 0) {

                return "Campo obligatorio";

              } else {

                return null;

              }

            }

          },

          keyboardType: float == true

              ? TextInputType.numberWithOptions(decimal: true)

              : number != null

                  ? TextInputType.number

                  : TextInputType.emailAddress,

        ));

  }


  boxShandowGrey() {

    return BoxDecoration(

      color: Colors.white,

      borderRadius: BorderRadius.only(

          topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),

      boxShadow: [

        BoxShadow(

          color: secondryColor.withOpacity(0.1),


          spreadRadius: 3,


          blurRadius: 3,


          offset: Offset(0, 3), // changes position of shadow

        ),

      ],

    );

  }


  boxShandowGreyRectangule() {

    return BoxDecoration(

      color: Colors.white,

      borderRadius: BorderRadius.only(

          topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),

      boxShadow: [

        BoxShadow(

          color: secondryColor.withOpacity(0.1),


          spreadRadius: 3,


          blurRadius: 3,


          offset: Offset(0, 3), // changes position of shadow

        ),

      ],

    );

  }


  buttonShandowActive(String title, bool active, {Function? tap}) {

    return GestureDetector(

        onTap: () {

          tap!();

        },

        child: Container(

          height: 40,

          child: Center(

              child: Text(

            title,

            style: TextStyle(color: active ? Colors.white : secondryColor, fontSize: 13),

          )),

          decoration: active

              ? BoxDecoration(

                  borderRadius: BorderRadius.only(

                      topLeft: Radius.circular(30),

                      topRight: Radius.circular(30),

                      bottomLeft: Radius.circular(30),

                      bottomRight: Radius.circular(30)),

                  gradient: LinearGradient(

                      colors: [

                        primaryColor,

                        secondryColor,

                      ],

                      begin: const FractionalOffset(0.0, 1.0),

                      end: const FractionalOffset(0.0, 0.0),

                      stops: [0.0, 1.0],

                      tileMode: TileMode.clamp),

                )

              : BoxDecoration(

                  color: Colors.white,

                  borderRadius: BorderRadius.only(

                      topLeft: Radius.circular(30),

                      topRight: Radius.circular(30),

                      bottomLeft: Radius.circular(30),

                      bottomRight: Radius.circular(30)),

                  boxShadow: [

                    BoxShadow(

                      color: secondryColor.withOpacity(0.1),


                      spreadRadius: 3,


                      blurRadius: 3,


                      offset: Offset(0, 3), // changes position of shadow

                    ),

                  ],

                ),

        ));

  }


  buttonShandow(String title) {

    return Container(

      height: 40,

      child: Center(

          child: Text(

        title,

        style: TextStyle(color: secondryColor, fontSize: 13),

      )),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.only(

            topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),

        boxShadow: [

          BoxShadow(

            color: secondryColor.withOpacity(0.1),


            spreadRadius: 3,


            blurRadius: 3,


            offset: Offset(0, 3), // changes position of shadow

          ),

        ],

      ),

    );

  }


  buttonShandowRounded(String title, bool active, {Function? tap}) {

    return GestureDetector(

        onTap: () {

          tap!();

        },

        child: Container(

          height: 35,

          child: Container(

              padding: EdgeInsets.only(left: 20, right: 20),

              child: Center(

                  child: Text(

                title,

                style: TextStyle(color: active == false ? Colors.white : secondryColor, fontSize: 13),

              ))),

          decoration: BoxDecoration(

            color: active ? Colors.white : secondryColor,

            borderRadius: BorderRadius.only(

                topLeft: Radius.circular(20),

                topRight: Radius.circular(20),

                bottomLeft: Radius.circular(20),

                bottomRight: Radius.circular(20)),

            boxShadow: [

              BoxShadow(

                color: secondryColor.withOpacity(0.1),


                spreadRadius: 3,


                blurRadius: 3,


                offset: Offset(0, 3), // changes position of shadow

              ),

            ],

          ),

        ));

  }


  Widget back(BuildContext context) {

    return Row(

      children: [

        SizedBox(

          width: 20,

        ),

        GestureDetector(

            onTap: () {

              Navigator.pop(context);

            },

            child: SvgPicture.asset(

              "images/icons/back.svg",

              width: 30,

            )),

        Expanded(child: SizedBox()),

      ],

    );

  }


  redSocial(BuildContext context) {

    return Column(

      children: [

        SizedBox(

          height: 50.0,

          width: double.infinity,

          child: TextButton(

            onPressed: () async {

              Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);

            },

            child: Text(

              "Create new account user",

              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

            ),

          ),

        ),

        SizedBox(

          height: 50.0,

          width: double.infinity,

          child: TextButton(

            onPressed: () async {

              Navigator.push(

                context,

                MaterialPageRoute(builder: (context) => LoginPageProfesional()),

              );


              //    Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);

            },

            child: Text(

              "Create new account profesional",

              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

            ),

          ),

        ),

        SizedBox(

          height: 10,

        ),

        Container(

          width: double.infinity,

          height: 1,

          color: primaryColor,

          margin: EdgeInsets.only(left: 35, right: 35),

        ),

        SizedBox(

          height: 50.0,

          width: double.infinity,

          child: TextButton(

            onPressed: () async {

              Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);

            },

            child: Text(

              "Or continue with",

              style: TextStyle(fontWeight: FontWeight.bold),

            ),

          ),

        ),

        GestureDetector(

            onTap: () {},

            child: Image.asset(

              "images/redsocial1.png",

              height: 45,

            )),

      ],

    );

  }


  textFieldForm(BuildContext context, TextEditingController controller, String title) {

    return Padding(

      padding: EdgeInsets.only(

        right: 20,

        left: 20,

      ),

      child: TextField(

        controller: controller,

        keyboardType: TextInputType.emailAddress,

        decoration: InputDecoration(

          contentPadding: EdgeInsets.only(top: 17, bottom: 17, left: 15),

          enabledBorder:

              OutlineInputBorder(borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(11)),

          border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),

          labelText: title,

          labelStyle: TextStyle(fontSize: 12.0, color: Colors.black),

        ),

        style: TextStyle(

          fontSize: 14,

        ),

      ),

    );

  }


  buttonForm(BuildContext context, String title, {Function? tap}) {

    return Padding(

      padding: EdgeInsets.only(

        right: 20,

        left: 20,

      ),

      child: SizedBox(

        width: double.infinity,

        child: ElevatedButton(

          onPressed: () async {

            /* var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_no_internet'),
                              ),
                            ),
                          );
                          return;
                        }*/


            tap!();


            //

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

              title,

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

            ),

          ),

        ),

      ),

    );

  }


  buttonFormLine(BuildContext context, String title, bool active, {Function? tap}) {

    return Padding(

      padding: EdgeInsets.only(

        right: 0,

        left: 00,

      ),

      child: SizedBox(

        width: double.infinity,

        child: ElevatedButton(

          onPressed: () async {

            /* var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult != ConnectivityResult.wifi && connectivityResult != ConnectivityResult.mobile) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                Locales.string(context, 'error_no_internet'),
                              ),
                            ),
                          );
                          return;
                        }*/


            tap!();


            //

          },

          style: ButtonStyle(

            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),

            backgroundColor: MaterialStateProperty.all<Color>(active ? Colors.white : secondryColor),

            shape: MaterialStateProperty.all<RoundedRectangleBorder>(

              active == false

                  ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))

                  : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: secondryColor, width: 3)),

            ),

          ),

          child: Padding(

            padding: const EdgeInsets.all(14.0),

            child: Text(

              title,

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: active == false ? Colors.white : secondryColor),

            ),

          ),

        ),

      ),

    );

  }


  buttonFormWhite(BuildContext context, String title, {Function? tap}) {

    return Padding(

      padding: EdgeInsets.only(

        right: 20,

        left: 20,

      ),

      child: SizedBox(

        width: double.infinity,

        child: ElevatedButton(

          onPressed: () async {

            tap!();


            //

          },

          style: ButtonStyle(

            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),

            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),

            shape: MaterialStateProperty.all<RoundedRectangleBorder>(

              RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(12),

              ),

            ),

          ),

          child: Padding(

            padding: const EdgeInsets.all(14.0),

            child: Text(

              title,

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),

            ),

          ),

        ),

      ),

    );

  }

}


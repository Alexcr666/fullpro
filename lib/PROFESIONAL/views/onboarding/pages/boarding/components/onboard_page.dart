import 'package:flutter/material.dart';

import 'package:fullpro/PROFESIONAL/provider/Appdata.dart';

import 'package:fullpro/PROFESIONAL/views/Authentication/register.dart';

import 'package:fullpro/PROFESIONAL/views/onboarding/pages/boarding/model/onboard_page_model.dart';


import 'package:provider/provider.dart';


import 'drawer_paint.dart';


import 'package:fullpro/styles/statics.dart' as appcolors;


class OnboardPage extends StatefulWidget {

  final PageController pageController;


  final OnboardPageModel pageModel;


  final String page;


  const OnboardPage({Key? key, required this.pageModel, required this.pageController, required this.page}) : super(key: key);


  @override

  _OnboardPageState createState() => _OnboardPageState();

}


class _OnboardPageState extends State<OnboardPage> with SingleTickerProviderStateMixin {

  late AnimationController animationController;


  late Animation<double> heroAnimation;


  late Animation<double> borderAnimation;


  @override

  void initState() {

    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));


    heroAnimation = Tween<double>(begin: -40, end: 0).animate(CurvedAnimation(parent: animationController, curve: Curves.bounceOut));


    borderAnimation = Tween<double>(begin: 75, end: 50).animate(CurvedAnimation(parent: animationController, curve: Curves.bounceOut));


    animationController.forward(from: 0);


    super.initState();

  }


  @override

  void dispose() {

    animationController.dispose();


    super.dispose();

  }


  _nextButtonPressed() {

    // print('next button pressed');


    int previousPage = int.parse(widget.page);


    if (previousPage == 3) {

      Navigator.pushNamedAndRemoveUntil(context, Register.id, (route) => false);

    } else {

      Provider.of<AppData>(context, listen: false).color = widget.pageModel.nextAccentColor;


      widget.pageController.nextPage(

        duration: const Duration(

          microseconds: 100,

        ),

        curve: Curves.fastLinearToSlowEaseIn,

      );

    }

  }


  @override

  Widget build(BuildContext context) {

    return Stack(

      children: <Widget>[

        Container(

          color: widget.pageModel.primeColor,

          child: Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: <Widget>[

              const SizedBox(height: 50),

              SizedBox(

                height: 280,

                child: Image.asset(widget.pageModel.imagePath),

              ),

              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 32.0),

                child: SizedBox(

                  height: 250.0,

                  width: double.infinity,

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[

                      Padding(

                        padding: const EdgeInsets.symmetric(vertical: 8.0),

                        child: Text(

                          widget.pageModel.caption,

                          style: TextStyle(

                            fontSize: 24.0,

                            letterSpacing: 1,

                            color: widget.pageModel.nextAccentColor.withOpacity(0.8),

                            fontStyle: FontStyle.normal,

                            decoration: TextDecoration.none,

                            fontFamily: 'Brand-Bold',

                          ),

                        ),

                      ),

                      Padding(

                        padding: const EdgeInsets.symmetric(vertical: 8.0),

                        child: Text(

                          widget.pageModel.description,

                          style: const TextStyle(

                            fontSize: 17.0,

                            color: appcolors.colorTextLight,

                            decoration: TextDecoration.none,

                            fontFamily: 'Brand-Regular',

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

        Align(

          alignment: Alignment.centerRight,

          child: AnimatedBuilder(

            animation: borderAnimation,

            builder: (context, child) {

              return CustomPaint(

                painter: DrawerPaint(

                  curveColor: widget.pageModel.accentColor,

                ),

                child: SizedBox(

                  width: borderAnimation.value,

                  height: double.infinity,

                  child: Align(

                    alignment: Alignment.bottomRight,

                    child: Padding(

                      padding: const EdgeInsets.only(bottom: 24.0),

                      child: GestureDetector(

                        child: Icon(

                          Icons.arrow_forward,

                          color: widget.pageModel.primeColor,

                          size: 40.0,

                        ),

                        onTap: _nextButtonPressed,

                      ),

                    ),

                  ),

                ),

              );

            },

          ),

        ),

      ],

    );

  }

}


import 'package:flutter/material.dart';

import 'package:fullpro/PROFESIONAL/views/onboarding/pages/boarding/components/onboard_page.dart';

import 'package:fullpro/PROFESIONAL/views/onboarding/pages/boarding/data/onboard_page_data.dart';


import '../../../Authentication/register.dart';


class Onboarding extends StatelessWidget {

  static const String id = 'boarding';


  final PageController pageController = PageController();


  String currentpage = '0';


  Onboarding({Key? key}) : super(key: key);


  @override

  Widget build(BuildContext context) {

    _onPageViewChange(int page) {

      currentpage = page.toString();


      // print(currentpage);

    }


    return Stack(

      children: [

        PageView.builder(

          controller: pageController,

          onPageChanged: _onPageViewChange,

          physics: const AlwaysScrollableScrollPhysics(),

          itemCount: onboardData.length,

          itemBuilder: (context, index) {

            return OnboardPage(

              pageController: pageController,

              pageModel: onboardData[index],

              page: currentpage,

            );

          },

        ),

        Padding(

          padding: const EdgeInsets.only(top: 35),

          child: SizedBox(

            // Act as a banner


            width: double.infinity,


            height: 70,


            child: Align(

              alignment: Alignment.bottomCenter,

              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                crossAxisAlignment: CrossAxisAlignment.center,

                textBaseline: TextBaseline.alphabetic,

                children: <Widget>[

                  Padding(

                    padding: const EdgeInsets.only(left: 20.0),

                    child: Image.asset('images/logo.png', width: 110),

                  ),

                  Padding(

                    padding: const EdgeInsets.only(right: 32.0),

                    child: TextButton(

                      onPressed: () {

                        Navigator.pushNamedAndRemoveUntil(context, Register.id, (route) => false);

                      },

                      child: Text(

                        'Skip',

                        style: Theme.of(context).textTheme.headline6?.copyWith(

                              color: Colors.black,

                            ),

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ),

        ),

      ],

    );

  }

}


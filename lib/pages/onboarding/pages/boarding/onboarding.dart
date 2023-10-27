import 'package:flutter_locales/flutter_locales.dart';

import 'package:fullpro/pages/onboarding/pages/boarding/model/onboard_page_model.dart';

import 'package:fullpro/pages/Authentication/register.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:fullpro/pages/onboarding/pages/boarding/components/onboard_page.dart';

import 'package:fullpro/pages/onboarding/pages/boarding/components/page_view_indicator.dart';

import 'package:fullpro/pages/onboarding/pages/boarding/data/onboard_page_data.dart';

import 'package:fullpro/provider/Appdata.dart';


class Onboarding extends StatelessWidget {

  static const String id = 'boarding';

  final PageController pageController = PageController();

  String currentpage = '0';


  @override

  Widget build(BuildContext context) {

    AppData colorProvider = Provider.of<AppData>(context);


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

                        Locales.string(context, 'lbl_skip'),

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

        // Align(

        //   alignment: Alignment.bottomLeft,

        //   child: Padding(

        //     padding: const EdgeInsets.only(bottom: 80.0, left: 40.0),

        //     child: PageViewIndicator(

        //       controller: pageController,

        //       itemCount: onboardData.length,

        //       color: Colors.black,

        //     ),

        //   ),

        // ),

      ],

    );

  }

}


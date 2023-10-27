import 'dart:ui';

import 'package:fullpro/config.dart';

import 'package:fullpro/pages/onboarding/pages/boarding/model/onboard_page_model.dart';

import 'package:fullpro/styles/statics.dart' as Static;


List<OnboardPageModel> onboardData = [

  OnboardPageModel(

    const Color.fromARGB(255, 255, 255, 255),

    Static.themeColor[500]!,

    const Color.fromARGB(255, 34, 43, 69),

    2,

    'images/boarding_01.gif',

    'Welcome to $appName',

    '',

    '$appName App is an unrivaled online marketplace connecting home maintenance and handyman service providers and users',

  ),

  OnboardPageModel(

    const Color.fromARGB(255, 255, 255, 255),

    const Color.fromARGB(255, 0, 148, 247),

    const Color.fromARGB(255, 34, 43, 69),

    1,

    'images/boarding_04.gif',

    'Get Instant Solution',

    '',

    '$appName App Provide Instant Solution with it\'s talented professionals.',

  ),

  OnboardPageModel(

    const Color.fromARGB(255, 255, 255, 255),

    const Color.fromARGB(255, 222, 193, 89),

    const Color.fromARGB(255, 34, 43, 69),

    2,

    'images/boarding_02.gif',

    'Track your Order',

    '',

    'No More Wait! Easily track order with $appName order tracking system.',

  ),

];


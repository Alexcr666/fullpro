import 'package:flutter/material.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/pages/homepage.dart';

class Loader {
  static void page(BuildContext context, Widget pageNavigation) {
    showGeneralDialog(
      barrierDismissible: false,
      transitionDuration: pageLoad_Animation,
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return pageNavigation;
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  static void PagewithHome(BuildContext context, Widget pageNavigation) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => pageNavigation),
      ModalRoute.withName(kHomePage.id),
    );
  }
}

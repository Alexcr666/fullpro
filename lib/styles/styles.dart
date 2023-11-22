import 'package:flutter/material.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

final kDrawerItemStyle = TextStyle(fontSize: 16, color: Colors.black);

gradientColor() {
  return BoxDecoration(
    //  borderRadius: BorderRadius.circular(10),
    gradient: LinearGradient(
        colors: [
          secondryColor,
          primaryColor,
        ],
        begin: const FractionalOffset(1.0, 0.0),
        end: const FractionalOffset(1.0, 1.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
  );
}

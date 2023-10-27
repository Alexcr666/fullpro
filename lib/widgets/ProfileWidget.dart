import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fullpro/styles//statics.dart' as static_colors;

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = static_colors.themeColor[500];

    return Center(
      child: Stack(
        children: [
          buildImage(),
          // Positioned(
          //   bottom: 0,
          //   right: 4,
          //   child: GestureDetector(
          //     onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text('Will be available soon'))),
          //     child: buildEditIcon(color!),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Image.asset(
          'images/user_icon.png',
          height: 128,
          width: 128,
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

// ignore_for_file: prefer_const_constructors, file_names
import 'package:flutter/material.dart';
import 'package:fullpro/styles/statics.dart' as appcolors;

class ProgressDialog extends StatelessWidget {
  final String? status;
  const ProgressDialog({Key? key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(appcolors.colorAccent),
              ),
              SizedBox(
                width: 25.0,
              ),
              Text(
                '$status',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

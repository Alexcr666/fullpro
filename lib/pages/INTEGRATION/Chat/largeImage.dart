import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/widgets/widget.dart';

class LargeImage extends StatelessWidget {
  final largeImage;

  LargeImage(this.largeImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, automaticallyImplyLeading: false, backgroundColor: secondryColor),
        backgroundColor: secondryColor,
        body: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)), color: Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      AppWidget().back(context),
                      CachedNetworkImage(
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(
                          child: CupertinoActivityIndicator(
                            radius: 20,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: MediaQuery.of(context).size.height * .75,
                        width: MediaQuery.of(context).size.width,
                        imageUrl: largeImage ?? '',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}

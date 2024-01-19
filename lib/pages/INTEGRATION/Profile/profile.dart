import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:fullpro/pages/INTEGRATION/Profile/EditProfile.dart';

import 'package:fullpro/pages/INTEGRATION/Profile/settings.dart';

import 'package:fullpro/pages/INTEGRATION/information.dart';

import 'package:fullpro/pages/INTEGRATION/models/user_model.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

final List adds = [
  {
    'icon': Icons.whatshot,
    'color': Colors.indigo,
    'title': "Get matches faster".toString(),
    'subtitle': "Boost your profile once a month".toString(),
  },
  {
    'icon': Icons.favorite,
    'color': Colors.lightBlueAccent,
    'title': "more likes".toString(),
    'subtitle': "Get free rewindes".toString(),
  },
  {
    'icon': Icons.star_half,
    'color': Colors.amber,
    'title': "Increase your chances".toString(),
    'subtitle': "Get unlimited free likes".toString(),
  },
  {
    'icon': Icons.location_on,
    'color': Colors.purple,
    'title': "Swipe around the world".toString(),
    'subtitle': "Passport to anywhere with fullpro".toString(),
  },
  {
    'icon': Icons.vpn_key,
    'color': Colors.orange,
    'title': "Control your profile".toString(),
    'subtitle': "highly secured".toString(),
  }
];

class Profile extends StatefulWidget {
  final User currentUser;

  final bool isPuchased;

  //final Map items;

  // final List<PurchaseDetails> purchases;

  Profile(this.currentUser, this.isPuchased);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final EditProfileState _editProfileState = EditProfileState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)), color: Colors.white),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Hero(
              tag: "abc",
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: secondryColor,
                  child: Material(
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Info(widget.currentUser, widget.currentUser, null);
                              }),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                80,
                              ),
                              child: CachedNetworkImage(
                                height: 150,
                                width: 150,
                                fit: BoxFit.fill,
                                imageUrl: widget.currentUser.imageUrl!.length > 0 ? widget.currentUser.imageUrl![0] ?? '' : '',
                                useOldImageOnUrlChange: true,
                                placeholder: (context, url) => CupertinoActivityIndicator(
                                  radius: 15,
                                ),
                                errorWidget: (context, url, error) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.error,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    Text(
                                      "Enable to load".toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            color: primaryColor,
                            child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(
                                  Icons.photo_camera,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _editProfileState.source(context, widget.currentUser, true);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              widget.currentUser.name != null && widget.currentUser.age != null
                  ? "${widget.currentUser.name}, ${widget.currentUser.age}"
                  : "",
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 30),
            ),
            Text(
              widget.currentUser.editInfo!['job_title'] != null
                  ? "${widget.currentUser.editInfo!['job_title']}  ${widget.currentUser.editInfo!['company'] != null ? "at ${widget.currentUser.editInfo!['company']}" : ""}"
                  : "",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 20),
            ),
            Text(
              widget.currentUser.editInfo!['university'] != null ? "${widget.currentUser.editInfo!['university']}" : "",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 20),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .45,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70,
                            width: 70,
                            child: FloatingActionButton(
                                heroTag: UniqueKey(),
                                splashColor: secondryColor,
                                backgroundColor: primaryColor,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  _editProfileState.source(context, widget.currentUser, false);
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Add media".toString(),
                              style: TextStyle(color: secondryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 30, top: 60),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                                splashColor: secondryColor,
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.settings,
                                  color: secondryColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          maintainState: true, builder: (context) => Settings(widget.currentUser, widget.isPuchased)));
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Settings".toString(),
                                style: TextStyle(color: secondryColor),
                              ),
                            )
                          ],
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(right: 30, top: 60),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                                heroTag: UniqueKey(),
                                splashColor: secondryColor,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: secondryColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => EditProfile(widget.currentUser)));
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Edit Info".toString(),
                                style: TextStyle(color: secondryColor),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 210),
                    child: Container(
                      height: 120,
                      child: CustomPaint(
                        //   painter: CurvePainter(),

                        size: Size.infinite,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = secondryColor.withOpacity(.4);

    paint.style = PaintingStyle.stroke;

    paint.strokeWidth = 1.5;

    var startPoint = Offset(0, -size.height / 2);

    var controlPoint1 = Offset(size.width / 4, size.height / 3);

    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);

    var endPoint = Offset(size.width, -size.height / 2);

    var path = Path();

    path.moveTo(startPoint.dx, startPoint.dy);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

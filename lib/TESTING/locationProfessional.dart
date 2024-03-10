import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../PROFESIONAL/views/homepage.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String longitude = "";
  String latitude = "";
  late StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      setState(() {
        longitude = position!.longitude.toString();
        latitude = position.latitude.toString();

        userInfoPartners!.ref.update({"latitude": latitude, "longitude": longitude});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Longitude:: $longitude"),
        Text("Latitude:: $latitude"),
      ],
    ))));
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart' as cloud;

import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/TESTING/locationProfessional.dart';

import 'package:fullpro/const.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/utils/utils.dart';

import 'package:fullpro/widgets/widget.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_formatter/money_formatter.dart';

import 'package:provider/provider.dart';

import 'package:fullpro/animation/fadeBottom.dart';

import 'package:fullpro/animation/fadeRight.dart';

import 'package:fullpro/animation/fadeTop.dart';

import 'package:fullpro/animation/FadeLeft.dart';

import 'package:fullpro/config.dart';

import 'package:fullpro/utils/globalConstants.dart';

import 'package:fullpro/controller/cartController.dart';

import 'package:fullpro/controller/fireController.dart';

import 'package:fullpro/controller/mainController.dart';

import 'package:fullpro/controller/loader.dart';

import 'package:fullpro/models/cartservices.dart';

import 'package:fullpro/models/nearbyPartner.dart';

import 'package:fullpro/pages/profile/addresses.dart';

import 'package:fullpro/provider/Appdata.dart';

import 'package:fullpro/styles/statics.dart' as Static;

import 'package:intl/src/intl/date_format.dart' show DateFormat;

import 'package:fullpro/utils/userpreferences.dart';

import 'package:fullpro/widgets/DataLoadedProgress.dart';

import 'package:fullpro/widgets/calender/DatePicker.dart';

import 'package:fullpro/widgets/calender/timerSlider.dart';

import 'package:collection/collection.dart';

class DetailsOrderProfessionalPage extends StatefulWidget {
  DetailsOrderProfessionalPage({Key? key, required this.dataList}) : super(key: key);

  DataSnapshot dataList;

  @override
  _DetailsOrderProfessionalPageState createState() => _DetailsOrderProfessionalPageState();
}

/////LOCATION
///
String longitude = "";
String latitude = "";
late StreamSubscription<Position> _positionStream;

////////
DataSnapshot? dataUser;
DataSnapshot? dataProfessional;
Set<Marker> _marker = <Marker>{};
String distanceInMeter = "0";
String timeDistance = "0";
const kGoogleApiKey = "AIzaSyDBes8BJVASNyCE0hLJjt0Rcaz6BodoKJU";

class _DetailsOrderProfessionalPageState extends State<DetailsOrderProfessionalPage> {
  String hourService = "";
  Set<Marker> _marker = <Marker>{};
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime dateTime = DateTime.now();

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  String showMe = "woman";

  int days = 10;

  Timer? timer;

  late final _probController = TextEditingController();

  late final _descriptionController = TextEditingController();
  late final _descriptionCommentController = TextEditingController();
  String problmValidate = '';

  DataSnapshot? dataListObjectGeneral;

  ///   Nearby Parnters Variables

  List<NearbyPartner> availablePartners = [];

  bool nearbtPartnerKeysLoaded = false;

  bool isRequestingLocationDetails = false;

  /*void findPartner() {

    if (availablePartners.isEmpty) {

      print('No Partner Found');


      return;

    }


   


  }*/

  void notifyPartner(NearbyPartner driver) {
    // Get and notify Partner using token

    DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child('partners').child(driver.key!);

    tokenRef.once().then((e) async {
      final dataSnapshot = e.snapshot;

      if (dataSnapshot.value != null) {
        var token = dataSnapshot.child('token').value.toString();

        String category = dataSnapshot.child('category').value.toString().replaceAll('[', '').replaceAll(']', '');

        debugPrint(category.toString());

        DatabaseReference itemsRef = FirebaseDatabase.instance.ref().child('requests').child(orderRef!.key!);

        itemsRef.once().then((e) {
          final _dataSnapshot = e.snapshot;

          // Get Request Last Items Name

          List<dynamic> namesList = _dataSnapshot.child('itemsNames').value as List;

          final lastItemName = namesList.lastOrNull;

          debugPrint(lastItemName);

          // Get Request First Items Name

          if (category.contains(lastItemName)) {
            // send notification to sepecified Partner

            if (itemNamesList.isNotEmpty) {
              MainController.sendNotification(
                  token,
                  context,
                  orderRef?.key,
                  _dataSnapshot
                      .child('itemsNames')
                      .value
                      .toString()
                      .replaceAll(']', '')
                      .replaceAll('[', '')
                      .replaceAll('_', ' ')
                      .toUpperCase());

              // }
            }
          }
        });
      } else {
        return;
      }

      //select the next closest partner

      //findPartner();
    });
  }

  // Time Selector

  List<RadioModel> hourList = [
    RadioModel(true, '7AM - 8AM'),
    RadioModel(false, '8AM - 9AM'),
    RadioModel(false, '9AM - 10AM'),
    RadioModel(false, '10AM - 11AM'),
    RadioModel(false, '11AM - 12PM'),
    RadioModel(false, '12PM - 1PM'),
    RadioModel(false, '1PM - 2PM'),
    RadioModel(false, '2PM - 3PM'),
    RadioModel(false, '3PM - 4PM'),
    RadioModel(false, '4PM - 5PM'),
    RadioModel(false, '5PM - 6PM'),
    RadioModel(false, '6PM - 7PM'),
    RadioModel(false, '8PM - 8PM'),
    RadioModel(false, '9PM - 9PM'),
    RadioModel(false, '10PM - 10PM'),
    RadioModel(false, '11PM - 12PM'),
    RadioModel(false, '12AM - 1AM'),
    RadioModel(false, '1AM - 2AM'),
    RadioModel(false, '2AM - 3AM'),
    RadioModel(false, '3AM - 4AM'),
    RadioModel(false, '4AM - 5AM'),
    RadioModel(false, '5AM - 6AM'),
    RadioModel(false, '6AM - 7AM'),
  ];

  // END

  void startGeofireListener() {
    Geofire.initialize('partnersAvailable');

    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 20)?.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyPartner _nearbyPartner = NearbyPartner();

            _nearbyPartner.key = map['key'];

            _nearbyPartner.latitude = map['latitude'];

            _nearbyPartner.longitude = map['longitude'];

            debugPrint('geofire Entered');

            FireController.nearbyPartnerList.add(_nearbyPartner);

            break;

          case Geofire.onKeyExited:
            debugPrint('geofire Exit');

            FireController.removeFromList(map['key']);

            break;

          case Geofire.onKeyMoved:

            // Update your key's location

            NearbyPartner _nearbyPartner = NearbyPartner();

            _nearbyPartner.key = map['key'];

            _nearbyPartner.latitude = map['latitude'];

            _nearbyPartner.longitude = map['longitude'];

            debugPrint('geofire moved');

            FireController.updateNearbyLocation(_nearbyPartner);

            break;

          case Geofire.onGeoQueryReady:
            debugPrint('ready geofire');

            break;
        }
      }
    });
  }

  void _initMarkers(String title, double lat, double long) {
    _marker.clear();

    _marker.add(
      new Marker(
        markerId: MarkerId("professional"),
        infoWindow: InfoWindow(title: title),
        position: LatLng(lat, long),
        onTap: () {},
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    MarkerId markerId = MarkerId(dataListObjectGeneral!.key.toString());
    _marker.add(
      new Marker(
        markerId: markerId,
        position: LatLng(double.parse(dataListObjectGeneral!.child("latitude").value.toString()),
            double.parse(dataListObjectGeneral!.child("longitude").value.toString())),
        onTap: () {
          // Handle on marker tap
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.ref("ordens/" + widget.dataList.key.toString());

    Stream<DatabaseEvent> stream = ref.onValue;

    getData();
    changeLocationRealtime() {
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

    stream.listen((DatabaseEvent event) {
      widget.dataList = event.snapshot;

      try {
        setState(() {});
      } catch (e) {}

      DatabaseReference refClient = FirebaseDatabase.instance.ref("partners/" + widget.dataList.child("professional").value.toString());

      Stream<DatabaseEvent> streamClient = refClient.onValue;

      streamClient.listen((DatabaseEvent event) async {
        DataSnapshot dataProfessional = event.snapshot;
        if (widget.dataList.child("state").value.toString() == "3") {
          _initMarkers(dataProfessional.child("name").value.toString(), double.parse(dataProfessional.child("latitude").value.toString()),
              double.parse(dataProfessional.child("longitude").value.toString()));
        } else {
          _marker.clear();
          _initMarkers("", 0, 0);
        }

        distanceInMeter = await Geolocator.distanceBetween(
                double.parse(widget.dataList.child("latitude").value.toString()),
                double.parse(widget.dataList.child("longitude").value.toString()),
                double.parse(dataProfessional.child("latitude").value.toString()),
                double.parse(dataProfessional.child("longitude").value.toString()))
            .toString();

        getTime() async {
          String latitude1 = widget.dataList.child("latitude").value.toString();
          String longitude1 = widget.dataList.child("longitude").value.toString();
          String latitude2 = dataProfessional.child("latitude").value.toString();
          String longitude2 = dataProfessional.child("longitude").value.toString();

          Dio dio = new Dio();
          Response response = await dio.get(
              "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$latitude1,$longitude1&destinations=$latitude2%2C,$longitude2&key=$_kGooglePlex");
          print("timehour: " + response.data.toString());
        }

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {});
        });
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {});
      changeLocationRealtime();
    });
  }

  @override
  void dispose() {
    super.dispose();

    cartItemsList.clear();

    cartDataLoaded = false;

    cartListLoaded = false;

    timer?.cancel();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Widget pageOrdens() {
    return FutureBuilder(
        future: FirebaseDatabase.instance.ref().child('ordens').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            DataSnapshot? dataListObject = null;

            for (var i = 0; i < response.snapshot.children.toList().length; i++) {
              DataSnapshot dataList = response.snapshot.children.toList()[i];

              if (dataList.child("user").value.toString() == "LapnDojkb8QGfSOioTXLkiPAiNt2") {
                DataSnapshot dataListObject = dataList;

                Timer.run(() {
                  dataListObjectGeneral = dataListObject;

                  setState(() {});
                });

                //return Text(dataListObject!.child("name").value.toString());

                return ListView.builder(
                    padding: EdgeInsets.only(left: 10.0),
                    itemCount: 1,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          widget.dataList.ref.update({'address': widget.dataList.child("professionalName").value.toString()}).then((value) {
                            Navigator.pop(context);

                            AppWidget().itemMessage("Dirección actualizada", context);
                          }).catchError((onError) {
                            AppWidget().itemMessage("Error actulizar dirección", context);
                          });
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          radius: 30,
                        ),
                        title: Text(widget.dataList.child("professionalName").value.toString()),
                      );
                    });
              }
            }

            return AppWidget().loading(context);
          } else {
            return SizedBox();
          }
        });
  }

  getData() {
    cloud.Query historyRef = FirebaseDatabase.instance.ref().child('ordens').child(widget.dataList.key.toString());

    historyRef.once().then((e) async {
      final snapshot = e.snapshot;
      if (snapshot.value != null) {
        dataListObjectGeneral = snapshot;
        dataListObjectGeneral!.child("comment").value.toString();

        if (widget.dataList.child("professional").value.toString() == FirebaseAuth.instance.currentUser!.uid.toString()) {
          _descriptionCommentController.text = dataListObjectGeneral!.child("commentProfessional").value == null
              ? ""
              : dataListObjectGeneral!.child("commentProfessional").value.toString();
        } else {
          _descriptionCommentController.text = dataListObjectGeneral!.child("commentClient").value == null
              ? ""
              : dataListObjectGeneral!.child("commentClient").value.toString();
        }
        _descriptionController.text =
            dataListObjectGeneral!.child("description").value == null ? "" : dataListObjectGeneral!.child("description").value.toString();

        _controller.future.then((value) {
          value.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 0,
              target: LatLng(double.parse(dataListObjectGeneral!.child("latitude").value.toString()),
                  double.parse(dataListObjectGeneral!.child("longitude").value.toString())),
              zoom: 14.0,
            ),
          ));
        });
        setState(() {});
      }
    });
  }

  Widget getUserProfessional() {
    return dataListObjectGeneral!.child("professional").value == null
        ? AppWidget().loading(context)
        : FutureBuilder(
            future: FirebaseDatabase.instance
                .ref()
                .child('partners')
                .child(dataListObjectGeneral!.child("professional").value.toString())
                .once(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                DatabaseEvent response = snapshot.data;
                dataProfessional = response.snapshot;

                return ListTile(
                  leading: AppWidget().circleProfile(response.snapshot.child("photo").value.toString(), size: 50),
                  title: Text(response.snapshot.child("fullname").value.toString().capitalize()),
                  trailing: GestureDetector(onTap: () {}, child: Icon(Icons.message)),
                  subtitle: RatingBarIndicator(
                      rating: response.snapshot.child("rating").value == null
                          ? 0
                          : double.parse(response.snapshot.child("rating").value.toString()),
                      itemCount: 5,
                      itemSize: 16.0,
                      itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: secondryColor,
                          )),
                );
              } else {
                return SizedBox();
              }
            });
  }

  Widget getUserUser() {
    return dataListObjectGeneral!.child("user").value == null
        ? AppWidget().loading(context)
        : FutureBuilder(
            future: FirebaseDatabase.instance.ref().child('users').child(dataListObjectGeneral!.child("user").value.toString()).once(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                DatabaseEvent response = snapshot.data;
                dataUser = response.snapshot;

                return ListTile(
                  leading: AppWidget().circleProfile(response.snapshot.child("photo").value.toString(), size: 60),
                  title: Text(response.snapshot.child("fullname").value.toString().capitalize()),
                  subtitle: RatingBarIndicator(
                      rating: response.snapshot.child("rating").value == null
                          ? 0
                          : double.parse(response.snapshot.child("rating").value.toString()),
                      itemCount: 5,
                      itemSize: 16.0,
                      itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: secondryColor,
                          )),
                );
              } else {
                return SizedBox();
              }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,

        /*appBar: AppBar(
        centerTitle: true,
        title: Text(
          Locales.string(context, 'lbl_book_service'),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Static.dashboardCard,
        elevation: 0.0,
        toolbarHeight: 70,
        leadingWidth: 100,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: SvgPicture.asset('images/svg_icons/arrowLeft.svg'),
        ),
      ),*/

        body: dataListObjectGeneral == null
            ? Container(margin: EdgeInsets.only(top: 200), child: AppWidget().loading(context))
            : widget.dataList == null
                ? AppWidget().loading(context)
                : ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      AppWidget().back(context),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => LocationPage(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                Locales.string(context, 'lbl_overview'),
                                style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 26),
                              ),
                              Expanded(child: SizedBox()),
                              /*   Text(
                        dataListObjectGeneral == null ? "" : "#44",
                        style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 26),
                      ),*/
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      fadeBottom(.6, AddressWidget()),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 250,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                  width: 160,
                                  height: 160,
                                  child: GoogleMap(
                                    markers: _marker,
                                    mapType: MapType.normal,
                                    myLocationEnabled: true,
                                    initialCameraPosition: _kGooglePlex,
                                    onMapCreated: (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                  )))),
                      SizedBox(
                        height: 10,
                      ),
                      widget.dataList.child("state").value.toString() != "3"
                          ? SizedBox()
                          : Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  Text("Distancia estimada :" + double.parse(distanceInMeter).round().toString() + " Millas"),
                                  Text("Duración estimada :" +
                                      ((double.parse(distanceInMeter).round() / 50).round() + 2).toString() +
                                      " Minutos"),
                                  AppWidget().texfieldFormat(
                                    title: Locales.string(context, "lang_description"),
                                    controller: _descriptionController,
                                  ),
                                ],
                              )),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /*  Padding(

              padding: const EdgeInsets.symmetric(vertical: 10),

              child: ListTile(

                title: Text(

                  "Opción de servicio".toString(),

                  style: TextStyle(

                    fontWeight: FontWeight.bold,

                    fontSize: 16,

                    color: secondryColor,

                  ),

                ),

                subtitle: DropdownButton(

                  iconEnabledColor: primaryColor,

                  iconDisabledColor: secondryColor,

                  isExpanded: true,

                  items: [

                    DropdownMenuItem(

                      child: Text("Man".toString()),

                      value: "man",

                    ),

                    DropdownMenuItem(child: Text("Other".toString()), value: "woman"),

                    DropdownMenuItem(child: Text("Other".toString()), value: "other"),

                  ],

                  onChanged: (val) {

                    //  editInfo.addAll({'userGender': val});


                    setState(() {

                      showMe = val.toString();

                    });

                  },

                  value: showMe,

                ),

              ),

            ),*/

                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: double.infinity,
                        height: 1,
                        color: secondryColor,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                          onTap: () {
                            void _showIOS_DatePicker(ctx) {
                              showCupertinoModalPopup(
                                  context: ctx,
                                  builder: (_) => Container(
                                        height: 250,
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 180,
                                              child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode.time,
                                                  initialDateTime: DateTime.now(),
                                                  onDateTimeChanged: (val) {
                                                    hourService = DateFormat('hh:mm:ss').format(val).toString();
                                                  }),
                                            ),
                                            AppWidget().buttonForm(context, Locales.string(context, "lang_saved"), tap: () {
                                              setState(() {
                                                //    final f = new DateFormat('yyyy-MM-dd');

                                                widget.dataList.ref.update({'time': hourService}).then((value) {
                                                  Navigator.pop(context);

                                                  setState(() {});

                                                  AppWidget().itemMessage("Pedido carrito", context);
                                                });

                                                //  dateSelected = val.toString();
                                              });
                                            }),
                                          ],
                                        ),
                                      ));
                            }

                            _showIOS_DatePicker(context);
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                children: [
                                  Text(
                                    Locales.string(context, 'lang_timeservice').toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: secondryColor,
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    widget.dataList.child("time").value == null
                                        ? Locales.string(context, 'lang_nodisponible')
                                        : widget.dataList.child("time").value.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: secondryColor,
                                    ),
                                  )
                                ],
                              ))),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: double.infinity,
                        height: 1,
                        color: secondryColor,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Text(
                                Locales.string(context, 'lang_dateservice').toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondryColor,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                widget.dataList.child("date").value == null
                                    ? Locales.string(context, 'lang_nodisponible')
                                    : widget.dataList.child("date").value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondryColor,
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: double.infinity,
                        height: 1,
                        color: secondryColor,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Text(
                                Locales.string(context, 'lang_hourservicefinal').toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondryColor,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                widget.dataList.child("timeFinal").value == null
                                    ? Locales.string(context, 'lang_nodisponible')
                                    : widget.dataList.child("timeFinal").value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondryColor,
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: double.infinity,
                        height: 1,
                        color: secondryColor,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Text(
                                Locales.string(context, 'lang_dateservicefinal').toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondryColor,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                widget.dataList.child("dateFinal").value == null
                                    ? Locales.string(context, 'lang_nodisponible')
                                    : widget.dataList.child("dateFinal").value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondryColor,
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      /* ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      radius: 30,
                    ),
                    title: Text(widget.dataList.child("professionalName").value.toString()),
                  ),*/
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.dataList.child("professional").value.toString() != FirebaseAuth.instance.currentUser!.uid.toString()
                                    ? "Profesional"
                                    : "Usuario".toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondryColor,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      widget.dataList.child("professional").value.toString() != FirebaseAuth.instance.currentUser!.uid.toString
                          ? getUserProfessional()
                          : getUserUser(),
                      SizedBox(
                        height: 15,
                      ),
                      initWidget(),
                    ],
                  ));
  }

  //  Initialization

  //

  Widget imageEvidencia(int state) {
    return GestureDetector(
        onTap: () async {
          ImagePicker imagePicker = ImagePicker();

          var image = await imagePicker.pickImage(source: ImageSource.gallery);

          FirebaseAuth user = FirebaseAuth.instance;

          int timestamp = new DateTime.now().millisecondsSinceEpoch;

          Reference storageReference =
              FirebaseStorage.instance.ref().child('ordens/' + user.currentUser!.uid.toString() + timestamp.toString() + '.jpg');

          UploadTask uploadTask = storageReference.putFile(File(image!.path));
          AppWidget().itemMessage("Subiendo...", context);
          await uploadTask.then((p0) async {
            String fileUrl = await storageReference.getDownloadURL();

            dataListObjectGeneral!.ref.update({'photo' + state.toString(): fileUrl}).then((value) {
              setState(() {});

              AppWidget().itemMessage("Foto actualizada", context);
            }).catchError((onError) {
              AppWidget().itemMessage("Error al actualizar foto", context);
            });

            //   _sendImage(messageText: 'Photo', imageUrl: fileUrl);
          }).catchError((onError) {
            print("error: " + onError.toString());
          });
        },
        child: Container(
            margin: EdgeInsets.only(left: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Colors.grey.withOpacity(0.4),
                  width: 110,
                  height: 110,
                  child: dataListObjectGeneral!.child('photo' + state.toString()).value == null
                      ? SizedBox()
                      : Image.network(
                          dataListObjectGeneral!.child('photo' + state.toString()).value.toString(),
                          fit: BoxFit.cover,
                        ),
                ))));
  }

  Widget itemMoney(String title, String value) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          children: [
            Text(
              title.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: secondryColor,
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: secondryColor,
                  ),
                )),
          ],
        ));
  }

  getTotalPay() {
    int total = 0;

    for (var i = 0; i < widget.dataList!.child("services").children.toList().length; i++) {
      var data = widget.dataList!.child("services").children.toList()[i];
      total += int.parse(data.child("price").value.toString());
    }

    // total += (int.parse(dataListObjectGeneral!.child("price").value.toString()) / 10).round();
    /* if (dataListObjectGeneral != null) {
      total = int.parse(dataListObjectGeneral!.child("price").value.toString());

      total += (int.parse(dataListObjectGeneral!.child("price").value.toString()) / 20).round();

      total += (int.parse(dataListObjectGeneral!.child("price").value.toString()) / 10).round();
    }*/

    return total;
  }

  Widget initWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* if (cartItemsList.isNotEmpty)
          fadeLeft(
            0.1,
            dateRangeSlider(),
          )
        else
          const SizedBox(),*/

        //  fadeRight(0.3, timeRangeSlider()),

        /*fadeTop(0.5, removeAllButton()),
        CartItems(),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          height: 1,
          color: secondryColor,
        ),
        SizedBox(
          height: 10,
        ),

        fadeBottom(.6, pricingList()),
        fadeBottom(.6, probWidget()),*/
        SizedBox(
          height: 15,
        ),

        Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Locales.string(context, 'lang_services').toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: secondryColor,
                  ),
                ),
              ],
            )),
        SizedBox(
          height: 15,
        ),
        ListView.builder(
            padding: EdgeInsets.only(left: 10.0),
            itemCount: widget.dataList!.child("services").children.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var data = widget.dataList!.child("services").children.toList()[index];
              return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: AppWidget().circleProfile(data.child("foto").value.toString(), size: 50),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.child("name").value.toString().capitalize(),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        data.child("price").value == null
                            ? Text('\$ ' + "0")
                            : Text(
                                '\$ ' +
                                    MoneyFormatter(amount: double.parse(data.child("price").value.toString()))
                                        .output
                                        .withoutFractionDigits
                                        .toString(),
                                style: TextStyle(fontSize: 14),
                              )
                      ],
                    ),
                  ));
            }),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              Locales.string(context, 'lbl_overview'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: secondryColor,
              ),
            )),

        SizedBox(
          height: 10,
        ),

        itemMoney(
            Locales.string(context, 'lang_costservice'),
            '\$' +
                MoneyFormatter(amount: double.parse(((getTotalPay() - (int.parse(getTotalPay().toString())) / 10)).toString()))
                    .output
                    .withoutFractionDigits
                    .toString()),

        itemMoney(
            Locales.string(context, 'lang_tarifaservice'),
            '\$' +
                MoneyFormatter(amount: double.parse((int.parse(getTotalPay().toString()) / 10).toString()))
                    .output
                    .withoutFractionDigits
                    .toString()),

        SizedBox(
          height: 30,
        ),
        // Text(widget.dataList.child("state").value.toString()),

        widget.dataList.child("professional").value.toString() != FirebaseAuth.instance.currentUser!.uid.toString()
            ? SizedBox()
            : /* int.parse(widget.dataList.child("state").value.toString()) < 1
                ? SizedBox()
                : */
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  widget.dataList.child("state").value.toString() != "5"
                      ? SizedBox()
                      : Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  Locales.string(context, "lang_evidence"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: secondryColor,
                                  ),
                                )),
                            Container(
                                height: 120,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        imageEvidencia(0),
                                        imageEvidencia(1),
                                        imageEvidencia(2),
                                        imageEvidencia(3),
                                      ],
                                    )))
                          ],
                        ),
                ],
              ),

        SizedBox(
          height: 10,
        ),

        widget.dataList.child("state").value.toString() != "5" /*|| widget.dataList.child("state").value.toString() != "4"*/

            ? SizedBox()
            : Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(
                      "Valoración".toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: secondryColor,
                      ),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    RatingBar.builder(
                      initialRating:
                          widget.dataList.child("professional").value.toString() != FirebaseAuth.instance.currentUser!.uid.toString()
                              ? widget.dataList.child("ratingClient").value == null
                                  ? 0
                                  : double.parse(widget.dataList.child("ratingClient").value.toString())
                              : widget.dataList.child("ratingProfessional").value == null
                                  ? 0
                                  : double.parse(widget.dataList.child("ratingProfessional").value.toString()),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        size: 23,
                        color: secondryColor,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);

                        /*   if (widget.dataList.child("professional").value.toString() == FirebaseAuth.instance.currentUser!.uid.toString()) {
                          double totalFun = rating;
                          if (dataProfessional!.child("rating").value != null) {
                            double total = double.parse((dataProfessional!.child("rating").value.toString()));
                            totalFun = (total + rating) / 2;
                          }
                          dataProfessional!.ref.update({'rating': totalFun});
                          log("prueba12:");
                        } else {
                          double totalFun = rating;
                          if (dataUser!.child("rating").value != null) {
                            double total = double.parse(dataUser!.child("rating").value.toString());
                            totalFun = (total + rating) / 2;
                          }
                          dataUser!.ref.update({'rating': totalFun});
                          log("prueba12:");
                        }*/
                        Future.delayed(const Duration(seconds: 1), () {});

                        if (widget.dataList.child("professional").value.toString() == FirebaseAuth.instance.currentUser!.uid.toString()) {
                          double totalFun = rating;

                          widget.dataList.ref.update({'ratingProfessional': totalFun});
                        } else {
                          double totalFun = rating;

                          widget.dataList.ref.update({'ratingClient': totalFun});
                        }
                      },
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: AppWidget().texfieldFormat(
                              title: Locales.string(context, "lang_description"), controller: _descriptionCommentController),
                        ),
                        Container(
                            width: 110,
                            height: 60,
                            child: AppWidget().buttonFormColor(context, Locales.string(context, 'lbl_send'), secondryColor, tap: () {
                              if (widget.dataList.child("professional").value.toString() ==
                                  FirebaseAuth.instance.currentUser!.uid.toString()) {
                                widget.dataList.ref.update({'commentProfessional': _descriptionCommentController.text}).then((value) {
                                  AppWidget().itemMessage("Actualizado", context);
                                });
                              } else {
                                widget.dataList.ref.update({'commentClient': _descriptionCommentController.text}).then((value) {
                                  AppWidget().itemMessage("Actualizado", context);
                                });
                              }
                            })),
                      ],
                    ),
                  ],
                )),

        /*RatingBarIndicator(

            rating: 2.5,

            itemCount: 5,

            itemSize: 30.0,

            itemBuilder: (context, _) => Icon(

                  Icons.star_border_rounded,

                  color: secondryColor,

                )),*/

        SizedBox(
          height: 10,
        ),

        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total servicio",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: secondryColor,
                  ),
                ),
                Text(
                  '\$' + MoneyFormatter(amount: double.parse(getTotalPay().toString())).output.withoutFractionDigits.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: secondryColor,
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            Column(
              children: [
                Container(
                    width: 220,
                    child: AppWidget().buttonFormColor(
                        context,
                        getStateOrder(context, int.parse(widget.dataList.child("state").value.toString())),
                        stateOrderColor[int.parse(widget.dataList.child("state").value.toString())], tap: () {
                      showAlertDialog() {
                        // set up the AlertDialog

                        changeState(int state) {
                          Navigator.pop(context);

                          widget.dataList.ref.update({'state': state}).then((value) {
                            setState(() {});

                            AppWidget().itemMessage("Actualizado", context);
                          }).catchError((onError) {
                            setState(() {});

                            AppWidget().itemMessage("Actualizado", context);
                          });
                        }

                        // show the dialog

                        showDialog(
                          context: context,
                          builder: (BuildContext contextAlert) {
                            return AlertDialog(
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /* AppWidget().buttonFormColor(context, stateOrder[0], stateOrderColor[0], tap: () {
                                    changeState(0);
                                  }),*/
                                  AppWidget().buttonFormColor(context, getStateOrder(context, 1), stateOrderColor[1], tap: () {
                                    changeState(1);
                                  }),
                                  AppWidget().buttonFormColor(context, getStateOrder(context, 2), stateOrderColor[2], tap: () {
                                    changeState(2);
                                  }),
                                  AppWidget().buttonFormColor(context, getStateOrder(context, 3), stateOrderColor[3], tap: () {
                                    changeState(3);
                                  }),
                                  AppWidget().buttonFormColor(context, getStateOrder(context, 4), stateOrderColor[4], tap: () {
                                    changeState(4);

                                    CollectionReference docRef = FirebaseFirestore.instance.collection('Users');

                                    twoReference() {
                                      docRef
                                          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                          .collection("Matches")
                                          .doc(widget.dataList.child("user").value.toString())
                                          .get()
                                          .then((value) {
                                        if (value.exists) {
                                          value.reference.delete().then((value) {});
                                        }
                                      });
                                    }

                                    oneReference() {
                                      docRef
                                          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                          .collection("Matches")
                                          .doc(widget.dataList.child("professional").value.toString())
                                          .get()
                                          .then((value) {
                                        if (value.exists) {
                                          value.reference.delete().then((value) {
                                            twoReference();
                                          });
                                        }
                                      });
                                    }
                                  }),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      if (widget.dataList.child("state").value.toString() != "5" &&
                          widget.dataList.child("professional").value.toString() == FirebaseAuth.instance.currentUser!.uid.toString()) {
                        showAlertDialog();
                      }
                    })),
                SizedBox(
                  height: 5,
                ),
                Container(
                    width: 200,
                    child: getCancelButton() == false
                        ? SizedBox()
                        : AppWidget().buttonFormLine(context, Locales.string(context, 'lang_cancel'), true,
                            urlIcon: "images/icons/closeCircle.svg", tap: () {
                            AppWidget().optionsEnabled("¿Estas seguro que quieres cancelar", context, tap2: () {
                              Navigator.pop(context);
                            }, tap: () {
                              Navigator.pop(context);

                              widget.dataList.ref.update({'state': 4}).then((value) {
                                setState(() {});

                                AppWidget().itemMessage("Actualizado", context);
                              }).catchError((onError) {
                                setState(() {});

                                AppWidget().itemMessage("Actualizado", context);
                              });
                            });
                          })),
              ],
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),

        SizedBox(
          height: 20,
        ),

        //  Place Order

        // fadeBottom(.8, PlaceOrderButton()),
      ],
    );
  }

  getCancelButton() {
    bool state = true;

    if (widget.dataList.child("state").value.toString() == "4" || widget.dataList.child("state").value.toString() == "3") {
      state = false;
    }

    return state;
  }

  //  Date Range Slider

  //

  Widget dateRangeSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DatePicker(
          DateTime.now(),
          daysCount: 30,
          height: 75,
          initialSelectedDate: DateTime.now(),
          selectionColor: Static.themeColor[300]!,
          selectedTextColor: Colors.black,
          dateTextStyle: const TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto-Bold',
          ),
          dayTextStyle: const TextStyle(
            fontSize: 11,
          ),
          onDateChange: (date) {
            // New date selected

            setState(() {
              String formattedDate = '${DateFormat.MMMd().format(date)}, ${DateFormat.y().format(date)}';

              kSelectedDate = formattedDate;
            });
          },
        ),
      ],
    );
  }

  //  Time Range Slider

  //

  Widget timeRangeSlider() {
    return cartItemsList.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            height: 70,
            child: TimeSlider(
              onPressed: () {
                print(kselectedTime);
              },
              separation: 5,
              hoursList: hourList,
              height: 37,
              width: 120,
              textColor: Colors.black,
              selectedTextColor: Colors.black,
              colorselectedTime: Static.themeColor[300]!,
              selectedColor: Colors.white,
            ),
          )
        : const SizedBox();
  }

  //  Remove All Items Button

  //

  Widget removeAllButton() {
    return cartItemsList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*Text(
                  Locales.string(context, "lbl_items_list"),
                  style: const TextStyle(),
                ),*/

                Text(
                  "Profesional info".toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: secondryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CartController.removeAllFromCart(context);
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Locales.string(context, "lbl_remove_all"),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  //  Items List

  //

  Widget CartItems() {
    return cartDataLoaded == true && cartListLoaded == true
        ? Container(
            width: double.infinity,
            height: cartItemsList.isNotEmpty ? cartItemsList.length * 110 : 300,
            color: Colors.white,
            child: cartItemsList.isNotEmpty
                ? fadeTop(
                    .5,
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                      itemCount: cartItemsList.length,
                      itemBuilder: (context, index) {
                        return servicesComponent(
                          kServices: cartItemsList[index],
                        );
                      },
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/icons/empty.png',
                            width: MediaQuery.of(context).size.width * .4,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            Locales.string(context, "error_empty_cart"),
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto-Bold',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            Locales.string(context, "error_please_add_services"),
                            style: const TextStyle(
                              color: Static.colorTextDark,
                              fontFamily: 'Brand-Regular',
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          )
        : Container(
            color: Static.dashboardCard,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    DataLoadedProgress(),
                  ],
                ),
              ),
            ),
          );
  }

  //  Items Component

  //

  servicesComponent({required CartServices kServices}) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),

          color: Colors.white,

          //  border: Border.all(color: Colors.black12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 6,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Image Column

                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          kServices.image!,
                          errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey.withOpacity(0.3),
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 30,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            );
                          },
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  // Data Column

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: Text(
                          kServices.name!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        kServices.chargemod!,
                        style: TextStyle(
                          color: secondryColor,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: Row(
                          children: [
                            /* changed kServices.discount! != '0'
                                ? Text(
                                    currencyPos == 'left'
                                        ? '$currencySymbol${int.parse(kServices.price!)}'
                                        : '${int.parse(kServices.price!)}$currencySymbol',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.black,
                                      decorationThickness: 2,
                                    ),
                                  )
                                : const SizedBox(),*/

                            kServices.discount! != '0' ? const SizedBox(width: 15) : const SizedBox(),

                            /*  changed  Text(
                              currencyPos == 'left'
                                  ? '$currencySymbol${int.parse(kServices.price!) - int.parse(kServices.discount!)}'
                                  : '${int.parse(kServices.price!) - int.parse(kServices.discount!)}$currencySymbol',
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                CartController.removeFromCart(context, kServices.key!, kServices.price!, kServices.discount!);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Static.themeColor[500],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: const [
                                    Icon(
                                      FeatherIcons.minus,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            ' ${kServices.quanity}',
                          ),
                          const SizedBox(width: 2),
                          GestureDetector(
                            onTap: () {
                              CartController.getCartData(context, true, kServices.key, kServices.name, kServices.rating, kServices.image,
                                  kServices.chargemod, kServices.price, kServices.discount);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Static.themeColor[500],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const [
                                  Icon(
                                    FeatherIcons.plus,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  Address Widget

  //

  Widget AddressWidget() {
    return //cartItemsList.isNotEmpty

        //  ?

        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              Locales.string(context, 'lang_addressentrega'),
              style: TextStyle(color: secondryColor, fontSize: 14),
            )),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),

              color: Static.dashboardBG,

              //    border: Border.all(color: Colors.black12),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    dataListObjectGeneral!.child("address").value == null
                        ? Locales.string(context, 'lang_nodisponible')
                        : dataListObjectGeneral!.child("address").value.toString()
                    /*
                    /*dataListObjectGeneral == null ? "" : dataListObjectGeneral!.child("address").value.toString()*/ widget.dataList
                                .child("address")
                                .value ==
                            null
                        ? Locales.string(context, 'lang_nodisponible')
                        : widget.dataList.child("address").value.toString()*/
                    ,
                    style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 5),

                /*  GestureDetector(

                    onTap: () {

                      Loader.page(context, const Addresses());

                    },

                    child: Text(

                      Locales.string(context, 'lang_change'),

                      style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 16),

                    )),*/

                /*  SizedBox(
                        width: 45,
                        child: MaterialButton(
                          shape: const CircleBorder(),
                          elevation: 0,
                          highlightElevation: 0,
                          color: Colors.white,
                          padding: const EdgeInsets.all(13),
                          onPressed: () {
                            Loader.page(context, const Addresses());
                          },
                          child: const Icon(
                            FeatherIcons.edit,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),*/
              ],
            ),
          ),
        ),
      ],
    );

    //   : const SizedBox();
  }

  //  Pricing List Widget

  //

  Widget pricingList() {
    return //  Pricing List

        Column(
      children: [
        cartItemsList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  /* decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Static.dashboardBG,
                    border: Border.all(color: Colors.black12),
                  ),*/

                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Locales.string(context, 'lbl_overview'),
                        style: TextStyle(color: secondryColor, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: cartItemsList.isNotEmpty ? cartItemsList.length * 35 : 35,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                          itemCount: cartItemsList.length,
                          itemBuilder: (context, index) {
                            return pricingListComponent(
                              kServices: cartItemsList[index],
                            );
                          },
                        ),
                      ),

                      /*  const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Divider(
                          height: 1.5,
                          color: Colors.black54,
                        ),
                      ),*/

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                Locales.string(context, "lbl_total_price"),
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 17,
                                ),
                              ),

                              const SizedBox(width: 5),

                              //  const Icon(Icons.wallet_outlined)
                            ],
                          ),
                          Text(
                            currencyPos == 'left' ? '$ktotalprice' : '$ktotalprice',
                            style: TextStyle(
                              color: secondryColor,

                              // fontFamily: 'Roboto-Bold',

                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  //  Price List Component

  //

  pricingListComponent({required CartServices kServices}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            kServices.name!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: secondryColor,
            ),
          ),
          Row(
            children: [
              Text(
                kServices.price != null ? "0" : '${int.tryParse(kServices.price!)! - int.tryParse(kServices.discount!)!}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondryColor,
                ),
              ),
              Text(
                ' x ${kServices.quanity!}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Roboto-Bold',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget probWidget() {
    return cartItemsList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Text(
                    Locales.string(context, "lbl_problem_details"),
                    style: TextStyle(fontWeight: FontWeight.bold, color: secondryColor

                        //    fontFamily: 'Roboto-Bold',

                        ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    // border: Border.all(color: Colors.black12),

                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: TextFormField(
                    onChanged: (val) {
                      problmValidate = '';
                    },
                    controller: _probController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      labelText: Locales.string(context, 'lbl_problem'),
                      hintText: Locales.string(context, "lbl_problem_details"),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Locales.string(context, "lbl_enter_problem_details");
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Text(
                    problmValidate,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget PlaceOrderButton() {
    return cartItemsList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 3,
            ),
            child: MaterialButton(
              elevation: 0,
              color: Static.themeColor[500],
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(14),
              minWidth: double.infinity,
              onPressed: () {
                if (_probController.text.isEmpty || _probController.text == '') {
                  problmValidate = Locales.string(context, "error_can_not_be_empty");
                } else {
                  CartController.createRequest(context, _probController.text);

                  // availablePartners = FireController.nearbyPartnerList;

                  // findPartner();
                }
              },
              child: Text(
                Locales.string(context, "lbl_book_service"),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          )
        : const SizedBox();
  }
}

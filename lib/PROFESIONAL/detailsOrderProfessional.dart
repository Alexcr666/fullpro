import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fullpro/const.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/widgets/widget.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.ref("ordens/" + widget.dataList.key.toString());

// Get the Stream

    Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!

    stream.listen((DatabaseEvent event) {
      getData();
      widget.dataList = event.snapshot;

      setState(() {});
    });

    //print("dataorden: " + widget.dataList.value.toString());

    //startGeofireListener();

    // Get Time & Date

    DateTime now = DateTime.now();

    String formattedDate = '${DateFormat.MMMd().format(now)}, ${DateFormat.y().format(now)}';

    kSelectedDate = formattedDate;

    // kselectedTime = '7AM - 8AM';

    // CHeck if Cart Data is Loaded

    if (cartDataLoaded == true && cartItemsList.isEmpty) {
      //  CartController.userCart(context);
    }

    /* if (mounted) {

    //  CartController.checkCart();


      setState(() {

        if (cartDataLoaded == false && cartItemsList.isEmpty) {

          setState(() {

            CartController.userCart(context);

          });

        }


        if (cartDataLoaded == true && cartItemsList.isEmpty) {

          setState(() {

            cartItemsList = Provider.of<AppData>(context, listen: false).userCartData;

          });

        }

      });

    }*/

    // Repeating Function

    /* timer = Timer.periodic(

      repeatTime,

      (Timer t) => setState(() {

        CartController.checkCart();


        CartController.getToatlPrice();


        MainController.getUserInfo(context);

      }),

    );*/
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
                          widget.dataList.ref.update({'address': widget.dataList.child("nameProfessional").value.toString()}).then((value) {
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
                        title: Text(widget.dataList.child("nameProfessional").value.toString()),
                      );
                    });
              }
            }

            return Text("hola");
          } else {
            return SizedBox();
          }
        });
  }

  getData() {
    Query historyRef = FirebaseDatabase.instance.ref().child('ordens').child(widget.dataList.key.toString());

    historyRef.once().then((e) async {
      final snapshot = e.snapshot;
      if (snapshot.value != null) {
        dataListObjectGeneral = snapshot;

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

  Widget getUserUser() {
    return FutureBuilder(
        future: FirebaseDatabase.instance.ref().child('users').child(dataListObjectGeneral!.child("user").value.toString()).once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            return ListTile(
              leading: AppWidget().circleProfile(response.snapshot.child("photo").value.toString()),
              title: Text(response.snapshot.child("fullname").value.toString()),
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

        body: widget.dataList == null
            ? AppWidget().loading()
            : ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  AppWidget().back(context),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Resumen",
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  fadeBottom(.6, AddressWidget()),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                              width: 160,
                              height: 160,
                              child: GoogleMap(
                                markers: _marker,
                                mapType: MapType.normal,
                                initialCameraPosition: _kGooglePlex,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ))),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: AppWidget().texfieldFormat(
                        title: "Apt 501",
                      )),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                                        AppWidget().buttonForm(context, "Guardar", tap: () {
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
                                "Hora de servicio".toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondryColor,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                widget.dataList.child("time").value == null
                                    ? "No disponible"
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
                            "Fecha de servicio".toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: secondryColor,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            widget.dataList.child("date").value == null ? "No disponible" : widget.dataList.child("date").value.toString(),
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
                  getUserUser(),
                  SizedBox(
                    height: 15,
                  ),
                  initWidget(),
                ],
              ));
  }

  //  Initialization

  //

  Widget imageEvidencia() {
    return Container(
        margin: EdgeInsets.only(left: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(color: Colors.grey.withOpacity(0.4), width: 110, height: 110, child: /*Image.network("src")*/ SizedBox())));
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

    try {
      total = int.parse(widget.dataList.child("price").value.toString());

      total += (int.parse(widget.dataList.child("price").value.toString()) / 20).round();

      total += (int.parse(widget.dataList.child("price").value.toString()) / 10).round();
    } catch (e) {}

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

        Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              "Resumen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: secondryColor,
              ),
            )),

        SizedBox(
          height: 10,
        ),

        itemMoney("Costo del servicio", widget.dataList.child("price").value.toString()),

        itemMoney("Tarifa del servicio", (int.parse(widget.dataList.child("price").value.toString()) / 20).round().toString()),

        itemMoney("Costo del domicilio", (int.parse(widget.dataList.child("price").value.toString()) / 10).round().toString()),

        SizedBox(
          height: 20,
        ),

        widget.dataList.child("professional").value.toString() == FirebaseAuth.instance.currentUser!.uid.toString()
            ? SizedBox()
            : Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Evidencias".toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: secondryColor,
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 120,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              imageEvidencia(),
                              imageEvidencia(),
                              imageEvidencia(),
                              imageEvidencia(),
                            ],
                          ))),
                ],
              ),

        SizedBox(
          height: 10,
        ),

        widget.dataList.child("state").value.toString() != "3" /*|| widget.dataList.child("state").value.toString() != "4"*/

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
                      initialRating: widget.dataList.child("rating").value == null
                          ? 0
                          : double.parse(widget.dataList.child("rating").value.toString()),
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

                        widget.dataList.ref.update({'rating': rating});
                      },
                    ),
                    AppWidget().texfieldFormat(title: "Comentario"),
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
                  getTotalPay().toString(),
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
                    child: AppWidget().buttonFormColor(context, stateOrder[int.parse(widget.dataList.child("state").value.toString())],
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
                                  AppWidget().buttonFormColor(context, stateOrder[0], stateOrderColor[0], tap: () {
                                    changeState(0);
                                  }),
                                  AppWidget().buttonFormColor(context, stateOrder[1], stateOrderColor[1], tap: () {
                                    changeState(1);
                                  }),
                                  AppWidget().buttonFormColor(context, stateOrder[2], stateOrderColor[2], tap: () {
                                    changeState(2);
                                  }),
                                  AppWidget().buttonFormColor(context, stateOrder[3], stateOrderColor[3], tap: () {
                                    changeState(3);
                                  }),
                                  AppWidget().buttonFormColor(context, stateOrder[4], stateOrderColor[4], tap: () {
                                    changeState(4);
                                  }),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      if (widget.dataList.child("state").value.toString() != "3" &&
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
                        : AppWidget().buttonFormLine(context, "Cancelar", true, urlIcon: "images/icons/closeCircle.svg", tap: () {
                            Navigator.pop(context);
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
              "Dirección de entrega",
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
                    /*dataListObjectGeneral == null ? "" : dataListObjectGeneral!.child("address").value.toString()*/ widget.dataList
                                .child("address")
                                .value ==
                            null
                        ? "No disponible"
                        : widget.dataList.child("address").value.toString(),
                    style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 5),

                /*  GestureDetector(

                    onTap: () {

                      Loader.page(context, const Addresses());

                    },

                    child: Text(

                      'Cambiar',

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
                        "Resumen",
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

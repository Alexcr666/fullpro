import 'dart:async';
import 'dart:math';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullpro/PROFESIONAL/views/stripe.dart';
import 'package:fullpro/TESTING/testing.dart';
import 'package:fullpro/main.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/profesional/profileProfesional.dart';
import 'package:fullpro/pages/profile/address/addressUser.dart';
import 'package:fullpro/utils/utils.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/animation/fadeBottom.dart';
import 'package:fullpro/animation/fadeRight.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/cartController.dart';
import 'package:fullpro/controller/fireController.dart';
import 'package:fullpro/controller/mainController.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/controller/pushnotificationservice.dart';
import 'package:fullpro/controller/trendingController.dart';
import 'package:fullpro/models/homeTrendingServices.dart';
import 'package:fullpro/models/nearbyPartner.dart';
import 'package:fullpro/pages/cartPage.dart';
import 'package:fullpro/pages/searchPage.dart';
import 'package:fullpro/pages/subServicePage.dart';
import 'package:fullpro/pages/trending.dart';
import 'package:fullpro/utils/permissions.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/ProfileButtonWithBottomSheet.dart';
import 'package:fullpro/widgets/bottomNav.dart';
import 'package:page_indicator/page_indicator.dart';

DataSnapshot? userDataProfile;

class kHomePage extends StatefulWidget {
  kHomePage({Key? key}) : super(key: key);
  static const String id = 'kHomePage';

  @override
  _kHomePageState createState() => _kHomePageState();
}

TextEditingController _searchHome = TextEditingController();
GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

class _kHomePageState extends State<kHomePage> {
  late FirebaseMessaging messaging;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Initialization  setting for android
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(android: AndroidInitializationSettings("@drawable/notification_icon"));
    notificationsPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {}
      },
    );
  }

  TextEditingController _searchHomeCategorie = TextEditingController();
  int activeCategorie = 0;

  TextEditingController _searchInspections = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? timer;
  Timer? timerExtra;
  PageController? slideController;
  //List<Marker> _marker = [];
  Set<Marker> _marker = <Marker>{};
  var mapLists;

  void _initMarkers() {
    _marker.clear();

    FirebaseDatabase.instance.ref().child("partners").orderByChild("profesion").equalTo(_searchHome.text).once().then((value) {
      DatabaseEvent response = value;

      for (var i = 0; i < response.snapshot.children.length; i++) {
        DataSnapshot dataList = response.snapshot.children.toList()[i];

        //  if (dataList.child("professional").value.toString() == _searchHome.text.toString()) {
        if (dataList.child("latitud").value != null && dataList.child("longitude").value != null) {
          MarkerId markerId = new MarkerId(dataList.key.toString());
          _marker.add(
            new Marker(
              markerId: markerId,
              infoWindow: InfoWindow(title: dataList.child("fullname").value.toString()),
              position: LatLng(
                  double.parse(dataList.child("latitud").value.toString()), double.parse(dataList.child("longitude").value.toString())),
              onTap: () {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileProfesionalPage(
                              id: markerId.toString(),
                            )));*/
                // Handle on marker tap
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),
          );
        }
        //}
      }
      setState(() {});
    });

/*    UserRef.once().then((e) async {
      final dataSnapshot = e.snapshot;

     
    });*/
  }

  String currentText = "";

  _FirstPageState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: InputDecoration(errorText: "Beans"),
      controller: TextEditingController(text: "Starting Text"),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          // added.add(text);
        }
      }),
    );
  }

  List<String> suggestions = [];

  SimpleAutoCompleteTextField? textField;

  bool showWhichErrorText = false;

  void servicesSearch(int type) {
    suggestions.clear();
    if (type == 1) {
      final UserRef = FirebaseDatabase.instance.ref().child("categories").once().then((value) {
        DatabaseEvent response = value;

        for (var i = 0; i < response.snapshot.children.length; i++) {
          DataSnapshot dataList = response.snapshot.children.toList()[i];

          if (dataList.child("name").value != null) {
            suggestions.add(dataList.child("name").value.toString());
          }
        }
        setState(() {});
      });
    } else {
      final UserRef = FirebaseDatabase.instance.ref().child("inspections").once().then((value) {
        DatabaseEvent response = value;

        for (var i = 0; i < response.snapshot.children.length; i++) {
          DataSnapshot dataList = response.snapshot.children.toList()[i];

          if (dataList.child("name").value != null) {
            suggestions.add(dataList.child("name").value.toString());
          }
        }
        setState(() {});
      });
    }

/*    UserRef.once().then((e) async {
      final dataSnapshot = e.snapshot;

     
    });*/
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  TextEditingController country = TextEditingController();

  ///   Nearby Partners Variables
  late StreamSubscription<DatabaseEvent> rideSubscription;
  List<NearbyPartner> availablePartners = [];
  bool nearbyPartnersKeysLoaded = false;
  bool isRequestingLocationDetails = false;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  String? dayTime = '';

  // Setup Current Positions Locator
  void setupPositionLocator() async {
    debugPrint(currentFirebaseUser!.uid);
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    startGeofireListener();

    userLocation = await MainController.findCordinateAddress(position, context);
    UserPreferences.setUserLocation(userLocation!);
    UserPreferences.getAddressStatus() != 'manual'
        ? UserPreferences.setAddressStatus('current')
        : UserPreferences.getAddressStatus() != 'manual';
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    DatabaseReference curAddressRef =
        FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('currentAddress').child('placename');
    curAddressRef.set(userLocation);

    DatabaseReference curAddCoordinatesRef =
        FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('currentAddress').child('location');
    Map CoordinateRef = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
    curAddCoordinatesRef.set(CoordinateRef);

    DatabaseReference manualAddressRef = FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('manualAddress');
    manualAddressRef.once().then((e) async {
      final DataSnapshot = e.snapshot;

      if (DataSnapshot.exists) {
        if (DataSnapshot != null) {
          userManualLocation = DataSnapshot.child('placename').value.toString();
          UserPreferences.setManualLocation(userManualLocation!);
        } else {
          UserPreferences.setManualLocation(Locales.string(context, 'lbl_set_manual_address'));
          manualAddressRef.set({'placename': Locales.string(context, 'lbl_set_manual_address')});
        }
      } else {
        UserPreferences.setManualLocation(Locales.string(context, 'lbl_set_manual_address'));
        manualAddressRef.set({'placename': Locales.string(context, 'lbl_set_manual_address')});
      }
    });
  }

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
            getpartnerData();
            if (nearbyPartnersKeysLoaded) {}
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

            getpartnerData();
            FireController.updateNearbyLocation(_nearbyPartner);
            break;

          case Geofire.onGeoQueryReady:
            nearbyPartnersKeysLoaded = true;
            getpartnerData();
            debugPrint('ready geofire');
            break;
        }
      }
    });
  }

  void getpartnerData() {
    for (NearbyPartner driver in FireController.nearbyPartnerList) {
      print('driver key is : ${driver.key}');
    }
  }

  // Refresh List
  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      locationPermision();

      // Check Cart Realtime
      CartController.checkCart();

      //  Get User Info
      MainController.getUserInfo(context);

      //  Get Trending Services Slider
      if (hometrendingDataLoaded == false) {
        TrendingController.getHomeTrendingServices(context);
      }

      //  Get Services List For Search
      setupPositionLocator();

      // MainController.checkNetwork(context);
    });
  }

  // Initialization
  @override
  void initState() {
    super.initState();
    _searchHome.clear();

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print("token: " + value.toString());
      deviceToken = value!;
    });

    initialize();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // print("message recieved" + event.data.toString());

      // if (event.notification != null) {
      display(event);
      //  }
    });

    DatabaseReference ref = FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid.toString());

// Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;

    stream.listen((DatabaseEvent event) {
      // getData();
      event.snapshot;
      userDataProfile = event.snapshot;
      _controller.future.then((value) {
        if (userDataProfile != null) {
          value.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 0,
              target: LatLng(double.parse(userDataProfile!.child("latitud").value.toString()),
                  double.parse(userDataProfile!.child("longitude").value.toString())),
              zoom: 14.0,
            ),
          ));
        }
      });
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
    //
    //
    locationPermision();

    /* Future.delayed(const Duration(milliseconds: 2000), () {
      AppSharedPreference().getUser(context).then((value) {
        UserPreferences.setUsername(value);
        print("userhome: " + value.toString());
        setState(() {});
      });
    });*/

    /* slideController = PageController();

    //  Get Trending Services Slider
    if (hometrendingDataLoaded == false) {
      TrendingController.getHomeTrendingServices(context);
    }

    // Check Cart Realtime
    CartController.checkCart();

    //  Get Services List For Search
    setupPositionLocator();
    // Repeating Function
    timerExtra = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) => setState(() {
        //  Get User Info
        locationPermision();
        // MainController.checkNetwork(context);
      }),
    );*/

    // Repeating Function
    timer = Timer.periodic(
      repeatTime,
      (Timer t) => setState(() {
        CartController.checkCart();
        //  Get User Info
        MainController.getUserInfo(context);
        MainController.getSettings();
      }),
    );

    // servicesSearch(1);
  }

  // Dispose
  @override
  void dispose() {
    timer?.cancel();
    timerExtra?.cancel();
    super.dispose();
    slideController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check Current Day Time
    TimeOfDay day = TimeOfDay.now();
    switch (day.period) {
      case DayPeriod.am:
        dayTime = Locales.string(context, 'lbl_morning');
        break;
      case DayPeriod.pm:
        dayTime = Locales.string(context, 'lbl_evening');
    }
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //  crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$dayTime',
                style: TextStyle(color: secondryColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                "Hola " + '${UserPreferences.getUsername() ?? currentUserInfo?.fullName}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddressesUser("users")));
                  },
                  child: Text(
                    userDataProfile == null
                        ? "Selecciona ubicación"
                        : userDataProfile!.child("location").value == null
                            ? "Seleccionar ubicación"
                            : userDataProfile!.child("location").value.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  )),
            ],
          ),
          actions: [
            Image.asset(
              "images/logo.png",
              width: 70,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MaterialButton(
                  elevation: 0.0,
                  hoverElevation: 0.0,
                  focusElevation: 0.0,
                  highlightElevation: 0.0,
                  minWidth: 50,
                  height: 60,
                  color: Colors.transparent,
                  onPressed: () {
                    if (userDataProfile!.child("cart").value != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartPage(
                                    id: userDataProfile!.child("cart").value.toString(),
                                  )));
                    }
                    // Loader.page(context, const CartPage());
                  },
                  shape: const CircleBorder(),
                  child: Opacity(
                      opacity: userDataProfile == null
                          ? 1
                          : userDataProfile!.child("cart").value != null
                              ? 1
                              : 0.4,
                      child: SvgPicture.asset(
                        "images/icons/cart.svg",
                        width: 35,
                      ))),
            ),
          ],
          backgroundColor: Static.dashboardBG,
          elevation: 0.0,
          toolbarHeight: 70,
          leadingWidth: 80,
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ProfileButtonWithBottomSheet(
                        getUserName: currentUserInfo?.fullName,
                        getuserPhone: currentUserInfo?.phone,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNav(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: leftPadding,
              right: rightPadding,
              bottom: bottomPadding,
              top: topPadding,
            ),
            child: SingleChildScrollView(
              child: initWidget(),
            ),
          ),
        ),
      ),
    );
  }

  // Initialization Widget

  Widget pageProfessional() {
    return FutureBuilder(
        // initialData: 1,
        future: FirebaseDatabase.instance.ref().child('partners').orderByChild("profesion").equalTo(_searchHome.text).once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          bool resultPrimary = false;
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            return response == null
                ? AppWidget().loading()
                : response.snapshot.children.length == 0
                    ? AppWidget().noResult()
                    : ListView.builder(
                        itemCount: response.snapshot.children.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          DataSnapshot dataList = response.snapshot.children.toList()[index];

                          if (dataList.child("primary").value == true) {
                            resultPrimary = true;
                          }
                          //  Widget itemList() {

                          getDistance() async {
                            var _distanceInMeters;

                            if (userDataProfile != null) {
                              _distanceInMeters = await Geolocator.distanceBetween(
                                double.parse(dataList.child("latitude").value.toString()),
                                double.parse(dataList.child("longitude").value.toString()),
                                userDataProfile!.child("latitud").value == null
                                    ? double.parse(dataList.child("latitude").value.toString())
                                    : double.parse(userDataProfile!.child("latitud").value.toString()),
                                userDataProfile!.child("latitud").value == null
                                    ? double.parse(dataList.child("longitude").value.toString())
                                    : double.parse(userDataProfile!.child("longitude").value.toString()),
                              );
                            }
                            return _distanceInMeters ?? "0";
                          }

                          Widget itemProfile() {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileProfesionalPage(
                                                id: dataList.key.toString(),
                                              )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: AppWidget().boxShandowGreyRectangule(),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      AppWidget().circleProfile(dataList.child("photo").value.toString()),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                          child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Text(
                                            dataList.child("fullname").value.toString(),
                                            style: TextStyle(color: secondryColor, fontSize: 17, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Opiniones clientes",
                                            style: TextStyle(color: Colors.black, fontSize: 10),
                                          ),
                                          Row(
                                            children: [
                                              RatingBarIndicator(
                                                  rating: 2.5,
                                                  itemCount: 5,
                                                  itemSize: 16.0,
                                                  itemBuilder: (context, _) => Icon(
                                                        Icons.star,
                                                        color: secondryColor,
                                                      )),
                                              Expanded(child: SizedBox()),
                                              FutureBuilder(
                                                  // initialData: 1,
                                                  future: getDistance(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(snapshot.data.toString() == "0"
                                                          ? "no"
                                                          : (double.parse(snapshot.data.toString()).round() / 1000).round().toString() +
                                                              " Km");
                                                    } else {
                                                      return SizedBox();
                                                    }
                                                  }),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                ));

                            //  }

                            /* */
                          }

                          getNoResult() {
                            if (((index + 1) == response.snapshot.children.length)) {
                              if (resultPrimary) {
                                return AppWidget().noResult();
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return SizedBox();
                            }
                          }

                          return dataList.child("primary").value != true ? getNoResult() : itemProfile();
                          /* dataList.child("primary").value != true ? SizedBox() :*/

                          /* dataList.child("latitude").value == null
                                    ? SizedBox()
                                    : FutureBuilder(
                                        // initialData: 1,
                                        future: getDistance(),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            try {
                                              int porcent = (double.parse(snapshot.data.toString()).round() / 1000).round();
                                              if (porcent <= int.parse(userDataProfile!.child("radio").value.toString())) {
                                                return itemProfile();
                                              } else {
                                                // return itemProfile();
                                                return Text(porcent.toString());
                                              }
                                            } catch (e) {
                                              return itemProfile();
                                            }
                                          } else {
                                            return AppWidget().loading();
                                          }
                                        });*/
                        });
          } else {
            return AppWidget().loading();
          }

          ;
        });
  }

  Widget initWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fadeRight(.1, buildSlider()),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
            ),
            Container(
                width: 150,
                child: AppWidget().buttonShandowActive("Servicios", activeCategorie == 1 ? true : false, tap: () {
                  activeCategorie = 1;

                  servicesSearch(1);

                  /* setState(() {});
                  AppSharedPreference().getUser(context).then((value) {
                    print("login: " + value.toString());
                  }).catchError((onError) {
                    print("error: " + onError.toString());
                  });*/
                })),
            // Flexible(child: AppWidget().buttonForm(context, "Servicios")),
            SizedBox(
              width: 10,
            ),

            Container(
                width: 150,
                child: AppWidget().buttonShandowActive("Inspecciones", activeCategorie == 2 ? true : false, tap: () {
                  activeCategorie = 2;
                  servicesSearch(2);
                  setState(() {});
                })),
            SizedBox(
              width: 20,
            ),
            //   Flexible(child: AppWidget().buttonForm(context, "Inspecciones")),
          ],
        ),
        SizedBox(
          height: 20,
        ),

        /* SimpleAutoCompleteTextField(
          key: key,
          decoration: InputDecoration(errorText: "Beans"),
          controller: TextEditingController(text: "Starting Text"),
          suggestions: suggestions,
          textChanged: (text) => currentText = text,
          clearOnSubmit: true,
          textSubmitted: (text) => setState(() {
            if (text != "") {
              // added.add(text);
            }
          }),
        ),*/

        activeCategorie == 0
            ? SizedBox()
            : SimpleAutoCompleteTextField(
                key: key,
                decoration: InputDecoration(
                  errorText: "Ingresar servicio valido",
                  contentPadding: EdgeInsets.only(top: 17, bottom: 17, left: 15),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: secondryColor, width: 1.0), borderRadius: BorderRadius.circular(11)),
                  errorBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),
                  border:
                      OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1.0), borderRadius: BorderRadius.circular(10)),
                  labelText: "Buscar",
                  labelStyle: TextStyle(fontSize: 12.0, color: Colors.black),
                ),
                controller: _searchHome,
                suggestions: suggestions,
                textChanged: (text) {
                  print("text: " + text.toString());

                  currentText = text;
                },
                // clearOnSubmit: true,
                textSubmitted: (text) {
                  print("set1: " + _searchHome.text.toString());

                  //   currentText = text;
                  //  cartItemsList = Provider.of<AppData>(context, listen: false).userCartData;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _searchHome.text = text.toString();
                    _initMarkers();
                    print("set2: " + _searchHome.text.toString());
                  });

                  //   setState(() {});
                }

                // added.add(text);

                ),
        /* Container(
            width: 100,
            height: 30,
            child: AppWidget().buttonForm(context, "hola", tap: () {
              _searchHome.text = "hola";
            })),*/
        Text("Resultados de " + _searchHome.text.toString()),
        // buildSearch(),
        SizedBox(
          height: 20,
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
                width: double.infinity,
                height: 200,
                child: GoogleMap(
                  markers: _marker,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _initMarkers();
                  },
                ))),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
            onTap: () {
              //  _initMarkers();
              //    kkk

              Navigator.push(context, MaterialPageRoute(builder: (context) => StripeTest()));
              // servicesSearch(1);
              //StripeTest
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Perfiles de",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondryColor),
                ),
                Text(
                  "profesionales destacados",
                  style: TextStyle(fontSize: 18, color: secondryColor),
                ),
              ],
            )),

        pageProfessional(),
        // fadeBottom(.3, buildServicesList()),
        trendingSlider(),
        const SizedBox(height: 20)
      ],
    );
  }

  // Slider Widget

  Widget buildSlider() {
    return FutureBuilder(
        initialData: 1,
        future: FirebaseDatabase.instance.ref().child('important').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;
              // response.snapshot.children!.length
              //  DataSnapshot dataList = response.snapshot.children.toList()[index];

              // List<String> urls = [];
              List<Widget> pageView = [];

              for (var i = 0; i < response.snapshot.children.toList().length; i++) {
                DataSnapshot dataList = response.snapshot.children.toList()[i];
                pageView.add(Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(dataList.child("foto").value.toString()),
                      fit: BoxFit.cover,
                    ),
                    color: Static.dashboardCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ));
              }

              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 130,
                  child: PageIndicatorContainer(
                      child: PageView(
                        children: pageView,
                        controller: slideController,
                      ),
                      align: IndicatorAlign.bottom,
                      length: response.snapshot.children.toList().length,
                      indicatorSpace: 20.0,
                      padding: const EdgeInsets.all(10),
                      indicatorColor: Colors.black,
                      indicatorSelectorColor: Colors.white,
                      shape: IndicatorShape.circle(size: 5)),
                ),
              );
            } else {
              return AppWidget().loading();
            }

            ;
          } catch (e) {
            return AppWidget().loading();
          }
        });

    // return
  }

  // Search Widget
  Widget buildSearch() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MaterialButton(
              elevation: 0.0,
              highlightElevation: 0.0,
              color: Static.dashboardCard,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => kSearchPage()));
              },
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      FeatherIcons.search,
                      size: 23,
                      color: Static.colorTextLight,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 10),
                      child: Text(
                        Locales.string(context, 'lbl_search'),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Static.colorTextLight,
                          fontFamily: 'Brand-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DatabaseEvent> getFilterCategorie() async {
    Future<DatabaseEvent> data = FirebaseDatabase.instance.ref().child('categories').once();

    if (_searchHomeCategorie.text.trim().length != 0) {
      data = FirebaseDatabase.instance
          .ref()
          .child("categories")
          .orderByChild("name")
          .startAt(_searchHomeCategorie.text.toString().capitalize())
          .endAt(_searchHomeCategorie.text.toString().capitalize() + "\uf8ff")
          // .limitToFirst(int.parse("10"))
          .once();
    }

    return data;
  }

  Widget gridviewCategories() {
    return FutureBuilder(
        future: getFilterCategorie(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData && snapshot.data != null) {
              DatabaseEvent response;

              response = snapshot.data;

              return response == null
                  ? AppWidget().loading()
                  : response.snapshot.children.length == 0
                      ? AppWidget().noResult()
                      : Container(
                          width: double.infinity,
                          height: 300,
                          child: AlignedGridView.count(
                            //  physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            itemCount: response.snapshot.children.length,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            itemBuilder: (context, index) {
                              DataSnapshot dataList = response.snapshot.children.toList()[index];

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => subServicePage(
                                                  title: dataList.child("name").value.toString(),
                                                  urlImage: dataList.child("photo").value.toString(),
                                                  idPage: dataList.key.toString(),
                                                )));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Image.network(
                                                  dataList.child("photo").value.toString(),
                                                  errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                    return Container(
                                                      width: 110,
                                                      height: 110,
                                                      color: Colors.grey.withOpacity(0.3),
                                                    );
                                                  },
                                                  width: 110,
                                                  height: 110,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            dataList.child("name").value.toString(),
                                            style: TextStyle(color: secondryColor, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )));
                            },
                          ));
            } else {
              return AppWidget().loading();
            }

            ;
          } catch (e) {
            return AppWidget().loading();
          }
        });
  }

// Trending Services
  Widget trendingSlider() {
    return Container(
      child: Column(
        children: [
          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Locales.string(context, 'lbl_recommended'),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto-Bold',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const kTrending()));
                  },
                  child: Text(
                    Locales.string(context, 'lbl_seeall'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Static.themeColor[500],
                      fontFamily: 'Roboto-Bold',
                    ),
                  ),
                ),
              ],
            ),
          ),*/
          SizedBox(
            height: 20,
          ),
          /*  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Categorias",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondryColor),
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const kTrending()));
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold),
                  )),

                  Svg
            ],
          ),*/
          AppWidget().title("Categorias", tap: () {}),
          SizedBox(
            height: 20,
          ),
          AppWidget().texfieldFormat(title: "Buscar", controller: _searchHomeCategorie),
          SizedBox(
            height: 20,
          ),
          gridviewCategories(),
          /* StaggeredGrid.count(
            crossAxisCount: 3,
            children: [
              //  Row One
              serviceListTile(
                subServicePage(serviceId: 'ac_services', serviceName: Locales.string(context, 'srvs_ac_services')),
                'images/svg_icons/service_icons/air_conditioner.svg',
                Locales.string(context, 'srvs_ac_services'),
                const Color.fromARGB(255, 215, 35, 246),
                Colors.purple.shade50,
              ),
              serviceListTile(
                subServicePage(serviceId: 'carpenter', serviceName: Locales.string(context, 'srvs_carpenter')),
                'images/svg_icons/service_icons/carpenter.svg',
                Locales.string(context, 'srvs_carpenter'),
                Colors.orange.shade800,
                Colors.orange.shade50,
              ),
              serviceListTile(
                subServicePage(serviceId: 'cleaning', serviceName: Locales.string(context, 'srvs_cleaning')),
                'images/svg_icons/service_icons/cleaning.svg',
                Locales.string(context, 'srvs_cleaning'),
                Colors.lightBlue,
                Colors.lightBlue.shade50,
              ),
              serviceListTile(
                subServicePage(serviceId: 'electrician', serviceName: Locales.string(context, 'srvs_electrician')),
                'images/svg_icons/service_icons/electrician.svg',
                Locales.string(context, 'srvs_electrician'),
                Colors.yellow.shade800,
                Colors.yellow.shade50,
              ),
              //
              //  Row Two
              //
              serviceListTile(
                subServicePage(serviceId: 'geyser', serviceName: Locales.string(context, 'srvs_geyser')),
                'images/svg_icons/service_icons/geyser.svg',
                Locales.string(context, 'srvs_geyser'),
                Colors.red,
                Colors.red.shade50,
              ),
              serviceListTile(
                subServicePage(serviceId: 'appliance', serviceName: Locales.string(context, 'srvs_appliance')),
                'images/svg_icons/service_icons/appliance.svg',
                Locales.string(context, 'srvs_appliance'),
                Colors.lightBlue,
                Colors.lightBlue.shade50,
              ),
              serviceListTile(
                subServicePage(serviceId: 'painter', serviceName: Locales.string(context, 'srvs_painter')),
                'images/svg_icons/service_icons/painter.svg',
                Locales.string(context, 'srvs_painter'),
                Colors.purple.shade800,
                Colors.purple.shade50,
              ),
              serviceListTile(
                subServicePage(serviceId: 'plumber', serviceName: Locales.string(context, 'srvs_plumber')),
                'images/svg_icons/service_icons/plumber.svg',
                Locales.string(context, 'srvs_plumber'),
                Colors.green,
                Colors.green.shade50,
              ),
              serviceListTile(
                subServicePage(serviceId: 'handyman', serviceName: Locales.string(context, 'srvs_handyman')),
                'images/svg_icons/service_icons/handyman.svg',
                Locales.string(context, 'srvs_handyman'),
                Colors.green,
                Colors.green.shade50,
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  servicesComponent({required HomeTrendingServices kServices}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        child: MaterialButton(
          elevation: 0.0,
          hoverElevation: 0.0,
          focusElevation: 0.0,
          highlightElevation: 0.0,
          minWidth: 70,
          height: 75,
          color: secondryColor,
          onPressed: () {
            //
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  kServices.image!,
                  width: 100,
                  height: 100,
                  errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.withOpacity(0.3),
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text(
                      kServices.name!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Text(
                    kServices.chargemod!,
                    style: const TextStyle(
                      color: Static.colorLightGrayFair,
                      fontSize: 13,
                    ),
                  ),
                  /*   Row(
                    children: [
                      kServices.discount! != '0'
                          ? Text(
                              currencyPos == 'left'
                                  ? '$currencySymbol${int.parse(kServices.price!)}'
                                  : '${int.parse(kServices.price!)}$currencySymbol',
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
                              ),
                            )
                          : const SizedBox(),
                      kServices.discount! != '0' ? const SizedBox(width: 15) : const SizedBox(),
                      Text(
                        currencyPos == 'left'
                            ? '$currencySymbol${int.parse(kServices.price!) - int.parse(kServices.discount!)}'
                            : '${int.parse(kServices.price!) - int.parse(kServices.discount!)}$currencySymbol',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),*/
                  /*   Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 3,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.green,
                        ),
                        Text(
                          kServices.rating!,
                        ),
                      ],
                    ),
                  ),*/
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Book now",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Services Grid
  Widget buildServicesList() {
    return Container(
      child: Column(
        children: [
          /* Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Locales.string(context, 'lbl_services'),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto-Bold',
                  ),
                ),
              ],
            ),
          ),*/

          ListView.builder(
            padding: EdgeInsets.only(left: 10.0),
            itemCount: 2,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        radius: 30,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Text(
                                        "Alex",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: secondryColor),
                                      ),
                                      Text(
                                        "titulo",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11, color: secondryColor),
                                      ),
                                    ],
                                  )),
                                  // Expanded(child: SizedBox()),
                                  Flexible(
                                      child: Icon(
                                    Icons.heart_broken,
                                    color: secondryColor,
                                    size: 20,
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Calle 45 # 35",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11, color: secondryColor),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_border_rounded,
                                    color: secondryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.star_border_rounded,
                                    color: secondryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.star_border_rounded,
                                    color: secondryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.star_border_rounded,
                                    color: secondryColor,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.star_border_rounded,
                                    color: secondryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              )
                            ],
                          ))
                    ],
                  ));
            },
          )
        ],
      ),
    );
  }

  Widget serviceListTile(
    Widget onPressed,
    String iconfile,
    String name,
    Color iconColor,
    Color iconBG,
  ) {
    return GestureDetector(
      onTap: () {
        Loader.page(context, onPressed);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: MaterialButton(
                    elevation: 0.0,
                    hoverElevation: 0.0,
                    focusElevation: 0.0,
                    highlightElevation: 0.0,
                    minWidth: 100,
                    height: 90,
                    color: Static.dashboardCard,
                    onPressed: () {
                      Loader.page(context, onPressed);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      iconfile,
                      // color: Colors.red,
                      width: 45,
                    )),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

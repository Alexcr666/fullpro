import 'dart:async';
import 'package:flutter_locales/flutter_locales.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/firehelper.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/controllers/pushnotificationservice.dart';
import 'package:fullpro/PROFESIONAL/models/nearbyOrders.dart';
import 'package:fullpro/PROFESIONAL/models/partner.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/views/Orders/orders.dart';
import 'package:fullpro/PROFESIONAL/views/language.dart';
import 'package:fullpro/PROFESIONAL/views/support.dart';
import 'package:fullpro/PROFESIONAL/views/wallet/wallet.dart';
import 'package:fullpro/PROFESIONAL/widget/bottomNav.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/globalConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../styles/statics.dart' as appcolors;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../utils/permissions.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';

  final String? currentScreen;
  final int? currentTab;

  const HomePage({Key? key, this.currentScreen, this.currentTab}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  String? getUserName = '';
  String? getuserPhone = '';
  String? getUserEarning = '';
  int? bounusReach;
  bool bonusDataLoading = true;
  Timer? timer;

  DatabaseReference? tripRequestRef;

  String availabilityTitle = 'Go Online';
  Color availabilityColor = Colors.red;
  bool isAvailable = false;
  int? totalOrders;
  bool dataLoading = true;

  String? availability = '';
  String availabilityStatus = '';

  // Loaded
  bool ordersCountLoaded = false;

  // Nearby Orders
  List<NearbyOrders> availableOrders = [];
  bool nearbyOrdersKeysLoaded = false;
  bool isRequestingLocationDetails = false;

  // Location Permissions
  void getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      Geolocator.getCurrentPosition().catchError((e) {
        debugPrint(e);
      }).then((value) => () async {
            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).catchError((e) {
              debugPrint(e);
            });
            currentPosition = position;
          });
    } else {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).catchError((e) {
        debugPrint(e);
      });
      currentPosition = position;

      if (dueBalanceValue < dueLimit!) {
        goOnline();
      }
    }
  }

  // Setup Current Positions Locator
  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    debugPrint('done setup');
  }

  void getUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    final userRef = FirebaseDatabase.instance.ref().child("partners").child(userid!);
    userRef.once().then((e) async {
      final _datasnapshot = e.snapshot;

      if (_datasnapshot.value != null) {
        currentPartnerInfo = Partner.fromSnapshot(_datasnapshot);
        setState(() {
          if (currentPartnerInfo?.fullName.toString() == null) {
            if (UserPreferences.getUsername() != null) {
              getUserName = UserPreferences.getUsername();
            } else {
              getUserName = '';
            }
          } else {
            getUserName = currentPartnerInfo?.fullName.toString();
            UserPreferences.setUsername(getUserName!);
          }
          if (currentPartnerInfo?.phone.toString() == null) {
            if (UserPreferences.getUserPhone() != null) {
              getuserPhone = UserPreferences.getUserPhone();
            } else {
              getuserPhone = '';
            }
          } else {
            getuserPhone = currentPartnerInfo?.phone.toString();
            UserPreferences.setUserPhone(getuserPhone!);
          }
        });
      }
    });
  }

  Future<void> checkAvailability(context) async {
    // String? availability = Locales.string(context, 'lbl_offline');
    // String availabilityStatus = Locales.string(context, 'lbl_offline');

    if (dueBalanceValue < dueLimit!) {
      currentFirebaseUser = FirebaseAuth.instance.currentUser;
      String? userid = currentFirebaseUser?.uid;

      final userRef = FirebaseDatabase.instance.ref().child("partners").child(userid!);
      userRef.once().then((e) async {
        final _datasnapshot = e.snapshot;

        if (_datasnapshot.value != null) {
          currentPartnerInfo = Partner.fromSnapshot(_datasnapshot);
          setState(() {
            if (currentPartnerInfo?.newtrip.toString() == 'waiting' ||
                currentPartnerInfo?.newtrip.toString() == 'timeout' ||
                currentPartnerInfo?.newtrip.toString() == 'cancelled' ||
                currentPartnerInfo?.newtrip.toString() == 'ended') {
              availability = Locales.string(context, 'lbl_online');
            } else {
              availability = Locales.string(context, 'lbl_offline');
            }
          });
        }
      });
    } else {
      availability = Locales.string(context, 'lbl_offline');
    }
  }

  Future<void> checkTotalOrders() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    final totalOrdersRef = FirebaseDatabase.instance.ref().child('partners').child(currentFirebaseUser!.uid).child('history');
    totalOrdersRef.once().then((e) async {
      final _datasnapshot = e.snapshot;

      if (_datasnapshot.value != null) {
        dataLoading = false;
        ordersCountLoaded = true;
        totalOrders = _datasnapshot.children.length;
      }
    });
  }

  // User Online Function
  Future<void> goOnline() async {
    if (dueBalanceValue < dueLimit!) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Geofire.initialize('partnersAvailable');
        Geofire.setLocation(currentFirebaseUser!.uid, currentPosition.latitude, currentPosition.longitude);

        final tripRequestRef = FirebaseDatabase.instance.ref().child('partners').child(currentFirebaseUser!.uid).child('newtrip');

        final tokenRef = FirebaseDatabase.instance.ref().child('partners').child(currentFirebaseUser!.uid).child('token');

        tripRequestRef.set('waiting');

        final FirebaseMessaging fcm = FirebaseMessaging.instance;
        String? token = await fcm.getToken();

        tokenRef.set(token);

        tripRequestRef.onValue.listen((event) {});
      } else {
        Geolocator.getCurrentPosition().catchError((e) {
          debugPrint(e);
        });
      }
    } else {
      return;
    }
  }

  // User Offline Function
  void goOffline() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    DatabaseReference? tripRequestRef = FirebaseDatabase.instance.ref().child('partners').child(userid!).child('newtrip');

    Geofire.removeLocation(currentFirebaseUser!.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  //  Start Geofire Services
  void startGeofireListener() {
    Geofire.initialize('ordersAvailable');
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 20)?.listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyOrders nearbyOrders = NearbyOrders();
            nearbyOrders.key = map['key'];
            nearbyOrders.latitude = map['latitude'];
            nearbyOrders.longitude = map['longitude'];
            debugPrint('geofire Entered');

            FireHelper.nearbyOrdersList.add(nearbyOrders);
            if (nearbyOrdersKeysLoaded) {}
            break;

          case Geofire.onKeyExited:
            debugPrint('geofire Exit');

            FireHelper.removeNearbyOrdersFromList(map['key']);
            break;

          case Geofire.onKeyMoved:
            // Update your key's location

            NearbyOrders nearbyOrders = NearbyOrders();
            nearbyOrders.key = map['key'];
            nearbyOrders.latitude = map['latitude'];
            nearbyOrders.longitude = map['longitude'];
            debugPrint('geofire moved');

            FireHelper.updateNearbyOrdersLocation(nearbyOrders);
            break;

          case Geofire.onGeoQueryReady:
            nearbyOrdersKeysLoaded = true;
            debugPrint('ready geofire');
            break;
        }
      }
    });
  }

  //  Initialization
  @override
  void initState() {
    super.initState();

    setupPositionLocator();

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    locationPermision();
    getUserInfo();
    MainControllerProfesional.dueBalance();
    MainControllerProfesional.checkEarning();
    MainControllerProfesional.getSettings();
    getCurrentPosition();

    // Total Orders
    checkTotalOrders();

    // Repeating Function
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) => setState(() {
        //  Get User Info
        locationPermision();
      }),
    );

    // Repeating Function
    timer = Timer.periodic(
      repeatTime,
      (Timer t) => setState(() {
        //  Get User Info
        // MainController.checkEarning();
        // MainController.dueBalance();
        checkAvailability(context);
        checkTotalOrders();
        MainControllerProfesional.getSettings();
      }),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      locationPermision();
      getUserInfo();
      MainControllerProfesional.dueBalance();
      checkAvailability(context);
      MainControllerProfesional.checkEarning();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      color: appcolors.secondaryColorSharp,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: appcolors.dashboardCard,
        bottomNavigationBar: const BottomNav(),

        // Appbar
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  MaterialButton(
                    elevation: 0,
                    highlightElevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: availability == Locales.string(context, 'lbl_offline') ? Colors.red : appcolors.secondaryColorSharp,
                    onPressed: () {
                      availability == Locales.string(context, 'lbl_offline') ? goOnline() : goOffline();
                    },
                    child: Text(
                      "$availability",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: appcolors.dashboardBG,
          elevation: 0.0,
          toolbarHeight: 70,
          leadingWidth: 150,
          leading: Row(
            children: [
              MaterialButton(
                elevation: 0.0,
                hoverElevation: 0.0,
                focusElevation: 0.0,
                highlightElevation: 0.0,
                minWidth: 60,
                height: 60,
                color: Colors.transparent,
                onPressed: () {
                  //
                  Loader.page(context, const SupportPage());
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FeatherIcons.phoneCall,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
              ),
              MaterialButton(
                elevation: 0.0,
                hoverElevation: 0.0,
                focusElevation: 0.0,
                highlightElevation: 0.0,
                minWidth: 60,
                height: 60,
                color: Colors.transparent,
                onPressed: () {
                  //
                  Loader.page(context, const Language());
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FeatherIcons.globe,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Body
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //   TOP CONTAINER
              topContainer(context),

              const SizedBox(height: 40),

              //   Counts CONTAINER
              countsContainer(ordersCountLoaded, totalOrders, earningsCountLoaded, getUserEarning!, context),

              const SizedBox(height: 30),

              // Bounus CONTAINER
              overviewContainer(context, totalOrders, ordersCountLoaded, earningsCountLoaded, getUserEarning),
            ],
          ),
        ),
      ),
    );
  }
}

// Top Contaienr
Widget topContainer(context) {
  return Container(
    decoration: const BoxDecoration(
      color: appcolors.dashboardBG,
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          spreadRadius: .5,
          offset: Offset(.7, .6),
        )
      ],
    ),
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.only(left: 24, top: 0, right: 24, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Locales.string(context, 'lbl_home'),
            style: const TextStyle(color: appcolors.primaryColorblue, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Roboto-Bold'),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Locales.string(context, 'lbl_current_vendor_status'),
                style:
                    const TextStyle(color: appcolors.colorTextLight, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Roboto-Bold'),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                'images/up_arrow.svg',
                width: 20,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Orders && Eanings Counts Container
Widget countsContainer(bool ordersCountLoaded, int? totalOrders, bool earningsCountLoaded, String getUserEarning, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 24,
    ),
    child: Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: ordersCountLoaded == true
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage("images/box_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
            child: MaterialButton(
              elevation: 0.0,
              hoverElevation: 0.0,
              focusElevation: 0.0,
              highlightElevation: 0.0,
              color: Colors.transparent,
              minWidth: 15,
              height: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () {
                Loader.page(context, const MyOrders());
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ordersCountLoaded == true
                        ? Text(
                            '$totalOrders ${Locales.string(context, 'lbl_orders')}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 5),
                    ordersCountLoaded == true
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Locales.string(context, 'lbl_view_all'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            decoration: earningsCountLoaded == true
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage("images/box_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
            child: MaterialButton(
              elevation: 0.0,
              hoverElevation: 0.0,
              focusElevation: 0.0,
              highlightElevation: 0.0,
              color: Colors.transparent,
              minWidth: 15,
              height: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () {
                Loader.page(context, const Wallet());
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .25,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    earningsCountLoaded == true
                        ? Text(
                            currencyPos == 'left'
                                ? '$currencySymbol${UserPreferences.getUserEarning() ?? getUserEarning}'
                                : '${UserPreferences.getUserEarning() ?? getUserEarning}$currencySymbol',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 5),
                    earningsCountLoaded == true
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Locales.string(context, 'lbl_wallet'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Overview Container
Widget overviewContainer(context, int? totalOrders, bool ordersCountLoaded, bool earningsCountLoaded, String? getUserEarning) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 24,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: appcolors.dashboardBG,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                dueBalanceValue > dueLimit!
                    ? const SizedBox()
                    : Text(
                        Locales.string(context, 'lbl_overview'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto-Bold',
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 15),
            /*changed ordersCountLoaded == true && earningsCountLoaded == true
                ? dueBalanceValue > dueLimit!
                    ? const AccountHold()
                    :*/
            OverviewList(totalOrders: totalOrders, eanrings: getUserEarning), //  : bounusShimmer(),
            const SizedBox(height: 15),

            //
          ],
        ),
      ),
    ),
  );
}

// Overview Panel
class OverviewList extends StatefulWidget {
  const OverviewList({
    Key? key,
    required this.totalOrders,
    required this.eanrings,
  }) : super(key: key);
  final int? totalOrders;
  final String? eanrings;
  @override
  State<OverviewList> createState() => _OverviewListState();
}

class _OverviewListState extends State<OverviewList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Locales.string(context, 'lbl_total_orders'),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto-Regular',
                color: Colors.black,
              ),
            ),
            Text(
              '${widget.totalOrders}',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto-Regular',
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Locales.string(context, 'lbl_earnings'),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto-Regular',
                color: Colors.black,
              ),
            ),
            Text(
              currencyPos == 'left'
                  ? '$currencySymbol${UserPreferences.getUserEarning() ?? widget.eanrings}'
                  : '${UserPreferences.getUserEarning() ?? widget.eanrings}$currencySymbol',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto-Regular',
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Locales.string(context, 'lbl_pay_to_admin'),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto-Regular',
                color: Colors.black,
              ),
            ),
            Text(
              currencyPos == 'left'
                  ? '$currencySymbol${UserPreferences.getUserEarning() ?? dueBalanceValue.toInt()}'
                  : '${UserPreferences.getUserEarning() ?? dueBalanceValue.toInt()}$currencySymbol',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto-Regular',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Bounus Panel Shimmer Effect
Widget bounusShimmer() {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 20,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 20,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 20,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 20,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// Bounus Panel
class BonusList extends StatefulWidget {
  const BonusList({
    Key? key,
    required this.bounusReach,
  }) : super(key: key);
  final int? bounusReach;
  @override
  State<BonusList> createState() => _BonusListState();
}

class _BonusListState extends State<BonusList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0  Orders',
              style: TextStyle(
                fontSize: 14,
                fontFamily: widget.bounusReach! != 0 && widget.bounusReach! >= 0 ? 'Roboto-Bold' : 'Roboto-Regular',
                color: widget.bounusReach! != 0 && widget.bounusReach! >= 0 ? appcolors.secondaryColorSharp : Colors.black,
              ),
            ),
            Text(
              'Rs. 0',
              style: TextStyle(
                fontSize: 14,
                fontFamily: widget.bounusReach! != 0 && widget.bounusReach! >= 0 ? 'Roboto-Bold' : 'Roboto-Regular',
                color: widget.bounusReach! != 0 && widget.bounusReach! >= 0 ? appcolors.secondaryColorSharp : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '100  Orders',
              style: TextStyle(
                fontSize: 14,
                fontFamily: widget.bounusReach! != 0 && widget.bounusReach! >= 100 ? 'Roboto-Bold' : 'Roboto-Regular',
                color: widget.bounusReach! != 0 && widget.bounusReach! >= 100 ? appcolors.secondaryColorSharp : Colors.black,
              ),
            ),
            Text(
              'Rs. 3000',
              style: TextStyle(
                fontSize: 14,
                fontFamily: widget.bounusReach! != 0 && widget.bounusReach! >= 100 ? 'Roboto-Bold' : 'Roboto-Regular',
                color: widget.bounusReach! != 0 && widget.bounusReach! >= 100 ? appcolors.secondaryColorSharp : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '250  Orders',
              style: TextStyle(
                fontSize: 14,
                fontFamily: widget.bounusReach! != 0 && widget.bounusReach! >= 250 ? 'Roboto-Bold' : 'Roboto-Regular',
                color: widget.bounusReach! != 0 && widget.bounusReach! >= 250 ? appcolors.secondaryColorSharp : Colors.black,
              ),
            ),
            Text(
              'Rs. 5000',
              style: TextStyle(
                fontSize: 14,
                fontFamily: widget.bounusReach! != 0 && widget.bounusReach! >= 250 ? 'Roboto-Bold' : 'Roboto-Regular',
                color: widget.bounusReach! != 0 && widget.bounusReach! >= 250 ? appcolors.secondaryColorSharp : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '500  Orders',
              style: TextStyle(
                fontSize: 14,
                fontFamily: widget.bounusReach! != 0 && widget.bounusReach! >= 500 ? 'Roboto-Bold' : 'Roboto-Regular',
                color: widget.bounusReach! != 0 && widget.bounusReach! >= 500 ? appcolors.secondaryColorSharp : Colors.black,
              ),
            ),
            Text(
              'Rs. 8000',
              style: TextStyle(
                fontSize: 14,
                fontFamily: widget.bounusReach! != 0 && widget.bounusReach! >= 500 ? 'Roboto-Bold' : 'Roboto-Regular',
                color: widget.bounusReach! != 0 && widget.bounusReach! >= 500 ? appcolors.secondaryColorSharp : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
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

class kHomePage extends StatefulWidget {
  const kHomePage({Key? key}) : super(key: key);
  static const String id = 'kHomePage';

  @override
  _kHomePageState createState() => _kHomePageState();
}

class _kHomePageState extends State<kHomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? timer;
  Timer? timerExtra;
  PageController? slideController;

  ///   Nearby Partners Variables
  late StreamSubscription<DatabaseEvent> rideSubscription;
  List<NearbyPartner> availablePartners = [];
  bool nearbyPartnersKeysLoaded = false;
  bool isRequestingLocationDetails = false;

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

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
    //
    //
    locationPermision();
    slideController = PageController();

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
    );

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    '$dayTime',
                    style: const TextStyle(
                      fontFamily: 'Brand-Regular',
                      color: Static.colorTextLight,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.sunny,
                    size: 20,
                    color: Colors.yellow.shade600,
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    '${UserPreferences.getUsername() ?? currentUserInfo?.fullName}',
                    style: const TextStyle(
                      fontFamily: 'Roboto-Bold',
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
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
                  Loader.page(context, const CartPage());
                },
                shape: const CircleBorder(),
                child: UserPreferences.getcartStatus() == 'full' || cartStatus == 'full'
                    ? Image.asset(cartIcon, width: 40)
                    : Image.asset(cartIcon, width: 40),
              ),
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

  Widget initWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSearch(),
        fadeRight(.1, buildSlider()),
        fadeBottom(.3, buildServicesList()),
        trendingSlider(),
        const SizedBox(height: 20)
      ],
    );
  }

  // Slider Widget

  Widget buildSlider() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 130,
        child: PageIndicatorContainer(
            child: PageView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(mainSlider[0]),
                      fit: BoxFit.cover,
                    ),
                    color: Static.dashboardCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(mainSlider[1]),
                      fit: BoxFit.cover,
                    ),
                    color: Static.dashboardCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
              controller: slideController,
            ),
            align: IndicatorAlign.bottom,
            length: 2,
            indicatorSpace: 20.0,
            padding: const EdgeInsets.all(10),
            indicatorColor: Colors.black,
            indicatorSelectorColor: Colors.white,
            shape: IndicatorShape.circle(size: 5)),
      ),
    );
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

// Trending Services
  Widget trendingSlider() {
    return Container(
      child: Column(
        children: [
          Padding(
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
          ),
          SizedBox(
            height: 130,
            child: Provider.of<AppData>(context).homeTrendingData.isNotEmpty
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return servicesComponent(
                        kServices: Provider.of<AppData>(context).homeTrendingData[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: Provider.of<AppData>(context).homeTrendingData.length,
                    physics: const ClampingScrollPhysics(),
                  )
                : const Center(child: DataLoadedProgress()),
          ),
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
          color: Static.themeColor[500],
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
                borderRadius: BorderRadius.circular(25),
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
                      style: const TextStyle(
                        fontFamily: 'Roboto-Bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    kServices.chargemod!,
                    style: const TextStyle(
                      color: Static.colorLightGrayFair,
                      fontSize: 13,
                    ),
                  ),
                  Row(
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
                  ),
                  Container(
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
          Padding(
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
          ),
          StaggeredGrid.count(
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
          ),
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

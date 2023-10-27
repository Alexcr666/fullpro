import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/mainController.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/utils/countryStateCity/AddressPicker.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'dart:async';

class Addresses extends StatefulWidget {
  const Addresses({Key? key}) : super(key: key);
  static const String id = 'Addresses';

  @override
  _AddressesState createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int _groupValue = 1;
  bool manualAdressExists = false;
  String? countryValue;
  String? stateValue;
  String? cityValue;

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    userLocation = await MainController.findCordinateAddress(position, context);
    UserPreferences.setUserLocation(userLocation!);
    print(userLocation);

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

    DatabaseReference manualAddressRef =
        FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('manualAddress').child('placename');
    manualAddressRef.once().then((e) async {
      final DataSnapshot = e.snapshot;

      if (DataSnapshot.exists) {
        userManualLocation = DataSnapshot.value.toString();
        DataSnapshot.value.toString() == Locales.string(context, 'lbl_set_manual_address')
            ? manualAdressExists = false
            : manualAdressExists = true;
        DataSnapshot.value.toString() != null
            ? UserPreferences.setManualLocation(userManualLocation!)
            : UserPreferences.setManualLocation(Locales.string(context, 'lbl_set_manual_address'));
      } else {
        UserPreferences.setManualLocation(Locales.string(context, 'lbl_set_manual_address'));
        manualAddressRef.set(Locales.string(context, 'lbl_set_manual_address'));
      }
    });
  }

  // Refresh Indicator
  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
  }

  // Update Addres Usage Status
  void updateAddressinUse() {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    DatabaseReference curAddressRef = FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('AddressinUse');
    curAddressRef.once().then((e) async {
      final datasnapshot = e.snapshot;

      if (datasnapshot.value.toString() != 'manual') {
        curAddressRef.set('current');
        UserPreferences.setAddressStatus('current');
      }
    });
  }

  @override
  void initState() {
    setupPositionLocator();
    super.initState();
    updateAddressinUse();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController street = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Static.dashboardCard,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Locales.string(context, 'lbl_address'),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: MaterialButton(
              elevation: 0.0,
              hoverElevation: 0.0,
              focusElevation: 0.0,
              highlightElevation: 0.0,
              minWidth: 60,
              height: 70,
              color: Colors.transparent,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Padding(
                            padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      borderRadius: BorderRadius.circular(50),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.transparent,
                                        child: SvgPicture.asset('images/svg_icons/arrowLeft.svg'),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    Locales.string(context, 'lbl_add_update_manual_address'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CountryStateCityPicker(
                                        country: country,
                                        state: state,
                                        city: city,
                                        textFieldInputBorder: const UnderlineInputBorder(),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: street,
                                        decoration: InputDecoration(
                                          icon: const Icon(Icons.home),
                                          hintText: Locales.string(context, 'hint_enter_street'),
                                          labelText: Locales.string(context, 'lbl_address'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 30, top: 30),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                updateManualAddress();
                                              },
                                              elevation: 0.0,
                                              hoverElevation: 0.0,
                                              focusElevation: 0.0,
                                              highlightElevation: 0.0,
                                              color: Colors.green,
                                              textColor: Colors.white,
                                              minWidth: 50,
                                              height: 15,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 50,
                                                vertical: 15,
                                              ),
                                              child: Text(Locales.string(context, 'lbl_submit')),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                /* showMaterialModalBottomSheet(
                  enableDrag: true,
                  duration: const Duration(milliseconds: 200),
                  isDismissible: false,
                  backgroundColor: Static.dashboardBG,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.only(
                        left: 24, top: 24, right: 24, bottom: 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.transparent,
                                child: SvgPicture.asset(
                                    'images/svg_icons/arrowLeft.svg'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            Locales.string(
                                context, 'lbl_add_update_manual_address'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CountryStateCityPicker(
                                country: country,
                                state: state,
                                city: city,
                                textFieldInputBorder:
                                    const UnderlineInputBorder(),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: street,
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.home),
                                  hintText: Locales.string(
                                      context, 'hint_enter_street'),
                                  labelText:
                                      Locales.string(context, 'lbl_address'),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 30, top: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        updateManualAddress();
                                      },
                                      elevation: 0.0,
                                      hoverElevation: 0.0,
                                      focusElevation: 0.0,
                                      highlightElevation: 0.0,
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      minWidth: 50,
                                      height: 15,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15,
                                      ),
                                      child: Text(Locales.string(
                                          context, 'lbl_submit')),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );*/
              },
              shape: const CircleBorder(),
              child: const Icon(
                FeatherIcons.plusCircle,
                color: Colors.black,
              ),
            ),
          ),
        ],
        backgroundColor: Static.dashboardBG,
        elevation: 0.0,
        toolbarHeight: 70,
        leadingWidth: 100,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Static.dashboardCard,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  Locales.string(context, 'lbl_select_address_to_use'),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Locales.string(context, 'lbl_current_address'),
                      style: const TextStyle(
                        fontFamily: 'Roboto-Bold',
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: addressRadio(
                        selected: true,
                        background: UserPreferences.getAddressStatus() == 'current' ? Static.themeColor[500]! : Colors.black87,
                        title: '${UserPreferences.getUserLocation() ?? currentUserInfo?.currentAddress}',
                        value: UserPreferences.getAddressStatus() == 'current' ? 1 : 0,
                        onChanged: (status) {
                          setState(() => _groupValue = 1);
                          userCurrentAddress('current');
                          UserPreferences.setAddressStatus('current');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      Locales.string(context, 'lbl_manual_address'),
                      style: const TextStyle(
                        fontFamily: 'Roboto-Bold',
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: addressRadio(
                        selected: false,
                        background: UserPreferences.getAddressStatus() == 'manual' ? Static.themeColor[500]! : Colors.black87,
                        title: '${UserPreferences.getManualLocation() ?? currentUserInfo?.manualAddress} ',
                        value: UserPreferences.getAddressStatus() == 'manual' ? 1 : 0,
                        onChanged: (status) {
                          if (UserPreferences.getManualLocation() == Locales.string(context, 'lbl_set_manual_address')) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) => Center(
                                child: Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    margin: const EdgeInsets.all(16.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Icon(
                                            FeatherIcons.info,
                                            size: 35,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            Locales.string(context, 'lbl_add_manual_address'),
                                            style: const TextStyle(fontSize: 15),
                                          ),
                                          Center(
                                              child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                                Colors.black,
                                              ),
                                              foregroundColor: MaterialStateProperty.all(
                                                Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(Locales.string(context, 'lbl_close')),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            setState(() => _groupValue = 1);
                            userCurrentAddress('manual');
                            UserPreferences.setAddressStatus('manual');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addressRadio(
      {required String title, required int value, required bool selected, required Color background, required Function(int?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: background,
          border: Border.all(color: Colors.black26),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(),
          child: RadioListTile(
            value: value,
            groupValue: _groupValue,
            onChanged: onChanged,
            selected: selected,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //  Update User Address Usage Status
  void userCurrentAddress(String status) {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    DatabaseReference curAddressRef = FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('AddressinUse');
    curAddressRef.set(status);
  }

  //  Update Manual Address
  void updateManualAddress() {
    if (city.text.isNotEmpty && state.text.isNotEmpty && country.text.isNotEmpty && street.text.isNotEmpty) {
      String placeName = '${street.text}, ${city.text}, ${state.text}, ${country.text}';
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const Center(
          child: DataLoadedProgress(),
        ),
      );

      currentFirebaseUser = FirebaseAuth.instance.currentUser;

      DatabaseReference curAddressRef =
          FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('manualAddress').child('placename');
      curAddressRef.set(placeName);

      UserPreferences.setManualLocation(placeName);
      if (UserPreferences.getAddressStatus() == 'current') {
        UserPreferences.setAddressStatus('manual');
      } else {
        UserPreferences.setAddressStatus('current');
      }
      Navigator.pop(context);
      Navigator.pop(context);
      setState(() {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => Center(
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        FeatherIcons.check,
                        size: 35,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Manual Address Modified!',
                        style: TextStyle(fontSize: 15),
                      ),
                      Center(
                          child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.black,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    } else {
      setState(() {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => Center(
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        FeatherIcons.info,
                        size: 35,
                        color: Colors.yellow.shade900,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'All Fields Are Required',
                        style: TextStyle(fontSize: 15),
                      ),
                      Center(
                          child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.black,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }
  }
}

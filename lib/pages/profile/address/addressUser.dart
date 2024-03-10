import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/controller/mainController.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:string_similarity/string_similarity.dart';

const kGoogleApiKey = "AIzaSyDBes8BJVASNyCE0hLJjt0Rcaz6BodoKJU";
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class AddressesUser extends StatefulWidget {
  AddressesUser(
    this.user, {
    Key? key,
  }) : super(key: key);
  String? user;

  @override
  _AddressesState createState() => _AddressesState();
}

List<dynamic> _placeList = [];

class _AddressesState extends State<AddressesUser> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late DataSnapshot userDataProfile;

  final _formKey = GlobalKey<FormState>();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  int _groupValue = 1;

  bool manualAdressExists = false;

  String? countryValue;

  String? stateValue;

  String? cityValue;

  var searchTextController = TextEditingController();
  var searchTextGoogleController = TextEditingController();

  void getUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    String? userid = currentFirebaseUser?.uid;

    final UserRef = FirebaseDatabase.instance.ref().child(widget.user.toString()).child(userid!);

    UserRef.once().then((e) async {
      if (e.snapshot != null) {
        final DataSnapshot = e.snapshot;

        userDataProfile = e.snapshot;
      }
    });

    //  }
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController country = TextEditingController();

  TextEditingController state = TextEditingController();

  TextEditingController city = TextEditingController();

  TextEditingController street = TextEditingController();

  Widget startIndicator(String title) {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .ref()
            .child('address')
            .orderByChild("user")
            .equalTo(FirebaseAuth.instance.currentUser!.uid.toString())
            .once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            DataSnapshot? dataListObject = null;
            bool start = false;
            for (var i = 0; i < response.snapshot.children.toList().length; i++) {
              DataSnapshot data = response.snapshot.children.toList()[i];

              if (data.child("").value == title) {
                start = true;
              }
            }

            //return Text(dataListObject!.child("name").value.toString());

            return response.snapshot.children.toList().length == 0
                ? Icon(
                    Icons.star,
                    color: start ? Colors.amber : Colors.grey,
                  )
                : Icon(
                    Icons.star,
                    color: start ? Colors.amber : Colors.grey,
                  );
          } else {
            return SizedBox();
          }
        });
  }

  Widget pageAddress() {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .ref()
            .child('address')
            .orderByChild("user")
            .equalTo(FirebaseAuth.instance.currentUser!.uid.toString())
            .once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;

            DataSnapshot? dataListObject = null;

            //   for (var i = 0; i < response.snapshot.children.toList().length; i++) {

            //return Text(dataListObject!.child("name").value.toString());

            return response.snapshot.children.toList().length == 0
                ? AppWidget().noResult(context)
                : ListView.builder(
                    padding: EdgeInsets.only(left: 10.0),
                    itemCount: response.snapshot.children.toList().length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int i) {
                      DataSnapshot dataList = response.snapshot.children.toList().reversed.toList()[i];

                      Widget itemAddress() {
                        return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Flexible(
                                child: Row(
                              children: [
                                SvgPicture.asset(
                                  "images/icons/iconLocation.svg",
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      userDataProfile.ref.update({
                                        "latitude": double.parse(dataList.child("latitude").value.toString()),
                                        "longitude": double.parse(dataList.child("longitude").value.toString()),
                                        "location": dataList.child("name").value.toString()
                                      }).then((value) {
                                        AppWidget().itemMessage("Ubicación cambiada", context);
                                      }).catchError((onError) {});

                                      /*   widget.dataListObjectGeneral!.ref

                                      .update({'address': dataList.child("name").value.toString()}).then((value) {

                                    Navigator.pop(context);


                                    AppWidget().itemMessage("Dirección actualizada", context);

                                  }).catchError((onError) {

                                    AppWidget().itemMessage("Error actulizar dirección", context);

                                  });*/
                                    },
                                    child: Container(
                                        width: 240,
                                        child: Text(
                                          dataList.child("name").value.toString(),
                                          style: TextStyle(color: secondryColor, fontSize: 14, fontWeight: FontWeight.bold),
                                        ))),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                title: new Text(Locales.string(context, 'lang_location')),
                                                onTap: () {
                                                  dataList.ref.remove().then((value) {
                                                    AppWidget().itemMessage("Eliminado", context);

                                                    setState(() {});
                                                  });

                                                  Navigator.pop(context);
                                                },
                                              ),
                                              /* ListTile(
                                            title: new Text('Actualizar'),
                                            onTap: () {
                                              Navigator.pop(context);

                                              openDialog(true, dataList: dataList);
                                            },
                                          ),*/
                                              ListTile(
                                                title: new Text(Locales.string(context, 'lang_cancel')),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.more_vert_sharp,
                                    color: secondryColor,
                                  ),
                                )
                              ],
                            )));
                      }

                      return searchTextController.text.isEmpty
                          ? itemAddress()
                          : searchTextController.text.similarityTo(dataList.child("name").value.toString()) >= 0.5
                              ? SizedBox()
                              : itemAddress();
                    });
          }

          // }

          return AppWidget().loading(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  key: scaffoldKey,
      key: homeScaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Colors.white,
            child: ListView(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppWidget().back(context),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: handlePressButton,
                              child: Container(
                                  width: 200,
                                  child: Text(
                                    Locales.string(context, 'lang_addlocation'),
                                    style: TextStyle(fontSize: 19, color: secondryColor, fontWeight: FontWeight.bold),
                                  ))),
                          Expanded(child: SizedBox()),

                          /* GestureDetector(

                              onTap: () {

                                openDialog(false);

                              },

                              child: SvgPicture.asset(

                                "images/icons/addCircleBlue.svg",

                                width: 40,

                              )),*/
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                          onTap: handlePressButton,
                          child: AppWidget().texfieldFormat(
                              title: Locales.string(context, 'lang_addnewlocation'),
                              controller: searchTextController,
                              execute: () async {
                                //  await Future.delayed(Duration(milliseconds: 1000)); //   setState(() {});

                                //  getPlaceLocation();

                                //_onChanged();
                              },
                              enabled: true)),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            Locales.string(context, 'lang_locationsaved'),
                            style: TextStyle(fontWeight: FontWeight.bold, color: secondryColor),
                          ),
                          pageAddress(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  void onError(PlacesAutocompleteResponse response) {
    // homeScaffoldKey.currentState.showSnackBar(
    // SnackBar(content: Text(response.errorMessage)),
    //);
  }
  Future<void> handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      // mode: _mode,
      language: "es",
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),

      offset: 0,
      radius: 1000,
      types: [],
      strictbounds: false,
      // region: "ar",

      mode: Mode.overlay, // Mode.fullscreen

      components: [Component(Component.country, "co")] /* components: [Component(Component.country, "fr")]*/,
    );

    displayPrediction(p!, homeScaffoldKey.currentState!);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId.toString());
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      print("NEW RESULT: " + "${p.description} - $lat/$lng");
      savedDataFun(p, detail);

      // scaffold.showSnackBar(
      // SnackBar(content: Text("${p.description} - $lat/$lng")),
      //);
    }
  }

  savedDataFun(Prediction p, PlacesDetailsResponse detail) {
    savedData(String address, String latitude, String longitude) {
      DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('address').push();

      // Prepare data to be saved on users table

      Map userMap = {
        'name': address,
        'latitude': latitude,
        'longitude': longitude,
        'user': FirebaseAuth.instance.currentUser!.uid.toString(),
      };

      newUserRef.set(userMap).then((value) {
        //   Navigator.pop(context);

        setState(() {});

        AppWidget().itemMessage("Guardado", context);
      }).catchError((onError) {
        AppWidget().itemMessage("Error al guardar", context);
      });
    }

    savedData(p.description.toString(), detail.result.geometry!.location.lat.toString(), detail.result.geometry!.location.lng.toString());
    try {
      userDataProfile.ref.update({
        "latitude": detail.result.geometry!.location.lat,
        "longitude": detail.result.geometry!.location.lng,
        "location": p.description.toString(),
      }).then((value) {
        Navigator.pop(context);
        AppWidget().itemMessage("Ubicación cambiada", context);
      }).catchError((onError) {
        AppWidget().itemMessage("Error al cambiar ubicación", context);
      });
    } catch (e) {}
  }
}

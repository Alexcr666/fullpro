import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:fullpro/models/placeAutocompleteModel.dart';
import 'package:geocode/geocode.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/support/newSupport.dart';

import 'package:fullpro/widgets/widget.dart';

import 'package:geolocator/geolocator.dart';

//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:fullpro/utils/globalConstants.dart';

import 'package:fullpro/controller/mainController.dart';

import 'package:fullpro/styles/statics.dart' as Static;

import 'package:fullpro/utils/countryStateCity/AddressPicker.dart';

import 'package:fullpro/utils/userpreferences.dart';

import 'package:fullpro/widgets/DataLoadedProgress.dart';

import 'package:maps_places_autocomplete/maps_places_autocomplete.dart';

import 'package:maps_places_autocomplete/model/place.dart';

import 'package:maps_places_autocomplete/model/suggestion.dart';

import 'dart:async';

import 'package:string_similarity/string_similarity.dart';

class AddressesUser extends StatefulWidget {
  AddressesUser(
    this.user, {
    Key? key,
  }) : super(key: key);
  String? user;

  @override
  _AddressesState createState() => _AddressesState();
}

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

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

    currentPosition = position;

    userLocation = await MainController.findCordinateAddress(position, context);

    UserPreferences.setUserLocation(userLocation!);

    print(userLocation);

    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    DatabaseReference curAddressRef = FirebaseDatabase.instance
        .ref()
        .child(widget.user.toString() + '/${currentFirebaseUser?.uid}')
        .child('currentAddress')
        .child('placename');

    curAddressRef.set(userLocation);

    DatabaseReference curAddCoordinatesRef = FirebaseDatabase.instance
        .ref()
        .child(widget.user.toString() + '/${currentFirebaseUser?.uid}')
        .child('currentAddress')
        .child('location');

    Map CoordinateRef = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    curAddCoordinatesRef.set(CoordinateRef);

    DatabaseReference manualAddressRef = FirebaseDatabase.instance
        .ref()
        .child(widget.user.toString() + '/${currentFirebaseUser?.uid}')
        .child('manualAddress')
        .child('placename');

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

    DatabaseReference curAddressRef =
        FirebaseDatabase.instance.ref().child(widget.user.toString() + '/${currentFirebaseUser?.uid}').child('AddressinUse');

    curAddressRef.once().then((e) async {
      final datasnapshot = e.snapshot;

      if (datasnapshot.value.toString() != 'manual') {
        curAddressRef.set('current');

        UserPreferences.setAddressStatus('current');
      }
    });
  }

  openDialog(bool edit, {DataSnapshot? dataList}) {
    var height = MediaQuery.of(context).size.height;

    var width = MediaQuery.of(context).size.width;

    if (dataList != null) {
      country.text = dataList!.child("country").value.toString();

      state.text = dataList!.child("state").value.toString();

      city.text = dataList!.child("city").value.toString();
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            content: Builder(builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.

              var height = MediaQuery.of(context).size.height;

              var width = MediaQuery.of(context).size.width;

              return Container(
                width: width,
                color: Colors.white,
                padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 0),
                child: ListView(
                  //    mainAxisSize: MainAxisSize.min,

                  children: [
                    AppWidget().back(context),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Agregar direccións",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //kkkk

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
                              hintText: Locales.string(context, 'hint_enter_street'),
                              labelText: Locales.string(context, 'lbl_address'),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          AppWidget().buttonFormColor(context, "Guardar", secondryColor, tap: () {
                            savedData() {
                              DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('address').push();

                              String placeName = '${street.text}, ${city.text}, ${state.text}, ${country.text}';

                              // Prepare data to be saved on users table

                              Map userMap = {
                                'name': placeName,
                                'user': FirebaseAuth.instance.currentUser!.uid.toString(),
                              };

                              newUserRef.set(userMap).then((value) {
                                Navigator.pop(context);

                                setState(() {});

                                AppWidget().itemMessage("Guardado", context);
                              }).catchError((onError) {
                                AppWidget().itemMessage("Error al guardar", context);
                              });
                            }

                            if (_formKey.currentState!.validate()) {
                              if (edit == true) {
                                String placeName = '${street.text}, ${city.text}, ${state.text}, ${country.text}';

                                dataList!.ref.update({'name': placeName}).then((value) {
                                  Navigator.pop(context);

                                  setState(() {});

                                  AppWidget().itemMessage("Guardado", context);
                                });
                              } else {
                                savedData();
                              }
                            }
                          }),

                          /*  Padding(
                                                  padding: const EdgeInsets.only(bottom: 30, top: 30),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [


                                                  /*    MaterialButton(
                                                        onPressed: () {
                                                          // updateManualAddress();

                                                          
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
                                                      ),*/
                                                    ],
                                                  ),
                                                ),

                                                */
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })));
  }

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

  String? _streetNumber;

  String? _street;

  String? _city;

  String? _state;

  String? _zipCode;

  String? _vicinity;

  String? _country;

  double? _lat;

  double? _lng;

  // write a function to receive the place details callback

  void onSuggestionClick(Place placeDetails) {
    setState(() {
      _streetNumber = placeDetails.streetNumber;

      _street = placeDetails.street;

      _city = placeDetails.city;

      _state = placeDetails.state;

      _zipCode = placeDetails.zipCode;

      _country = placeDetails.country;

      _vicinity = placeDetails.vicinity;

      _lat = placeDetails.lat;

      _lng = placeDetails.lng;
    });
  }

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
                      DataSnapshot dataList = response.snapshot.children.toList()[i];

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

          return Text("hola");
        });
  }

  List<PlaceAutocompleteModel> dataPlace = [];

  Future<void> getPlaceLocation() async {
    String value = searchTextController.text;

    final apiUrl = "https://nominatim.openstreetmap.org/search.php?q=$value&featuretype=city&format=jsonv2";

    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
    );

    // if (response.statusCode == 201) {

    log("responsecity: " + response.body.toString());

    dataPlace = placeAutocompleteModelFromJson(response.body.toString());

    setState(() {});

    //  } else {

    //   log("response: " + response.body.toString());

    // }
  }

  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(searchTextController.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyCfsvZ1kjO-mlfDbbu19sJuYKKd7gcfgqw";
    String type = '(regions,geocode)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken&fields=all';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                              onTap: () {},
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
                      AppWidget().texfieldFormat(
                        title: Locales.string(context, 'lang_addnewlocation'),
                        controller: searchTextController,
                        execute: () async {
                          //  await Future.delayed(Duration(milliseconds: 1000)); //   setState(() {});

                          //  getPlaceLocation();

                          _onChanged();
                        },
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _placeList.length,
                        itemBuilder: (context, index) {
                          // log("jsongoogle: " + _placeList[index].toString());
                          return ListTile(
                            onTap: () async {
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

                              try {
                                GeoCode geoCode = GeoCode();
                                Coordinates coordinates =
                                    await geoCode.forwardGeocoding(address: _placeList[index]["description"].toString());
                                savedData(_placeList[index]["description"].toString(), coordinates.latitude.toString(),
                                    coordinates.longitude.toString());
                                print("Latitude: ${coordinates.latitude}");
                                print("Longitude: ${coordinates.longitude}");
                                userDataProfile.ref.update({
                                  "latitude": coordinates.latitude,
                                  "longitude": coordinates.longitude,
                                  "location": _placeList[index]["description"].toString(),
                                }).then((value) {
                                  Navigator.pop(context);
                                  AppWidget().itemMessage("Ubicación cambiada", context);
                                }).catchError((onError) {});
                              } catch (e) {
                                print(e);
                              }
                            },
                            title: Text(_placeList[index]["description"]),
                            /*  trailing: GestureDetector(
                                onTap: () async {
                                

                                  // savedData();
/*
                                  GeoCode geoCode = GeoCode();

                                  try {
                                    Coordinates coordinates =
                                        await geoCode.forwardGeocoding(address: _placeList[index]["description"].toString());

                                    print("Latitude: ${coordinates.latitude}");
                                    print("Longitude: ${coordinates.longitude}");
                                    savedData(_placeList[index]["description"].toString(), coordinates.latitude.toString(),
                                        coordinates.longitude.toString());
                                  } catch (e) {
                                    print(e);
                                  }*/
                                },
                                child: startIndicator(_placeList[index]["description"]))*/
                          );
                        },
                      ),
                      dataPlace == []
                          ? AppWidget().noResult(context)
                          : ListView.builder(
                              padding: EdgeInsets.only(left: 10.0),
                              itemCount: dataPlace.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                PlaceAutocompleteModel data = dataPlace[index];

                                return Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      onTap: () {
                                        userDataProfile.ref.update({
                                          "latitude": data.lat,
                                          "longitude": data.lon,
                                          "location": data.displayName,
                                        }).then((value) {
                                          AppWidget().itemMessage("Ubicación cambiada", context);
                                        }).catchError((onError) {});
                                      },
                                      /*   leading: CircleAvatar(
                                        backgroundColor: Colors.grey.withOpacity(0.3),
                                        radius: 30,
                                      ),*/
                                      trailing: GestureDetector(
                                          onTap: () {
                                            savedData() {
                                              DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('address').push();

                                              // Prepare data to be saved on users table

                                              Map userMap = {
                                                'name': data.displayName,
                                                'latitude': data.lat,
                                                'longitude': data.lon,
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

                                            savedData();
                                          },
                                          child: startIndicator(data.name.toString())),
                                      title: Text(
                                        data.name.toString(),
                                        style: TextStyle(fontWeight: FontWeight.bold, color: secondryColor, fontSize: 13),
                                      ),
                                      subtitle: Text(
                                        data.displayName.toString(),
                                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 10),
                                      ),
                                    ));
                              }),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            Locales.string(context, 'lang_locationsaved'),
                            style: TextStyle(fontWeight: FontWeight.bold, color: secondryColor),
                          ),
                          /* SizedBox(
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
                          ),*/

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

  Widget addressRadioIcon(
      {required String title, required int value, required bool selected, required Color background, required Function(int?) onChanged}) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),

            //color: background,

            //  border: Border.all(color: Colors.black26),
          ),
          child: Slidable(
            // Specify a key if the Slidable is dismissible.

            key: const ValueKey(0),

            // The start action pane is the one at the left or the top side.

            startActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.

              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.

              dismissible: DismissiblePane(onDismissed: () {}),

              // All actions are defined in the children parameter.

              children: const [],
            ),

            // The end action pane is the one at the right or the bottom side.

            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.

                  flex: 2,

                  onPressed: null,

                  backgroundColor: Color(0xFFFE4A49),

                  foregroundColor: Colors.white,

                  icon: Icons.delete,

                  label: Locales.string(context, 'lang_location'),
                ),
              ],
            ),

            // The child of the Slidable is what the user sees when the

            // component is not dragged.

            child: Theme(
                data: Theme.of(context).copyWith(),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        "images/icons/bottom1.svg",
                        width: 30,
                        height: 30,
                      ),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: secondryColor),
                    ),
                    Flexible(
                        child: RadioListTile(
                      value: value,
                      groupValue: _groupValue,
                      onChanged: onChanged,
                      selected: selected,
                      title: Text(
                        title,
                        style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )),
                  ],
                )),
          ),
        ));
  }

  Widget addressRadio(
      {required String title, required int value, required bool selected, required Color background, required Function(int?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),

            //color: background,

            //  border: Border.all(color: Colors.black26),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "images/icons/locationActual.svg",
                width: 50,
                height: 50,
              ),
              Flexible(
                  child: Theme(
                data: Theme.of(context).copyWith(),
                child: RadioListTile(
                  value: value,
                  groupValue: _groupValue,
                  onChanged: onChanged,
                  selected: selected,
                  title: Text(
                    title,
                    style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              )),
            ],
          )),
    );
  }

  //  Update User Address Usage Status

  void userCurrentAddress(String status) {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    DatabaseReference curAddressRef =
        FirebaseDatabase.instance.ref().child(widget.user.toString() + '/${currentFirebaseUser?.uid}').child('AddressinUse');

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

      DatabaseReference curAddressRef = FirebaseDatabase.instance
          .ref()
          .child(widget.user.toString() + '/${currentFirebaseUser?.uid}')
          .child('manualAddress')
          .child('placename');

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

                      /* Text(
                        'Manual Address Modified!',
                        style: TextStyle(fontSize: 15),
                      ),*/

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

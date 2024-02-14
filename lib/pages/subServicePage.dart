import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/pages/cartPage.dart';
import 'package:fullpro/pages/homepage.dart';
import 'package:fullpro/pages/profesional/profileProfesional.dart';
import 'package:fullpro/utils/utils.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/animation/fadeTop.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/cartController.dart';
import 'package:fullpro/controller/categoryController.dart';
import 'package:fullpro/models/SingleServices.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/cartBottomButton.dart';
import 'package:url_launcher/url_launcher.dart';

class subServicePage extends StatefulWidget {
  subServicePage({Key? key, this.idPage, this.title, this.price, this.description, this.urlImage}) : super(key: key);
  String? idPage;
  String? title;
  String? price;
  String? urlImage;
  String? description;

  @override
  _subServicePageState createState() => _subServicePageState();
}

createOrdens(BuildContext context, {String? name, String? inspections, String? profesionalName, String? profesional, int? price}) {
  savedData() {
    DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('ordens').push();

    // Prepare data to be saved on users table

    Map userMap = {
      'name': name,
      'rating': 0,
      'inspections': inspections,
      'professionalName': profesional,
      'professional': profesional,
      'user': currentFirebaseUser!.uid.toString(),
      'state': 0,
      'price': price
    };

    newUserRef.set(userMap).then((value) {
      userDataProfile!.ref.update({"cart": newUserRef.key.toString()}).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartPage(
                      id: newUserRef.key.toString(),
                    )));
      });

      //  Navigator.pop(contextAlert);

      //  AppWidget().itemMessage("Guardado", context);

      /*Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => CartPage()));*/
    }).catchError((onError) {
      AppWidget().itemMessage("Guardado", context);
    });
  }

  if (userDataProfile!.child("cart").value == null) {
    savedData();
  } else {
    AppWidget().itemMessage("Ya hay una orden activa", context);
  }
}

class _subServicePageState extends State<subServicePage> {
  TextEditingController search = TextEditingController();

  TextEditingController dateService = TextEditingController();
  TextEditingController hourService = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool inspeccion = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      CartController.checkCart();
      setState(() {
        if (catDataLoaded == false && categoryServicesList.isEmpty) {
          setState(() {
            //  CategoryController.getSingleServiceCat(widget.serviceId, context);
          });
        }
        if (catDataLoaded == true && categoryServicesList.isEmpty) {
          setState(() {
            categoryServicesList = Provider.of<AppData>(context, listen: false).SingleCatServiceData;
          });
        }
      });
    }
    // Repeating Function
    timer = Timer.periodic(
      repeatTime,
      (Timer t) => setState(() {
        CartController.checkCart();
      }),
    );
  }

  onSearch(String search) {
    setState(() {
      categoryServicesList = Provider.of<AppData>(context, listen: false)
          .SingleCatServiceData
          .where((Services) => Services.name!.toLowerCase().contains(search))
          .toList();
      catListLoaded = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryServicesList.clear();
    catDataLoaded = false;
    catListLoaded = false;
    timer?.cancel();
  }

  Future<DatabaseEvent> getQuerySubService() {
    Future<DatabaseEvent> data = FirebaseDatabase.instance.ref().child('partners').orderByChild("profesion").equalTo(widget.title).once();
    /* if (search.text.isNotEmpty) {

      data = FirebaseDatabase.instance
          .ref()
          .child("partners")
          .orderByChild("fullname")
          .startAt(_searchController.text.toString())
          .endAt(_searchController.text.toString() + "\uf8ff")
          .limitToFirst(int.parse(dropdownvalue.toString()))
          .once();
    }*/
    return data;
  }

  Widget pageService(bool inspections) {
    return FutureBuilder(
        //  initialData: 1,
        future: FirebaseDatabase.instance.ref().child('portafolio').orderByChild("category").equalTo(widget.title).once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            DatabaseEvent response = snapshot.data;
            bool resultService = false;
            bool resultInspections = false;

            return response == null
                ? AppWidget().loading()
                : response.snapshot.children.length == 0
                    ? AppWidget().noResult(context)
                    : ListView.builder(
                        itemCount: response.snapshot.children.length,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          DataSnapshot dataList = response.snapshot.children.toList()[index];

                          Widget itemList() {
                            return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              title: new Text(Locales.string(context, 'lang_watchportafolio')),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                final Uri url = Uri.parse(dataList.child("foto").value.toString());
                                                if (!await launchUrl(url)) {
                                                  throw Exception('Could not launch');
                                                }
                                              },
                                            ),
                                            ListTile(
                                              title: new Text(Locales.string(context, 'lang_watchprofile')),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ProfileProfesionalPage(
                                                              id: dataList.child("user").value.toString(),
                                                            )));
                                              },
                                            ),
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
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: AppWidget().boxShandowGreyRectangule(),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      AppWidget().circleProfile(dataList.child("foto").value.toString()),
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
                                          Row(
                                            children: [
                                              Text(
                                                dataList.child("name").value.toString().capitalize(),
                                                style: TextStyle(color: secondryColor, fontSize: 17, fontWeight: FontWeight.bold),
                                              ),
                                              Expanded(child: SizedBox()),
                                              Container(
                                                  width: 80,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext contextAlert) {
                                                            DataSnapshot? dataPartners;
                                                            return AlertDialog(
                                                              backgroundColor: Colors.white,
                                                              insetPadding: EdgeInsets.all(0),
                                                              contentPadding: EdgeInsets.all(0),
                                                              content: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    color: Colors.white,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                      Container(
                                                                          width: double.infinity,
                                                                          child: Text(
                                                                            Locales.string(context, 'lang_infoservicio'),
                                                                            style: TextStyle(
                                                                                color: secondryColor,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 17),
                                                                            textAlign: TextAlign.center,
                                                                          )),
                                                                      SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.circular(25),
                                                                        child: Image.network(
                                                                          dataList.child("foto").value == null
                                                                              ? ""
                                                                              : dataList.child("foto").value.toString(),
                                                                          errorBuilder: (BuildContext? context, Object? exception,
                                                                              StackTrace? stackTrace) {
                                                                            return Container(
                                                                              width: 200,
                                                                              height: 100,
                                                                              color: Colors.grey.withOpacity(0.3),
                                                                            );
                                                                          },
                                                                          width: 220,
                                                                          height: 100,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 10),
                                                                        child: Text(
                                                                          "Descripción",
                                                                          style: TextStyle(
                                                                              color: secondryColor,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                        alignment: Alignment.centerLeft,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 4,
                                                                      ),
                                                                      Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          margin: EdgeInsets.only(left: 10, right: 20),
                                                                          child: Text(
                                                                            dataList.child("name").value == null
                                                                                ? Locales.string(context, 'lang_nodisponible')
                                                                                : dataList.child("name").value.toString(),
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12),
                                                                          )),
                                                                      SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                              margin: EdgeInsets.only(left: 10),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Categoria",
                                                                                    style: TextStyle(
                                                                                        color: secondryColor,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 16),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Text(
                                                                                    dataList.child("category").value == null
                                                                                        ? Locales.string(context, 'lang_nodisponible')
                                                                                        : dataList.child("category").value.toString(),
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 13),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Text(
                                                                                    "Calificación",
                                                                                    style: TextStyle(
                                                                                        color: secondryColor,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 15),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Text(dataPartners == null
                                                                                      ? ""
                                                                                      : dataPartners!.child("fullname").value.toString()),
                                                                                  FutureBuilder(
                                                                                      future: FirebaseDatabase.instance
                                                                                          .ref()
                                                                                          .child('partners')
                                                                                          .child(dataList.child("user").value.toString())
                                                                                          .once(),
                                                                                      builder:
                                                                                          (BuildContext context, AsyncSnapshot snapshot) {
                                                                                        if (snapshot.hasData) {
                                                                                          DatabaseEvent response = snapshot.data;
                                                                                          DataSnapshot dataRating = response.snapshot;
                                                                                          dataPartners = dataRating;

                                                                                          return SizedBox();
                                                                                        } else {
                                                                                          return AppWidget().loading();
                                                                                        }
                                                                                      }),
                                                                                  Text(dataPartners == null
                                                                                      ? ""
                                                                                      : dataPartners!.child("fullname").value.toString()),
                                                                                  AppWidget().ratingBarProfessional(
                                                                                      dataList.child("user").value.toString()),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                          Expanded(child: SizedBox()),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Text(
                                                                                Locales.string(context, 'lang_costservice'),
                                                                                style: TextStyle(
                                                                                    color: secondryColor,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 15),
                                                                              ),
                                                                              Text(
                                                                                dataList.child("price").value == null
                                                                                    ? '\$' + "0"
                                                                                    : '\$' +
                                                                                        MoneyFormatter(
                                                                                                amount: double.parse(dataList
                                                                                                    .child("price")
                                                                                                    .value
                                                                                                    .toString()))
                                                                                            .output
                                                                                            .withoutFractionDigits
                                                                                            .toString(),
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 16),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 40,
                                                                              ),
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
                                                                      Container(
                                                                          margin: EdgeInsets.only(left: 20, right: 20),
                                                                          child: Row(
                                                                            children: [
                                                                              Flexible(
                                                                                  child: AppWidget().buttonFormLine(
                                                                                      context, Locales.string(context, 'lang_cancel'), true,
                                                                                      tap: () {
                                                                                Navigator.pop(context);
                                                                              })),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Flexible(
                                                                                  child: AppWidget().buttonFormLine(
                                                                                      context,
                                                                                      Locales.string(context, 'lang_solicitudtext'),
                                                                                      false, tap: () {
                                                                                Navigator.pop(context);

                                                                                Query historyRef = FirebaseDatabase.instance
                                                                                    .ref()
                                                                                    .child('ordens')
                                                                                    .child(userDataProfile!.child("cart").value.toString());

                                                                                createService(DataSnapshot snapshot) {
                                                                                  snapshot.ref.child("services").push().set({
                                                                                    "foto": dataList.child("foto").value.toString(),
                                                                                    "name": dataList.child("name").value,
                                                                                    "price": dataList.child("price").value
                                                                                  }).then((value) {
                                                                                    AppWidget().itemMessage("Agregado", context);
                                                                                  }).catchError((onError) {
                                                                                    AppWidget()
                                                                                        .itemMessage("Ha ocurrido un error", context);
                                                                                  });
                                                                                }

                                                                                if (userDataProfile!.child("cart").value != null) {
                                                                                  historyRef.once().then((e) async {
                                                                                    final snapshot = e.snapshot;
                                                                                    if (snapshot.value != null) {
                                                                                      if (snapshot.child("professional").value.toString() ==
                                                                                          userDataProfile!.key.toString()) {
                                                                                        createService(snapshot);
                                                                                      } else {
                                                                                        AppWidget().itemMessage(
                                                                                            "No se puede seleccionar otro professional",
                                                                                            context);
                                                                                      }
                                                                                    } else {
                                                                                      createOrdens(context,
                                                                                          name: dataList.child("name").value.toString(),
                                                                                          inspections: dataList
                                                                                              .child("inspections")
                                                                                              .value
                                                                                              .toString(),
                                                                                          profesionalName: dataPartners!
                                                                                              .child("fullname")
                                                                                              .value
                                                                                              .toString(),
                                                                                          profesional: dataPartners!.key,
                                                                                          price: int.parse(
                                                                                              dataList.child("price").value.toString()));

                                                                                      Future.delayed(const Duration(milliseconds: 1000),
                                                                                          () {
                                                                                        createService(snapshot);
                                                                                      });
                                                                                    }
                                                                                  });
                                                                                } else {
                                                                                  createOrdens(context,
                                                                                      name: dataList.child("name").value.toString(),
                                                                                      inspections:
                                                                                          dataList.child("inspections").value.toString(),
                                                                                      profesionalName:
                                                                                          dataPartners!.child("fullname").value.toString(),
                                                                                      profesional: dataPartners!.key.toString(),
                                                                                      price: int.parse(
                                                                                          dataList.child("price").value.toString()));

                                                                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                                                                    // createService(snapshot);

                                                                                    Query historyRef = FirebaseDatabase.instance
                                                                                        .ref()
                                                                                        .child('ordens')
                                                                                        .child(userDataProfile!
                                                                                            .child("cart")
                                                                                            .value
                                                                                            .toString());
                                                                                    historyRef.once().then((value) {
                                                                                      createService(value.snapshot);
                                                                                    });
                                                                                  });
                                                                                }
                                                                              })),
                                                                            ],
                                                                          )),
                                                                      SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                    ],
                                                                  )),
                                                            );
                                                          });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: secondryColor,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            Locales.string(context, 'lang_solicitudtext'),
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              SizedBox(width: 40),
                                            ],
                                          ),
                                          Text(
                                            Locales.string(context, 'lang_solicitudtext'),
                                            style: TextStyle(color: Colors.black, fontSize: 10),
                                          ),
                                          AppWidget().ratingBarProfessional(dataList.child("user").value.toString()),
                                          /* FutureBuilder(
                                              future: FirebaseDatabase.instance
                                                  .ref()
                                                  .child('partners')
                                                  .child(dataList.child("user").value.toString())
                                                  .once(),
                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  DatabaseEvent response = snapshot.data;
                                                  DataSnapshot dataRating = response.snapshot;

                                                  return RatingBarIndicator(
                                                      rating: dataRating.child("rating").value == null
                                                          ? 0
                                                          : double.parse(dataRating.child("rating").value.toString()),
                                                      itemCount: 5,
                                                      itemSize: 16.0,
                                                      itemBuilder: (context, _) => Icon(
                                                            Icons.star,
                                                            color: secondryColor,
                                                          ));
                                                } else {
                                                  return AppWidget().loading();
                                                }
                                              }),*/
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
                          }

                          if (search.text.isEmpty == false) {
                            if (search.text.contains(dataList.child("fullname").value.toString())) {
                              return itemList();
                            } else {
                              return SizedBox();
                            }
                          } else {
                            getInspections() {
                              int type = 1;
                              if (inspeccion == true) {
                                resultInspections = true;
                                type = 2;
                              } else {
                                resultService = true;
                                type = 1;
                              }
                              return type;
                            }

                            return getInspections() != dataList.child("type").value
                                ? ((index + 1) == response.snapshot.children.length)
                                    ? /* AppWidget().noResult(context)*/
                                    SizedBox()
                                    : SizedBox()
                                : itemList();
                          }
                        });
          } else {
            return AppWidget().loading();
          }

          ;
        });
  }
/*
  Widget pageProfessional(bool inspections) {
    return FutureBuilder(
        //  initialData: 1,
        future: getQuerySubService(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;

              return response == null
                  ? AppWidget().loading()
                  : response.snapshot.children.length == 0
                      ? AppWidget().noResult(context)
                      : ListView.builder(
                          itemCount: response.snapshot.children.length,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            DataSnapshot dataList = response.snapshot.children.toList()[index];

                            Widget itemList() {
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
                                            Row(
                                              children: [
                                                Text(
                                                  dataList.child("fullname").value.toString(),
                                                  style: TextStyle(color: secondryColor, fontSize: 17, fontWeight: FontWeight.bold),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Container(
                                                    width: 80,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => ProfileProfesionalPage(
                                                                      id: dataList.key.toString(),
                                                                    )));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: secondryColor,
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 8,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              Locales.string(context,'lang_solicitudtext'),
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                                SizedBox(width: 40),
                                              ],
                                            ),
                                            Text(
                                              Locales.string(context,'lang_solicitudtext'),
                                              style: TextStyle(color: Colors.black, fontSize: 10),
                                            ),
                                            RatingBarIndicator(
                                                rating: dataList.child("rating").value == null
                                                    ? 0
                                                    : double.parse(dataList.child("rating").value.toString()),
                                                itemCount: 5,
                                                itemSize: 16.0,
                                                itemBuilder: (context, _) => Icon(
                                                      Icons.star,
                                                      color: secondryColor,
                                                    )),
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
                            }

                            if (search.text.isEmpty == false) {
                              if (search.text.contains(dataList.child("fullname").value.toString())) {
                                return itemList();
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return itemList();
                            }
                          });
            } else {
              return AppWidget().loading();
            }

            ;
          } catch (e) {
            return AppWidget().loading();
          }
        });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: UserPreferences.getcartStatus() == 'full' || cartStatus == 'full' ? const CartBottomButton() : const SizedBox(),
      /*  appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        elevation: .8,
        toolbarHeight: 120,
        leadingWidth: 0,
        backgroundColor: Static.dashboardBG,
        title: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                  padding: const EdgeInsets.all(10),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  widget.serviceId == 'ac_services'
                      ? Locales.string(context, 'srvs_ac_services').toUpperCase()
                      : widget.serviceId == 'home_appliances'
                          ? Locales.string(context, 'srvs_appliance').toUpperCase()
                          : widget.serviceName.toString().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            /*   SizedBox(
              height: 50,
              child: TextField(
                onChanged: (value) => onSearch(value),
                
                decoration: InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(width: 1.0, color: Static.colorTextLight)),
                  fillColor: Static.dashboardCard,
                  contentPadding: const EdgeInsets.all(0),
                  prefixIcon: const Icon(
                    FeatherIcons.search,
                    color: Static.colorTextLight,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Static.colorTextLight,
                  ),
                  hintText: Locales.string(context, 'lbl_search') ,
                ),
              ),
            ),*/
          ],
        ),
      ),*/
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
              left: leftPadding,
              right: rightPadding,
              bottom: bottomPadding,
              top: topPadding,
            ),
            child: Column(
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
                    SvgPicture.asset(
                      "images/icons/solicitud.svg",
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      Locales.string(context, 'lang_solicitud'),
                      style: TextStyle(color: secondryColor, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: SizedBox()),
                    SvgPicture.asset(
                      "images/icons/edit.svg",
                      width: 20,
                      height: 20,
                      color: secondryColor,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: AppWidget().buttonFormLine(context, Locales.string(context, 'lang_services'), inspeccion != false, tap: () {
                      inspeccion = false;
                      setState(() {});
                    })),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child:
                            AppWidget().buttonFormLine(context, Locales.string(context, 'lang_inspections'), inspeccion != true, tap: () {
                      inspeccion = true;
                      setState(() {});
                    })),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                /*inspeccion
                    ? Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  void _showIOS_DatePicker(ctx) {
                                    showCupertinoModalPopup(
                                        context: ctx,
                                        builder: (_) => Container(
                                              height: 190,
                                              color: Color.fromARGB(255, 255, 255, 255),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 180,
                                                    child: CupertinoDatePicker(
                                                        mode: CupertinoDatePickerMode.date,
                                                        initialDateTime: DateTime.now(),
                                                        onDateTimeChanged: (val) {
                                                          setState(() {
                                                            final f = new DateFormat('yyyy-MM-dd');

                                                            dateService.text = f.format(val);
                                                            //  dateSelected = val.toString();
                                                          });
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ));
                                  }

                                  _showIOS_DatePicker(context);
                                },
                                child: AppWidget().texfieldFormat(
                                    title: Locales.string(context, 'lang_dateservice'),
                                    urlIcon: "images/icons/calendar.svg",
                                    enabled: true,
                                    controller: dateService)),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  void _showIOS_DatePicker(ctx) {
                                    showCupertinoModalPopup(
                                        context: ctx,
                                        builder: (_) => Container(
                                              height: 190,
                                              color: Color.fromARGB(255, 255, 255, 255),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 180,
                                                    child: CupertinoDatePicker(
                                                        mode: CupertinoDatePickerMode.time,
                                                        initialDateTime: DateTime.now(),
                                                        onDateTimeChanged: (val) {
                                                          setState(() {
                                                            //    final f = new DateFormat('yyyy-MM-dd');

                                                            hourService.text = DateFormat('hh:mm:ss').format(val).toString();
                                                            //  dateSelected = val.toString();
                                                          });
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ));
                                  }

                                  _showIOS_DatePicker(context);
                                },
                                child: AppWidget().texfieldFormat(
                                    title: Locales.string(context, 'lang_timeservice'),
                                    urlIcon: "images/icons/calendar.svg",
                                    enabled: true,
                                    controller: hourService)),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ))
                    : Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: AppWidget().texfieldFormat(
                            controller: search,
                            title: Locales.string(context, 'lbl_search'),
                            execute: () {
                              onSearch(search.text.toString());
                            })),*/
                SizedBox(
                  height: 10,
                ),
                // Text(widget.title.toString()),
                Expanded(child: pageService(inspeccion)),
                //  Expanded(child: pageProfessional(inspeccion))
              ],
            )),
      ),
    );
  }

  ServicesComponent(DataSnapshot data) {
    return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            child: Container(
              decoration: AppWidget().boxShandowGreyRectangule(),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      data.child("foto").value.toString(),
                      width: 85,
                      height: 85,
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
                      Row(
                        children: [
                          Container(
                              width: 160,
                              child: Text(
                                "kServices.name!,",
                                style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold),
                              )),
                          Container(
                              width: 80,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          insetPadding: EdgeInsets.all(0),
                                          contentPadding: EdgeInsets.all(0),
                                          content: Container(
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                      width: double.infinity,
                                                      child: Text(
                                                        Locales.string(context, 'lang_infoservicio'),
                                                        style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 17),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(25),
                                                    child: Image.network(
                                                      "",
                                                      errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                        return Container(
                                                          width: 200,
                                                          height: 100,
                                                          color: Colors.grey.withOpacity(0.3),
                                                        );
                                                      },
                                                      width: 220,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsets.only(left: 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                Locales.string(context, 'lang_nameservice'),
                                                                style: TextStyle(
                                                                    color: secondryColor, fontWeight: FontWeight.bold, fontSize: 12),
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                "Categoria",
                                                                style: TextStyle(
                                                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              // AppWidget()
                                                              //   .ratingBarProfessional(data.child("professional").value.toString()),
                                                              /*   RatingBarIndicator(
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
                                                            ],
                                                          )),
                                                      Expanded(child: SizedBox()),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            Locales.string(context, 'lang_costservice'),
                                                            style:
                                                                TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                                          ),
                                                          Text(
                                                            '\$' + "00.000",
                                                            style:
                                                                TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                          ),
                                                          SizedBox(
                                                            height: 40,
                                                          ),
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
                                                  Container(
                                                      margin: EdgeInsets.only(left: 20, right: 20),
                                                      child: Text(
                                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc mollis, enim eget fringilla porta, magna lectus commodo erat, eu pharetra augue augue nec risus. Donec consectetur nulla dui, eget posuere leo cursus vitae. Suspendisse tempor eros in dolor dapibus, sit amet",
                                                        style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 12),
                                                      )),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(left: 20, right: 20),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                              child: AppWidget().buttonFormLine(
                                                                  context, Locales.string(context, 'lang_cancel'), true, tap: () {
                                                            Navigator.pop(context);
                                                          })),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Flexible(
                                                              child: AppWidget().buttonFormLine(
                                                                  context, Locales.string(context, 'lbl_accept'), false, tap: () {
                                                            Navigator.pop(context);
                                                          })),
                                                        ],
                                                      )),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              )),
                                        );
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: secondryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        Locales.string(context, 'lang_solicitudtext'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      ),
                      Text(
                        " kServices.chargemod!",
                        style: const TextStyle(
                          color: Static.colorTextLight,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 3),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: Row(
                          children: [
                            /*kServices.discount != '0'
                            ? Text(
                                currencyPos == 'left'
                                    ? '$currencySymbol${int.parse(kServices.price.toString())}'
                                    : '${int.parse(kServices.price.toString())}$currencySymbol',
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.black,
                                  decorationThickness: 2,
                                ),
                              )
                            : const SizedBox(),*/
                            false ? const SizedBox(width: 15) : const SizedBox(),
                            /*  Text(
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
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 3,
                              ),
                              decoration: const BoxDecoration(
                                color: Static.dashboardCard,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: secondryColor,
                                  ),
                                  Text(
                                    " kServices.rating!",
                                  ),
                                ],
                              ),
                            ),
                            //
                            SizedBox(width: MediaQuery.of(context).size.width * .15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

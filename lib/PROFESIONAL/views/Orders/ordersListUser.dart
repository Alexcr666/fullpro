import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:fullpro/PROFESIONAL/config.dart';

import 'package:fullpro/PROFESIONAL/controllers/loader.dart';

import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';

import 'package:fullpro/PROFESIONAL/controllers/orderController.dart';

import 'package:fullpro/PROFESIONAL/detailsOrderProfessional.dart';

import 'package:fullpro/PROFESIONAL/models/ordersModel.dart';

import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';

import 'package:fullpro/PROFESIONAL/views/Orders/orderDetail.dart';

import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';

import 'package:fullpro/PROFESIONAL/widget/accountHold.dart';

import 'package:fullpro/const.dart';

import 'package:fullpro/controller/mainController.dart';

import 'package:fullpro/pages/INTEGRATION/styles/color.dart';

import 'package:fullpro/pages/detailsOrder.dart';

import 'package:fullpro/pages/profesional/profileProfesional.dart';

import 'dart:async';

import 'package:fullpro/styles/statics.dart' as appcolors;

import 'package:fullpro/styles/statics.dart';
import 'package:fullpro/utils/utils.dart';

import 'package:fullpro/widgets/widget.dart';

class SolicitudList extends StatefulWidget {
  const SolicitudList({Key? key}) : super(key: key);

  static const String id = 'MyOrders';

  @override
  _SolicitudListState createState() => _SolicitudListState();
}

Widget pageOrdensWidget(int state) {
  return FutureBuilder(
      future: FirebaseDatabase.instance
          .ref()
          .child('ordens')
          .orderByChild("professional")
          .equalTo(FirebaseAuth.instance.currentUser!.uid.toString())
          .once(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          DatabaseEvent response = snapshot.data;

          DataSnapshot? dataListObject = null;

          return response.snapshot.children.toList().length == 0
              ? AppWidget().noResult(context)
              : ListView.builder(
                  padding: EdgeInsets.only(left: 10.0),
                  itemCount: response.snapshot.children.toList().length,

                  // physics: NeverScrollableScrollPhysics(),

                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int i) {
                    DataSnapshot dataList = response.snapshot.children.toList()[i];
                    bool emptyResult = false;
                    int lenght = response.snapshot.children.toList().length;

                    if (int.parse(dataList!.child("state").value.toString()) != state) {
                      emptyResult = true;
                    }

                    return int.parse(dataList!.child("state").value.toString()) != state
                        ? (i + 1) != lenght
                            ? SizedBox()
                            : emptyResult != true
                                ? SizedBox()
                                : AppWidget().noResult(context)
                        : Padding(
                            padding: const EdgeInsets.all(5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsOrderProfessionalPage(
                                              dataList: dataList,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                width: double.infinity,
                                decoration: AppWidget().boxShandowGrey(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      FutureBuilder(
                                          future: FirebaseDatabase.instance
                                              .ref()
                                              .child('users')
                                              .child(dataList.child("user").value.toString())
                                              .once(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              DatabaseEvent response = snapshot.data;

                                              return AppWidget().circleProfile(response.snapshot.child("photo").value.toString(), size: 57);
                                            } else {
                                              return SizedBox();
                                            }
                                          }),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            //  width: MediaQuery.of(context).size.width * .6,

                                            child: Text(
                                              dataList.child("name").value == null
                                                  ? Locales.string(context, 'lang_nodisponible')
                                                  : dataList.child("name").value.toString().capitalize(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: secondryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          RatingBarIndicator(
                                              rating: dataList.child("ratingProfessional").value == null
                                                  ? 0
                                                  : double.parse(dataList.child("ratingProfessional").value.toString()),
                                              itemCount: 5,
                                              itemSize: 18.0,
                                              itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: secondryColor,
                                                  )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "images/icons/userCircle.svg",
                                                color: Colors.grey,
                                                height: 15,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              FutureBuilder(
                                                  future: FirebaseDatabase.instance
                                                      .ref()
                                                      .child('users')
                                                      .child(dataList.child("user").value.toString())
                                                      .once(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                    if (snapshot.hasData) {
                                                      DatabaseEvent response = snapshot.data;

                                                      return Text(
                                                        response.snapshot.child("fullname").value == null
                                                            ? "Sin asignar"
                                                            : response.snapshot.child("fullname").value.toString(),
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      );
                                                    } else {
                                                      return SizedBox();
                                                    }
                                                  }),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "images/icons/calendar.svg",
                                                color: Colors.grey,
                                                height: 15,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                dataList.child("date").value == null
                                                    ? Locales.string(context, 'lang_nodisponible')
                                                    : dataList.child("date").value.toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,

                                                  //fontWeight: FontWeight.bold,

                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Expanded(child: SizedBox()),
                                      Column(
                                        children: [
                                          /* Container(
                                              width: 140,
                                              height: 40,
                                              child: AppWidget().buttonFormColor(
                                                  context,
                                                  stateOrder[int.parse(dataList!.child("state").value.toString())],
                                                  stateOrderColor[int.parse(dataList!.child("state").value.toString())],
                                                  tap: () {})),*/

                                          Text(
                                            getStateOrder(context, int.parse(dataList!.child("state").value.toString())),
                                            style: TextStyle(
                                                color: stateOrderColor[int.parse(dataList!.child("state").value.toString())],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              width: 140,
                                              height: 40,
                                              child: AppWidget().buttonFormColor(
                                                  context, Locales.string(context, 'lang_cancel'), Colors.red.withOpacity(0.3), tap: () {
                                                dataList.ref.update({'state': 3}).then((value) {
                                                  AppWidget().itemMessage("Actualizado", context);
                                                });
                                              })),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                  });
        }

        // }

        return AppWidget().loading(context);
      });
}

class _SolicitudListState extends State<SolicitudList> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  late TabController _tabController;

  String searchText = "";

  var _searchController = TextEditingController();

  bool userCheck = false;

  bool profesionalCheck = false;

  bool serviceCheck = false;

  Timer? timer;

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);

    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    OrderController.getOrders(context);

    if (ordersDataLoaded == true && ordersItemsList.isEmpty) {
      OrderController.getOrders(context);
    }

    // Repeating Function

    timer = Timer.periodic(
      repeatTime,
      (Timer t) => setState(() {}),
    );
    Timer.run(() {
      positionFilter = 1;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    ordersItemsList.clear();

    ordersListLoaded = false;

    ordersDataLoaded = false;

    timer?.cancel();
  }

  int positionFilter = 0;

  Widget itemAdd(String url, String title, bool active, {Function? tap}) {
    return GestureDetector(
        onTap: () {
          tap!();
        },
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [
                      secondryColor,
                      primaryColor,
                    ],
                    begin: const FractionalOffset(1.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      height: 20,
                      child: active
                          ? Container(
                              margin: EdgeInsets.only(right: 10),

                              // or ClipRRect if you need to clip the content

                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1, color: Colors.white)),

                              child: Container(
                                padding: EdgeInsets.all(3),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ), // inner content
                            )
                          : SvgPicture.asset("images/icons/add.svg")),
                  SvgPicture.asset(
                    url,
                    width: 60,
                    height: 60,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title.toString(),
              style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget pageUsers() {
    return FutureBuilder(
        initialData: 1,
        future: FirebaseDatabase.instance.ref().child('users').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;

              return response == null
                  ? AppWidget().loading(context)
                  : ListView.builder(
                      itemCount: response.snapshot.children.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        DataSnapshot dataList = response.snapshot.children.toList()[index];

                        Widget itemList() {
                          return Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: AppWidget().boxShandowGreyRectangule(),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  radius: 40,
                                ),
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
                                      Locales.string(context, 'lang_solicitudtext'),
                                      style: TextStyle(color: Colors.black, fontSize: 10),
                                    ),
                                    RatingBarIndicator(
                                        rating: 2.5,
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
                          );
                        }

                        if (_searchController.text.isEmpty == false) {
                          if (searchText.contains(dataList.child("fullname").value.toString())) {
                            return itemList();
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return itemList();
                        }
                      });
            } else {
              return AppWidget().loading(context);
            }

            ;
          } catch (e) {
            return AppWidget().loading(context);
          }
        });
  }

  Widget pageProfessional() {
    return FutureBuilder(
        initialData: 1,
        future: FirebaseDatabase.instance.ref().child('partners').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;

              return response == null
                  ? AppWidget().loading(context)
                  : ListView.builder(
                      itemCount: response.snapshot.children.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        DataSnapshot dataList = response.snapshot.children.toList()[index];

                        Widget itemList() {
                          return Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: AppWidget().boxShandowGreyRectangule(),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  radius: 40,
                                ),
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
                                      Locales.string(context, 'lang_solicitudtext'),
                                      style: TextStyle(color: Colors.black, fontSize: 10),
                                    ),
                                    RatingBarIndicator(
                                        rating: 2.5,
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
                          );
                        }

                        if (_searchController.text.isEmpty == false) {
                          if (searchText.contains(dataList.child("fullname").value.toString())) {
                            return itemList();
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return itemList();
                        }
                      });
            } else {
              return AppWidget().loading(context);
            }

            ;
          } catch (e) {
            return AppWidget().loading(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: appcolors.dashboardCard,

      /* appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: appcolors.dashboardBG,
        centerTitle: true,
        title: Text(
          Locales.string(context, 'lbl_orders'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),*/

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),

          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              SvgPicture.asset(
                "images/icons/iconSolicitud.svg",
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Estado de solicitudes",
                style: TextStyle(color: secondryColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(child: SizedBox()),
              SvgPicture.asset(
                "images/icons/edit.svg",
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),

          Expanded(
              child: ListView(
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 110,
                      child: AppWidget().buttonShandow("Terminado", color: stateOrderColor[3], colorText: Colors.white, tap: () {
                        positionFilter = 1;

                        setState(() {});
                      })),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              pageOrdensWidget(0),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 110,
                    child: AppWidget().buttonShandow("En curso", color: stateOrderColor[1], colorText: Colors.white, tap: () {
                      positionFilter = 1;

                      setState(() {});
                    })),
              ]),
              SizedBox(
                height: 10,
              ),
              pageOrdensWidget(1),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 110,
                    child: AppWidget().buttonShandow("Pendiente", color: redButton, colorText: Colors.white, tap: () {
                      positionFilter = 1;

                      setState(() {});
                    })),
              ]),
              SizedBox(
                height: 10,
              ),
              pageOrdensWidget(2),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 110,
                    child: AppWidget().buttonShandow("Cancelado", color: redButton, colorText: Colors.white, tap: () {
                      positionFilter = 1;

                      setState(() {});
                    })),
              ]),
              SizedBox(
                height: 10,
              ),
              pageOrdensWidget(3),
            ],
          ))

          //
        ],
      ),
    );
  }

  Widget pageOrdens() {
    return FutureBuilder(
        initialData: 1,
        future: FirebaseDatabase.instance.ref().child('ordens').once(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.hasData) {
              DatabaseEvent response = snapshot.data;

              return response == null
                  ? AppWidget().loading(context)
                  : ListView.builder(
                      itemCount: response.snapshot.children.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        DataSnapshot dataList = response.snapshot.children.toList()[index];

                        Widget itemList() {
                          return dataList.child("professional").value != "4HCtFRnu3xYIyl0nZqPhD7LZtyb2"
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OrderDetailsPage(
                                                  reqID: dataList.key.toString(),
                                                  status: 'true',
                                                )));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                                    decoration: AppWidget().boxShandowGreyRectangule(),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.grey.withOpacity(0.3),
                                          radius: 40,
                                        ),
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
                                              dataList.child("name").value.toString(),
                                              style: TextStyle(color: secondryColor, fontSize: 17, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              Locales.string(context, 'lang_solicitudtext'),
                                              style: TextStyle(color: Colors.black, fontSize: 10),
                                            ),
                                            RatingBarIndicator(
                                                rating: 2.5,
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

                        if (positionFilter == 0) {
                          return itemList();
                        } else {
                          if (dataList.child("state").value == positionFilter) {
                            return itemList();
                          }
                        }
                      });
            } else {
              return AppWidget().loading(context);
            }

            ;
          } catch (e) {
            return AppWidget().loading(context);
          }
        });
  }

  // Pending Orders

  Widget orderItemsPending() {
    return ordersDataLoaded == true
        ? ordersItemsList.isNotEmpty || ordersListLoaded == true
            ? ordersItemsList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: ordersItemsList.length,
                    itemBuilder: (context, index) {
                      return orderDetailsPending(
                        kServices: ordersItemsList[index],
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/no_order.png',
                            width: MediaQuery.of(context).size.width * .5,
                          ),
                        ],
                      ),
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
                        'images/no_order.png',
                        width: MediaQuery.of(context).size.width * .5,
                      ),
                    ],
                  ),
                ),
              )
        : Container(
            color: appcolors.dashboardCard,
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

  // Pending Items

  orderDetailsPending({required OrdersProfesionalModel kServices}) {
    return kServices.status == "Assigned" || kServices.status == "Finished" ? detailsModel(kServices: kServices) : const SizedBox();
  }

  // Previous Orders

  Widget orderItemsCompleted() {
    return ordersDataLoaded == true
        ? ordersItemsList.isNotEmpty || ordersListLoaded == true
            ? ordersItemsList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: ordersItemsList.length,
                    itemBuilder: (context, index) {
                      return orderDetailsCompleted(
                        kServices: ordersItemsList[index],
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/no_order.png',
                            width: MediaQuery.of(context).size.width * .5,
                          ),
                        ],
                      ),
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
                        'images/no_order.png',
                        width: MediaQuery.of(context).size.width * .5,
                      ),
                    ],
                  ),
                ),
              )
        : Container(
            color: appcolors.dashboardCard,
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

  // Previous Items

  orderDetailsCompleted({required OrdersProfesionalModel kServices}) {
    return kServices.status == "Completed" ? detailsModel(kServices: kServices) : const SizedBox();
  }

  //

  //

  //

  //

  //  Service Item Model

  detailsModel({required OrdersProfesionalModel kServices}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          Loader.page(
              context,
              OrderDetailsPage(
                reqID: kServices.key,
                status: kServices.status,
              ));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: appcolors.dashboardBG,
            border: Border.all(color: Colors.black12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Column(
              children: [
                // Image Row

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          kServices.itemsNames!.contains('Air')
                              ? 'images/svg_icons/service_icons/air_conditioner.svg'

                              //  Cleaning

                              : kServices.itemsNames!.contains('Cleaning')
                                  ? 'images/svg_icons/service_icons/cleaning.svg'

                                  // Electrician

                                  : kServices.itemsNames!.contains('Electrician')
                                      ? 'images/svg_icons/service_icons/electrician.svg'
                                      : kServices.itemsNames!.contains('Carpenter')
                                          ? 'images/svg_icons/service_icons/carpenter.svg'

                                          // Else

                                          : 'images/svg_icons/service_icons/carpenter.svg',
                          width: kServices.itemsNames!.contains('Air') ? 25 : 40,
                          height: kServices.itemsNames!.contains('Air') ? 25 : 40,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                            kServices.itemsNames!.contains('Air')
                                ? Locales.string(context, "srvs_ac_services")

                                // Cleaning

                                : kServices.itemsNames!.contains('Cleaning')
                                    ? Locales.string(context, "srvs_cleaning")

                                    // Carpenter

                                    : kServices.itemsNames!.contains('Carpenter')
                                        ? Locales.string(context, "srvs_carpenter")

                                        // Carpenter

                                        : kServices.itemsNames!.contains('Electrician')
                                            ? Locales.string(context, "srvs_electrician")

                                            // Carpenter

                                            : kServices.itemsNames!.contains('Geyser')
                                                ? Locales.string(context, "srvs_geyser")

                                                // Carpenter

                                                : kServices.itemsNames!.contains('Appliances')
                                                    ? Locales.string(context, "srvs_appliance")
                                                    : kServices.itemsNames!.contains('Plumber')
                                                        ? Locales.string(context, "srvs_plumber")
                                                        : kServices.itemsNames!.contains('Painter')
                                                            ? Locales.string(context, "srvs_painter")
                                                            : kServices.itemsNames!.contains('Handyman')
                                                                ? Locales.string(context, "srvs_handyman")
                                                                : '$appName Services',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Roboto-Regular',
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Booking Row

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Locales.string(context, "lbl_booking_for"),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto-Bold',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${kServices.bookforDate!} / ${kServices.bookforTime!}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Brand-Regular',
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // Status Row

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Locales.string(context, "lbl_status"),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto-Bold',
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      MainControllerProfesional.capitalize(kServices.status!),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Brand-Regular',
                        color: kServices.status == "Pending" || kServices.status == "canceled" || kServices.status == "canceled"
                            ? Colors.red
                            : Colors.green,
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
}

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/styles/statics.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/cartController.dart';
import 'package:fullpro/controller/mainController.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/controller/ordersController.dart';
import 'package:fullpro/models/ordersModel.dart';
import 'package:fullpro/pages/profile/orderDetails.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'dart:async';

import 'package:fullpro/widgets/DataLoadedProgress.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);
  static const String id = 'OrdersPage';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

int positionFilter = 1;

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  late TabController _tabController;

  Timer? timer;

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // OrdersController.getOrders(context);

    if (ordersDataLoaded == true && ordersItemsList.isEmpty) {
      OrdersController.getOrders(context);
    }

    if (mounted) {
      CartController.checkCart();
      setState(() {
        if (ordersDataLoaded == false && ordersItemsList.isEmpty) {
          setState(() {
            OrdersController.getOrders(context);
          });
        }
        if (ordersDataLoaded == true && ordersItemsList.isEmpty) {
          setState(() {
            ordersItemsList = Provider.of<AppData>(context, listen: false).requestdata;
          });
        }
      });
    }
    // Repeating Function
    timer = Timer.periodic(
      repeatTime,
      (Timer t) => setState(() {
        // CartController.checkCart();
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ordersItemsList.clear();
    ordersListLoaded = false;
    ordersDataLoaded = false;
    timer?.cancel();
  }

  Widget itemAdd(String url, String title, {Function? tap}) {
    return GestureDetector(
        onTap: () {},
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
                  Container(alignment: Alignment.centerRight, height: 20, child: SvgPicture.asset("images/icons/add.svg")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Static.dashboardCard,
      /* appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leadingWidth: 100,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('images/svg_icons/arrowLeft.svg'),
        ),
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: Static.dashboardBG,
        centerTitle: true,
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),*/
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),

              Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text(
                    "Buscar: ",
                    style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  itemAdd("images/icons/shoping.svg", "Usuario", tap: () {}),
                  SizedBox(
                    width: 10,
                  ),
                  itemAdd("images/icons/profesional.svg", "Profesional", tap: () {}),
                  SizedBox(
                    width: 10,
                  ),
                  itemAdd(
                    "images/icons/userCircle.svg",
                    "Servicios",
                    tap: () {},
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        "Historial: ",
                        style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  Expanded(child: SizedBox()),
                  Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Row(
                        children: [
                          Text(
                            "Filtro",
                            style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            "images/icons/add.svg",
                            width: 23,
                            color: secondryColor,
                          ),
                        ],
                      )),
                  SizedBox(
                    width: 50,
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
                      Container(
                          width: 110,
                          child: AppWidget().buttonShandow("Pendiente",
                              color: positionFilter != 1 ? Colors.grey.withOpacity(0.2) : redButton, colorText: Colors.white, tap: () {
                            positionFilter = 1;
                            setState(() {});
                          })),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: 110,
                          child: AppWidget().buttonShandow("En curso",
                              color: positionFilter != 2 ? Colors.grey.withOpacity(0.2) : yellowButton, colorText: Colors.white, tap: () {
                            positionFilter = 2;
                            setState(() {});
                          })),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: 110,
                          child: AppWidget().buttonShandow("Terminado",
                              color: positionFilter != 3 ? Colors.grey.withOpacity(0.2) : greenButton, colorText: Colors.white, tap: () {
                            positionFilter = 3;
                            setState(() {});
                          })),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              /*  Container(
                color: Colors.white,
                child: TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.red,
                  tabs: [
                    Tab(
                      text: Locales.string(context, 'lbl_active'),
                    ),
                    Tab(
                      text: Locales.string(context, 'lbl_previous'),
                    ),
                    Tab(
                      text: Locales.string(context, 'lbl_completed'),
                    )
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),*/

              Expanded(
                  child: Column(
                children: [
                  positionFilter != 1 ? SizedBox() : OrderItemsPending(),

                  //
                  // Current Orders TabView
                  positionFilter != 2
                      ? SizedBox()
                      : /*Scaffold(
                          backgroundColor: Static.dashboardCard,
                          body: Padding(
                            padding: const EdgeInsets.all(8),
                            child:*/
                      OrderItemsCanceled(),
                  //      ),
                  //  ),

                  //
                  // Completed Orders TabView
                  positionFilter != 3 ? SizedBox() : OrderItemsCompleted(),
                ],
              )),
              /*  Expanded(
                child: TabBarView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    //
                    // Pending Orders TabView
                    Scaffold(
                      backgroundColor: Colors.white,
                      body: Padding(
                        padding: const EdgeInsets.all(8),
                        child: OrderItemsPending(),
                      ),
                    ),
                    //
                    // Current Orders TabView
                    Scaffold(
                      backgroundColor: Static.dashboardCard,
                      body: Padding(
                        padding: const EdgeInsets.all(8),
                        child: OrderItemsCanceled(),
                      ),
                    ),

                    //
                    // Completed Orders TabView
                    Scaffold(
                      backgroundColor: Static.dashboardCard,
                      body: Padding(
                        padding: const EdgeInsets.all(8),
                        child: OrderItemsCompleted(),
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),*/
              //
              //   const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Pending Orders
  Widget OrderItemsPending() {
    return ordersDataLoaded == true
        ? ordersItemsList.isNotEmpty || ordersListLoaded == true
            ? ordersItemsList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: ordersItemsList.length,
                    itemBuilder: (context, index) {
                      return OrderDetailsPending(
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

  // Pending Items
  OrderDetailsPending({required OrdersModel kServices}) {
    return kServices.status == Locales.string(context, "lbl_pending") || kServices.status == Locales.string(context, "lbl_assigned")
        ? detailsModel(kServices: kServices)
        : const SizedBox();
  }

  // Previous Orders
  Widget OrderItemsCompleted() {
    return ordersDataLoaded == true
        ? ordersItemsList.isNotEmpty || ordersListLoaded == true
            ? ordersItemsList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: ordersItemsList.length,
                    itemBuilder: (context, index) {
                      return OrderDetailsCompleted(
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

  // Previous Items
  OrderDetailsCompleted({required OrdersModel kServices}) {
    return kServices.status == Locales.string(context, "lbl_completed") ? detailsModel(kServices: kServices) : const SizedBox();
  }

  // Canceled Orders
  Widget OrderItemsCanceled() {
    return ordersDataLoaded == true
        ? ordersItemsList.isNotEmpty || ordersListLoaded == true
            ? ordersItemsList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: ordersItemsList.length,
                    itemBuilder: (context, index) {
                      return OrderDetailsCanceled(
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

  // Canceled Items
  OrderDetailsCanceled({required OrdersModel kServices}) {
    return kServices.status == Locales.string(context, "lbl_canceled") || kServices.status == Locales.string(context, 'lbl_finished')
        ? detailsModel(kServices: kServices)
        : const SizedBox();
  }

  //
  //
  //
  //
  //  Service Item Model
  detailsModel({required OrdersModel kServices}) {
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
            color: Static.dashboardBG,
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
                    Container(
                      child: Text(
                        '${kServices.bookforDate!} / ${kServices.bookforTime!}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Brand-Regular',
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Order Numer Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Locales.string(context, "lbl_order_number"),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto-Bold',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      kServices.orderNumber!,
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
                      MainController.capitalize(kServices.status!),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Brand-Regular',
                        color: kServices.status == Locales.string(context, "lbl_pending") ||
                                kServices.status == Locales.string(context, "lbl_canceled") ||
                                kServices.status == Locales.string(context, "lbl_canceled")
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

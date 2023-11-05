import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/controllers/orderController.dart';
import 'package:fullpro/PROFESIONAL/models/ordersModel.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/views/Orders/orderDetail.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';
import 'package:fullpro/PROFESIONAL/widget/accountHold.dart';

import 'dart:async';
import 'package:fullpro/styles/statics.dart' as appcolors;

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);
  static const String id = 'MyOrders';

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    super.dispose();
    ordersItemsList.clear();
    ordersListLoaded = false;
    ordersDataLoaded = false;
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: appcolors.dashboardCard,
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: Container(
          color: appcolors.dashboardCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
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
                      text: Locales.string(context, 'lbl_completed'),
                    )
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    //
                    // Active Orders TabView
                    Scaffold(
                      backgroundColor: appcolors.dashboardCard,
                      body: Padding(
                        padding: const EdgeInsets.all(8),
                        child: /*dueBalanceValue > dueLimit! ? const AccountHold() : */ orderItemsPending(),
                      ),
                    ),

                    //
                    // Completed Orders TabView
                    Scaffold(
                      backgroundColor: appcolors.dashboardCard,
                      body: Padding(
                        padding: const EdgeInsets.all(8),
                        child: dueBalanceValue > dueLimit! ? const AccountHold() : orderItemsCompleted(),
                      ),
                    ),
                  ],
                ),
              ),
              //
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
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

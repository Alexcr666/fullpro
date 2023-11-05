// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/controllers/orderListController.dart';
import 'package:fullpro/PROFESIONAL/models/ordersModel.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';
import 'package:fullpro/PROFESIONAL/widget/accountHold.dart';

import 'dart:async';
import 'package:fullpro/styles/statics.dart' as appcolors;

import 'orderListDetails.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);
  static const String id = 'OrdersList';

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? timer;

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    OrderListController.getOrdersList(context);

    if (ordersAvailableDataLoaded == true && ordersAvailableItemsList.isEmpty) {
      OrderListController.getOrdersList(context);
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
    ordersAvailableItemsList.clear();
    ordersAvailableListLoaded = false;
    ordersAvailableDataLoaded = false;
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
          Locales.string(context, "lbl_orders_list"),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: dueBalanceValue >= dueLimit! ? const AccountHold() : orderItemsPending(),
        ),
      ),
    );
  }

  // Pending Orders
  Widget orderItemsPending() {
    return ordersAvailableDataLoaded == true
        ? ordersAvailableItemsList.isNotEmpty || ordersAvailableListLoaded == true
            ? ordersAvailableItemsList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: ordersAvailableItemsList.length,
                    itemBuilder: (context, index) {
                      return orderDetailsPending(
                        kServices: ordersAvailableItemsList[index],
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
    return kServices.status == "Pending" ? detailsModel(kServices: kServices) : const SizedBox();
  }

  //  Service Item Model
  detailsModel({required OrdersProfesionalModel kServices}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          Loader.page(
              context,
              OrderListDetailsPage(
                reqID: kServices.key,
                status: kServices.status,
                bookerToken: kServices.bookerToken,
                orderNumber: kServices.orderNumber,
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
                      Locales.string(context, "lbl_address"),
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto-Bold',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        MainControllerProfesional.capitalize(kServices.address!),
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.black,
                        ),
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

  //
  //
  //
  //
}

// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/controllers/orderController.dart';
import 'package:fullpro/PROFESIONAL/models/ordersModel.dart';
import 'package:fullpro/PROFESIONAL/provider/Appdata.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/utils/userpreferences.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';
import 'package:fullpro/PROFESIONAL/widget/declineReason.dart';
import 'package:provider/provider.dart';

import 'package:fullpro/styles/statics.dart' as appcolors;

import 'dart:async';

class OrderDetailsPage extends StatefulWidget {
  static const String id = 'OrderDetailsPage';
  final String? reqID;
  final String? status;
  const OrderDetailsPage({Key? key, required this.reqID, required this.status}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? timer;
  OrdersProfesionalModel? ordersData;

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
  }

  void getOrdersData() {
    DatabaseReference currentReq = FirebaseDatabase.instance.ref().child('requests').child(widget.reqID!);

    currentReq.once().then((e) async {
      final snapshot = e.snapshot;
      if (snapshot.value != null) {
        ordersData = OrdersProfesionalModel.fromSnapshot(snapshot);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (orderDetailsDataLoaded == true && orderDetailsItemsList.isEmpty) {
      OrderController.getOrderDetailsKeys(widget.reqID!, context);
      getOrdersData();
    }

    if (mounted) {
      setState(() {
        if (orderDetailsDataLoaded == false && orderDetailsItemsList.isEmpty) {
          setState(() {
            OrderController.getOrderDetailsKeys(widget.reqID!, context);
            getOrdersData();
          });
        }
        if (orderDetailsDataLoaded == true && orderDetailsItemsList.isEmpty) {
          setState(() {
            orderDetailsItemsList = Provider.of<AppData>(context, listen: false).orderDetailsData;
          });
        }
      });
    }
    // Repeating Function
    timer = Timer.periodic(
      const Duration(microseconds: 2000),
      (Timer t) => setState(() {}),
    );
  }

  @override
  void dispose() {
    super.dispose();
    orderDetailsItemsList.clear();
    ordersListLoaded = false;
    orderDetailsDataLoaded = false;
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: appcolors.dashboardBG,
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
          Locales.string(context, 'lbl_order_details'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: orderDetailsItemsList.isEmpty
          ? Center(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: orderDetailsItemsList.isNotEmpty ? orderDetailsItemsList.length * 125 : 300,
                        width: double.infinity,
                        color: appcolors.dashboardBG,
                        child: orderItemsWidget(),
                      ),
                      ordersData?.address == null ? const SizedBox() : ordersDataWidget(),
                    ],
                  ),
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: orderDetailsItemsList.isNotEmpty ? orderDetailsItemsList.length * 125 : 300,
                      width: double.infinity,
                      color: appcolors.dashboardBG,
                      child: orderItemsWidget(),
                    ),
                    ordersData?.address == null ? const SizedBox() : ordersDataWidget(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget ordersDataWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderDetailsItemsList.isNotEmpty ? Locales.string(context, 'lbl_location') : '',
                style: const TextStyle(
                  fontFamily: 'Brand-Bold',
                  fontSize: 18,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ordersData?.address != null ? '${ordersData?.address.toString()}' : ' ',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderDetailsItemsList.isNotEmpty ? Locales.string(context, 'lbl_selected_schedule') : '',
                style: const TextStyle(
                  fontFamily: 'Brand-Bold',
                  fontSize: 18,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ordersData?.bookforDate != null
                          ? ' ${ordersData?.bookforDate.toString()}  /  ${ordersData?.bookforTime.toString()}'
                          : ' ',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Locales.string(context, 'lbl_total_price'),
                style: const TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 18,
                ),
              ),
              Text(
                ordersData?.totalprice != null
                    ? currencyPos == 'left'
                        ? '$currencySymbol${UserPreferences.getUserEarning() ?? ordersData?.totalprice.toString()}'
                        : '${UserPreferences.getUserEarning() ?? ordersData?.totalprice.toString()}$currencySymbol'
                    : currencyPos == 'left'
                        ? '$currencySymbol${'0'}'
                        : '${'0'}$currencySymbol',
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto-Bold',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),

        //  Order Completed
        const SizedBox(height: 15),
        widget.status == "Completed"
            ? Column(
                children: [
                  Text(Locales.string(context, 'lbl_order_completed')),
                  const SizedBox(height: 10),
                  const Icon(
                    FeatherIcons.checkCircle,
                    color: Colors.greenAccent,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : const SizedBox(),
        //
        // Finish Order Button
        widget.status == "Assigned"
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      MainControllerProfesional.bottomSheet(
                        context,
                        Locales.string(context, 'lbl_are_you_sure_to_finish'),
                        finishOrder(widget.reqID, context),
                      );
                    },
                    child: Text(Locales.string(context, 'lbl_finish_work')),
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 10),

        // Finish Order Button
        widget.status == "Finished"
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {
                      MainControllerProfesional.bottomSheet(
                        context,
                        Locales.string(context, 'lbl_send_request_for_payment'),
                        () {
                          payRequest(widget.reqID, context);
                        },
                      );
                    },
                    child: Text(Locales.string(context, 'lbl_request_payment')),
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 10),

        // Decline Order Button
        widget.status == "Assigned"
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    color: appcolors.themeColor[500],
                    textColor: Colors.white,
                    onPressed: () {
                      MainControllerProfesional.bottomSheet(
                        context,
                        Locales.string(context, 'lbl_are_you_sure_to_decline'),
                        () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => DeclineReasonDialog(
                              reqID: widget.reqID!,
                              partnerID: ordersData!.partnerID!,
                            ),
                          );
                        },
                      );
                    },
                    child: Text(Locales.string(context, 'lbl_decline_order')),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget orderItemsWidget() {
    return orderDetailsDataLoaded == true
        ? orderDetailsItemsList.isNotEmpty || ordersListLoaded == true
            ? orderDetailsItemsList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: orderDetailsItemsList.length,
                    itemBuilder: (context, index) {
                      return servicesComponent(
                        kServices: orderDetailsItemsList[index],
                      );
                    },
                  )
                : Container(
                    color: appcolors.dashboardBG,
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
                  )
            : Center(
                child: Container(
                color: appcolors.dashboardBG,
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
              ))
        : Container(
            color: appcolors.dashboardBG,
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

  servicesComponent({required OrdersProfesionalModel kServices}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: appcolors.dashboardCard,
          border: Border.all(color: Colors.black12),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                kServices.image!,
                width: 85,
                height: 85,
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
                      fontFamily: 'Brand-Bold',
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  kServices.chargemod!,
                  style: const TextStyle(
                    color: appcolors.colorTextLight,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Row(
                    children: [
                      kServices.discount! != '0'
                          ? Text(
                              currencyPos == 'left'
                                  ? '$currencySymbol${UserPreferences.getUserEarning() ?? int.parse(kServices.price!)}'
                                  : '${UserPreferences.getUserEarning() ?? int.parse(kServices.price!)}$currencySymbol',
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.black,
                                decorationThickness: 2,
                              ),
                            )
                          : const SizedBox(),
                      kServices.discount! != '0' ? const SizedBox(width: 15) : const SizedBox(),
                      Text(
                        currencyPos == 'left'
                            ? '$currencySymbol${UserPreferences.getUserEarning() ?? int.parse(kServices.price!) - int.parse(kServices.discount!)}'
                            : '${UserPreferences.getUserEarning() ?? int.parse(kServices.price!) - int.parse(kServices.discount!)}$currencySymbol',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        color: appcolors.dashboardBG,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Row(
                        children: [
                          Text(Locales.string(context, 'lbl_quantity_x')),
                          Text(
                            kServices.quantity!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  finishOrder(String? reqID, context) {
    // Update Order Data
    DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('requests').child(reqID!);

    orderRef.update({'status': "Finished"});

    orderRef.once().then((e) {
      final snapshot = e.snapshot;
      String token = snapshot.child('booker_token').value.toString();
      String amount = snapshot.child('totalprice').value.toString();

      MainControllerProfesional.sendPaymentNoti(
        '$appName ${Locales.string(context, 'lbl_order_completed')}',
        '${Locales.string(context, 'lbl_pay_now')}: $amount',
        token,
        amount,
        reqID,
        context,
      );
    });

    Navigator.pop(context);
    //Navigator.pop(context);
    // Navigator.pop(context);

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
                  Image.asset(
                    'images/confirm/chear.gif',
                    width: 300,
                  ),
                  Text(
                    Locales.string(context, 'lbl_order_finished'),
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    Locales.string(context, 'lbl_as_for_payment'),
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(Locales.string(context, 'lbl_close')),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  payRequest(String? reqID, context) {
    // Update Order Data
    DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('requests').child(reqID!);

    orderRef.once().then((e) {
      final snapshot = e.snapshot;
      String token = snapshot.child('booker_token').value.toString();
      String amount = snapshot.child('totalprice').value.toString();

      MainControllerProfesional.sendPaymentNoti(
        '$appName ${Locales.string(context, 'lbl_order_completed')}',
        '${Locales.string(context, 'lbl_pay_now')}: $amount',
        token,
        amount,
        reqID,
        context,
      );
    });

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

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
                    FeatherIcons.checkCircle,
                    color: Colors.green,
                    size: 40,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    Locales.string(context, 'lbl_payment_request_sent'),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        Locales.string(context, 'lbl_close'),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

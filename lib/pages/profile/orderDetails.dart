import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullpro/animation/fadeBottom.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/widgets/widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/ordersController.dart';
import 'package:fullpro/models/ordersModel.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'dart:async';

import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/cancelReason.dart';

class OrderDetailsPage extends StatefulWidget {
  static const String id = 'OrderDetailsPage';
  final String? reqID;
  final String? status;
  const OrderDetailsPage({required this.reqID, required this.status});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Timer? timer;
  String showMe = "woman";

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  OrdersModel? ordersData;

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
  }

  void getOrdersData() {
    DatabaseReference currentReq = FirebaseDatabase.instance.ref().child('requests').child(widget.reqID!);

    currentReq.once().then((e) async {
      final snapshot = e.snapshot;
      if (snapshot.value != null) {
        ordersData = OrdersModel.fromSnapshot(snapshot);
        print(ordersData!.address);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (orderDetailsDataLoaded == true && orderDetailsItemsList.isEmpty) {
      OrdersController.getOrderDetailsKeys(widget.reqID!, context);
      getOrdersData();
    }

    if (mounted) {
      setState(() {
        if (orderDetailsDataLoaded == false && orderDetailsItemsList.isEmpty) {
          setState(() {
            OrdersController.getOrderDetailsKeys(widget.reqID!, context);
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
    // TODO: implement dispose
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
        backgroundColor: Colors.white,
        /*  appBar: AppBar(
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
        backgroundColor: Static.dashboardBG,
        centerTitle: true,
        title: Text(
          Locales.string(context, 'lbl_order_details'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),*/
        // appBar: AppWidget().,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Resumen",
                      style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    Expanded(child: SizedBox()),
                    SvgPicture.asset(
                      "assets/icons/edit.svg",
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Domicilio",
                      style: TextStyle(color: secondryColor, fontSize: 18),
                    )),
                ordersData?.address == null ? const SizedBox() : OrdersData(),

                //  fadeBottom(.6, AddressWidget()),
                SizedBox(
                  height: 20,
                ),

                orderDetailsItemsList.isEmpty
                    ? Center(
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: orderDetailsItemsList.isNotEmpty ? orderDetailsItemsList.length * 125 : 300,
                                  width: double.infinity,
                                  color: Static.dashboardBG,
                                  child: OrderItems(),
                                ),
                                // ordersData?.address == null ? const SizedBox() : OrdersData(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: orderDetailsItemsList.isNotEmpty ? orderDetailsItemsList.length * 125 : 300,
                                  width: double.infinity,
                                  color: Static.dashboardBG,
                                  child: OrderItems(),
                                ),
                                // ordersData?.address == null ? const SizedBox() : OrdersData(),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            )),
            Container(
                margin: EdgeInsets.only(top: 25, bottom: 25),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total a pagar".toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: secondryColor,
                          ),
                        ),
                        Text(
                          currencyPos == 'left' ? '$currencySymbol' : '$ktotalprice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: secondryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Flexible(
                        child: widget.status == Locales.string(context, 'lbl_canceled') ||
                                widget.status == Locales.string(context, 'lbl_canceled')
                            ? Column(
                                children: [
                                  const Divider(),
                                  Text(Locales.string(context, 'lbl_order_canceled'), style: const TextStyle(color: Colors.red)),
                                  const Divider(),
                                ],
                              )
                            : widget.status == Locales.string(context, 'lbl_assigned')
                                ? Column(
                                    children: [
                                      const Divider(),
                                      Text(Locales.string(context, 'lbl_provider_assigned'), style: const TextStyle(color: Colors.green)),
                                      const Divider(),
                                      const SizedBox(height: 5),
                                      Text(Locales.string(context, 'lbl_need_help'), style: const TextStyle(color: Colors.black)),
                                      const SizedBox(height: 3),
                                      GestureDetector(
                                        onTap: () {
                                          //
                                        },
                                        child: Text('${Locales.string(context, 'lbl_call')} $helpPhone',
                                            style: const TextStyle(color: Colors.black)),
                                      ),
                                    ],
                                  )
                                : widget.status == Locales.string(context, 'lbl_finished') ||
                                        widget.status == Locales.string(context, 'lbl_completed')
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            padding: const EdgeInsets.all(15),
                                            elevation: 0,
                                            color: Static.themeColor[500],
                                            textColor: Colors.white,
                                            onPressed: () {
                                              showModalBottomSheet(
                                                enableDrag: true,
                                                isDismissible: false,
                                                backgroundColor: Static.dashboardBG,
                                                context: context,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                                ),
                                                builder: (context) => Padding(
                                                  padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 10),
                                                  child: Wrap(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 20),
                                                        child: Text(
                                                          Locales.string(context, 'lbl_are_you_sure_to_cancel'),
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 50, top: 30),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            MaterialButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              elevation: 0.0,
                                                              hoverElevation: 0.0,
                                                              focusElevation: 0.0,
                                                              highlightElevation: 0.0,
                                                              color: Static.dashboardCard,
                                                              textColor: Colors.black,
                                                              minWidth: 50,
                                                              height: 15,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 50,
                                                                vertical: 20,
                                                              ),
                                                              child: Text(Locales.string(context, 'lbl_cancel')),
                                                            ),
                                                            MaterialButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                                showDialog(
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  builder: (BuildContext context) => DeclineReasonDialog(
                                                                    reqID: widget.reqID!,
                                                                    bookerID: ordersData!.booker_id!,
                                                                  ),
                                                                );
                                                              },
                                                              elevation: 0.0,
                                                              hoverElevation: 0.0,
                                                              focusElevation: 0.0,
                                                              highlightElevation: 0.0,
                                                              color: Colors.red,
                                                              textColor: Colors.white,
                                                              minWidth: 50,
                                                              height: 15,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 50,
                                                                vertical: 20,
                                                              ),
                                                              child: Text(Locales.string(context, 'lbl_confirm')),
                                                            ),
                                                            const SizedBox(height: 20),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(Locales.string(context, 'lbl_cancel_order')),
                                          ),
                                        ),
                                      )),
                  ],
                )),
          ],
        ));
  }

  Widget OrdersData() {
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
              /* Text(
                orderDetailsItemsList.isNotEmpty ? Locales.string(context, 'lbl_location') : '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ordersData?.address != null ? ' ${ordersData?.address.toString()}' : ' ',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: secondryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                    width: 160,
                    height: 160,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ))),
            SizedBox(
              width: 20,
            ),
            Flexible(
                child: AppWidget().texfieldFormat(
              title: "Apt 501",
            )),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(
              "Opción de servicio".toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: secondryColor,
              ),
            ),
            subtitle: DropdownButton(
              iconEnabledColor: primaryColor,
              iconDisabledColor: secondryColor,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  child: Text("Man".toString()),
                  value: "man",
                ),
                DropdownMenuItem(child: Text("Other".toString()), value: "woman"),
                DropdownMenuItem(child: Text("Other".toString()), value: "other"),
              ],
              onChanged: (val) {
                //  editInfo.addAll({'userGender': val});

                setState(() {
                  showMe = val.toString();
                });
              },
              value: showMe,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          height: 1,
          color: secondryColor,
        ),
        SizedBox(
          height: 10,
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    orderDetailsItemsList.isNotEmpty ? "Hora de servicio" : '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: secondryColor),
                  )),
                  Text(
                    ordersData?.bookforDate != null
                        ? ' ${ordersData?.bookforDate.toString()}  /  ${ordersData?.bookforTime.toString()}'
                        : ' ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: secondryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          height: 1,
          color: secondryColor,
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderDetailsItemsList.isNotEmpty ? Locales.string(context, 'lbl_assigned_provider') : '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: secondryColor),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Static.dashboardCard,
                        child: Icon(
                          FeatherIcons.user,
                          color: secondryColor,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      ordersData?.partner_name != null ? ' ${ordersData?.partner_name.toString()}' : ' ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: secondryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  ordersData?.partner_name == Locales.string(context, 'lbl_waiting')
                      ? null
                      : launchUrl(Uri.parse("tel://${ordersData?.partnerPhone}"));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Static.dashboardCard,
                          child: Icon(
                            FeatherIcons.phone,
                            color: secondryColor,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Text(
                        ordersData?.partnerPhone != null ? ' ${ordersData?.partnerPhone.toString()}' : ' ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: secondryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        /*   Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${Locales.string(context, 'lbl_total_price')}:',
                style: const TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 15,
                ),
              ),
              Text(
                ordersData?.totalprice != null
                    ? currencyPos == 'left'
                        ? '$currencySymbol${ordersData?.totalprice.toString()}'
                        : '${ordersData?.totalprice.toString()}$currencySymbol'
                    : '$currencySymbol.0',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),*/
        const SizedBox(height: 15),
        widget.status == Locales.string(context, 'lbl_finished')
            ? Column(
                children: [
                  Text(Locales.string(context, 'lbl_assigned_provider_finished_work')),
                  const SizedBox(height: 10),
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    elevation: 0,
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      //
                      OrdersController.payPartner(ordersData?.partner, ordersData?.totalprice, widget.reqID, context);
                    },
                    child: Text('${Locales.string(context, 'lbl_pay_now')} ━━━'),
                  ),
                ],
              )
            : const SizedBox(),

        //
        //  Order Completed
        const SizedBox(height: 15),
        widget.status == Locales.string(context, 'lbl_completed')
            ? Column(
                children: [
                  Text(Locales.string(context, 'lbl_order_is_completed')),
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
        // Cancel Order Button
      ],
    );
  }

  Widget OrderItems() {
    return orderDetailsDataLoaded == true
        ? orderDetailsItemsList.isNotEmpty || ordersListLoaded == true
            ? orderDetailsItemsList.isNotEmpty
                ? ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: orderDetailsItemsList.length,
                    itemBuilder: (context, index) {
                      return ServicesComponent(
                        kServices: orderDetailsItemsList[index],
                      );
                    },
                  )
                : Container(
                    color: Static.dashboardBG,
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
                color: Static.dashboardBG,
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
            color: Static.dashboardBG,
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

  ServicesComponent({required OrdersModel kServices}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Static.dashboardCard,
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
                        fontFamily: 'Brand-Bold',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    kServices.chargemod!,
                    style: const TextStyle(
                      color: Static.colorTextLight,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Row(
                      children: [
                        /* changed  kServices.discount! != '0'
                            ? Text(
                                currencyPos == 'left'
                                    ? '$currencySymbol${int.parse(kServices.price!)}'
                                    : '${int.parse(kServices.price!)}$currencySymbol',
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.black,
                                  decorationThickness: 2,
                                ),
                              )
                            : const SizedBox(),*/
                        kServices.discount! != '0' ? const SizedBox(width: 15) : const SizedBox(),
                        /* changed Text(
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
                            color: Static.dashboardBG,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

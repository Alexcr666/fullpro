import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
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

class subServicePage extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const subServicePage({Key? key, required this.serviceId, required this.serviceName}) : super(key: key);

  static const String id = 'subServicesPage';

  @override
  _subServicePageState createState() => _subServicePageState();
}

class _subServicePageState extends State<subServicePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      CartController.checkCart();
      setState(() {
        if (catDataLoaded == false && categoryServicesList.isEmpty) {
          setState(() {
            CategoryController.getSingleServiceCat(widget.serviceId, context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Static.dashboardCard,
      bottomNavigationBar: UserPreferences.getcartStatus() == 'full' || cartStatus == 'full' ? const CartBottomButton() : const SizedBox(),
      appBar: AppBar(
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
            const SizedBox(height: 5),
            SizedBox(
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
                  hintText: Locales.string(context, 'lbl_search'),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: leftPadding,
            right: rightPadding,
            bottom: bottomPadding,
            top: topPadding,
          ),
          child: catDataLoaded == true
              ? categoryServicesList.isNotEmpty || catListLoaded == true
                  ? categoryServicesList.isNotEmpty
                      ? fadeTop(
                          0.3,
                          ListView.separated(
                            separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                            itemCount: categoryServicesList.length,
                            itemBuilder: (context, index) {
                              return ServicesComponent(
                                kServices: categoryServicesList[index],
                              );
                            },
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
                ),
        ),
      ),
    );
  }

  ServicesComponent({required SingleServices kServices}) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Static.dashboardBG,
            border: Border.all(color: Colors.black12),
          ),
          padding: EdgeInsets.all(10),
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
                        fontFamily: 'Roboto-Bold',
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
                        kServices.discount! != '0' ? const SizedBox(width: 15) : const SizedBox(),
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
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.green,
                              ),
                              Text(
                                kServices.rating!,
                              ),
                            ],
                          ),
                        ),
                        //
                        SizedBox(width: MediaQuery.of(context).size.width * .15),
                        GestureDetector(
                          onTap: () {
                            CartController.getCartData(context, false, kServices.key, kServices.name, kServices.rating, kServices.image,
                                kServices.chargemod, kServices.price, kServices.discount);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Static.themeColor[500],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  Locales.string(context, 'lbl_add'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        )
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

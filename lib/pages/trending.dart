import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/cartController.dart';
import 'package:fullpro/controller/trendingController.dart';
import 'package:fullpro/models/trendingServices.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/cartBottomButton.dart';

class kTrending extends StatefulWidget {
  const kTrending({Key? key}) : super(key: key);
  static const String id = 'kTrending';

  @override
  _kTrendingState createState() => _kTrendingState();
}

class _kTrendingState extends State<kTrending> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int simpleIntInput = 0;
  Timer? timer;

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 2));
    CartController.checkCart();
  }

  Future<void> LoadData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        if (trendingListLoaded == false) {
          trendingItemsList = Provider.of<AppData>(context, listen: false).trendingServicedata;
          trendingListLoaded = true;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (trendingDataLoaded == true && trendingItemsList.isEmpty) {
      TrendingController.getTrendingServices(context);
    }

    if (mounted) {
      CartController.checkCart();
      setState(() {
        if (trendingDataLoaded == false && trendingItemsList.isEmpty) {
          setState(() {
            TrendingController.getTrendingServices(context);
          });
        }
        if (trendingDataLoaded == true && trendingItemsList.isEmpty) {
          setState(() {
            trendingItemsList = Provider.of<AppData>(context, listen: false).trendingServicedata;
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // trendingItemsList.clear();
    // trendingListLoaded = false;
    // trendingDataLoaded = false;
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // LoadData();
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Static.dashboardCard,
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
          elevation: .7,
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            Locales.string(context, 'title_trending'),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        bottomNavigationBar: UserPreferences.getcartStatus() == 'full' || cartStatus == 'full' ? const CartBottomButton() : null,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: leftPadding,
              right: rightPadding,
              bottom: bottomPadding,
              top: topPadding,
            ),
            child: trendingItems(),
          ),
        ),
      ),
    );
  }

  Widget trendingItems() {
    return trendingDataLoaded == true
        ? trendingItemsList.isNotEmpty || trendingListLoaded == true
            ? trendingItemsList.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                    itemCount: trendingItemsList.length,
                    itemBuilder: (context, index) {
                      return ServicesComponent(
                        kServices: trendingItemsList[index],
                      );
                    },
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
                  )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'images/icons/404.svg',
                        width: MediaQuery.of(context).size.width * .7,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        Locales.string(context, 'error_nothing_found_heading'),
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto-Bold',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        Locales.string(context, 'error_nothing_found_description'),
                        style: const TextStyle(
                          color: Static.colorTextLight,
                          fontFamily: 'Brand-Regular',
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
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

  ServicesComponent({required TrendingServices kServices}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Static.dashboardBG,
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
                        kServices.discount! != '0'
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
                            : const SizedBox(),
                        kServices.discount! != '0' ? const SizedBox(width: 15) : const SizedBox(),
                        Text(
                          currencyPos == 'left'
                              ? '$currencySymbol${int.parse(kServices.price!) - int.parse(kServices.discount!)}'
                              : '${int.parse(kServices.price!) - int.parse(kServices.discount!)}$currencySymbol',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
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

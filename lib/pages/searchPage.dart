import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/animation/fadeTop.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/cartController.dart';
import 'package:fullpro/controller/searchController.dart';
import 'package:fullpro/models/searchServices.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/styles/statics.dart' as Static;
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/cartBottomButton.dart';

class kSearchPage extends StatefulWidget {
  static const String id = 'subServicesPage';

  @override
  _kSearchPageState createState() => _kSearchPageState();
}

class _kSearchPageState extends State<kSearchPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (mounted) {
      CartController.checkCart();
      setState(() {
        if (searchDataLoaded == false && singleFoundedServices.isEmpty) {
          setState(() {
            //changed  SearchController.getSearchServices(context);
          });
        }
        if (searchDataLoaded == true && singleFoundedServices.isEmpty) {
          setState(() {
            singleFoundedServices = Provider.of<AppData>(context, listen: false).searchServicedata;
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
      singleFoundedServices = Provider.of<AppData>(context, listen: false)
          .searchServicedata
          .where((Services) => Services.name!.toLowerCase().contains(search))
          .toList();
      searchListLoaded = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // singleFoundedServices.clear();
    // searchDataLoaded = false;
    // searchListLoaded = false;
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: Static.dashboardCard,
      bottomNavigationBar: UserPreferences.getcartStatus() == 'full' || cartStatus == 'full' ? const CartBottomButton() : const SizedBox(),
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
        elevation: .8,
        toolbarHeight: 70,
        backgroundColor: Static.dashboardBG,
        title: SizedBox(
          height: 50,
          child: TextField(
            autofocus: true,
            onChanged: (value) => onSearch(value),
            decoration: InputDecoration(
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(width: 1.0, color: Static.colorTextLight)),
              fillColor: Static.dashboardBG,
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
              hintText: Locales.string(context, 'lbl_search') + "ds",
            ),
          ),
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
          child: searchDataLoaded == true && searchListLoaded == true
              ? Container(
                  color: Static.dashboardCard,
                  child: singleFoundedServices.isNotEmpty
                      ? fadeTop(
                          0.3,
                          ListView.separated(
                            separatorBuilder: (BuildContext context, int index) => const SizedBox(),
                            itemCount: singleFoundedServices.length,
                            itemBuilder: (context, index) {
                              return ServicesComponent(
                                kServices: singleFoundedServices[index],
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
                                  // "Sorry, the keyword you entered cannot be found, please check again or search with another keyword.",
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
                        ))
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

  ServicesComponent({required SearchServicesModel kServices}) {
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
                  errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.withOpacity(0.3),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 30,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    );
                  },
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
                    // width: MediaQuery.of(context).size.width * .5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
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

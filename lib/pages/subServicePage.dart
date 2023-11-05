import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullpro/pages/INTEGRATION/styles/color.dart';
import 'package:fullpro/widgets/widget.dart';
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
  TextEditingController search = TextEditingController();
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
                  height: 30,
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
                      "Solicitudes",
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
                    Flexible(child: AppWidget().buttonFormLine(context, "Servicio", false, tap: () {})),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(child: AppWidget().buttonFormLine(context, "Inspección", true, tap: () {})),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: AppWidget().texfieldFormat(
                        controller: search,
                        title: Locales.string(context, 'lbl_search'),
                        execute: () {
                          onSearch(search.text.toString());
                        })),
                SizedBox(
                  height: 10,
                ),
                Expanded(
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
                          )),
              ],
            )),
      ),
    );
  }

  ServicesComponent({required SingleServices kServices}) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  insetPadding: EdgeInsets.all(0),
                  contentPadding: EdgeInsets.all(0),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: double.infinity,
                          child: Text(
                            "Información del servicio",
                            style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          kServices.image!,
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
                                    "Nombre del servicio",
                                    style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Categoria",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RatingBarIndicator(
                                      rating: 2.5,
                                      itemCount: 5,
                                      itemSize: 30.0,
                                      itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: secondryColor,
                                          )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )),
                          Column(
                            children: [],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              });
        },
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
                      Row(
                        children: [
                          Container(
                              width: 160,
                              child: Text(
                                kServices.name!,
                                style: TextStyle(color: secondryColor, fontWeight: FontWeight.bold),
                              )),
                          Container(
                              width: 80,
                              child: GestureDetector(
                                onTap: () {
                                  CartController.getCartData(context, false, kServices.key, kServices.name, kServices.rating,
                                      kServices.image, kServices.chargemod, kServices.price, kServices.discount);
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
                                        "Solicitar",
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
                        kServices.chargemod!,
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
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: secondryColor,
                                  ),
                                  Text(
                                    kServices.rating!,
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
